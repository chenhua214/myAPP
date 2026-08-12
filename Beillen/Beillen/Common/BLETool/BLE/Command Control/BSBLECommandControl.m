//
//  BSBLECommandControl.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSBLECommandControl.h"
#import "BSDeviceBLE.h"
#import "BSGCDTimer.h"
#import "BSBLECommandModel.h"

//指令响应超时时间
#define kBSDefaultCommandResponseTimeoutInterval 0.5

@interface BSBLECommandControl()
@property(nonatomic, strong) NSMutableArray<NSData *> *commandDatas;
/// 指令超时定时器
@property(nonatomic, strong) dispatch_source_t timeoutTimer;
@property(nonatomic, assign) BOOL isExecuting;
@property(nonatomic, assign) BOOL isBLECallback;
@property(nonatomic, strong) NSLock *executeLock;
@property(nonatomic, strong) NSData *responseHeaderData;
@end


@implementation BSBLECommandControl

#pragma mark- Life cycle

- (instancetype)initWithBLEDevice:(BSDeviceBLE *)bleDevice{
    self = [super init];
    if (self) {
        self.bleDevice = bleDevice;
        self.commandDatas = [NSMutableArray new];
    }
    return self;
}

- (void)dealloc{
    [self cancelTimeoutTimer];
    NSLog(@"%@----------dealloc",NSStringFromClass(self.class));
}

#pragma mark- Public methods

- (void)executeCommandWithData:(NSData *)data{
    if(![self isValidCommand:data]){
        return;
    }
    @synchronized (self.commandDatas) {
        [self.commandDatas addObject:data];
    }
    [self executeCommandIfNeeded];
}

- (void)clearAllCommand{
    @synchronized (self.commandDatas) {
        [self.commandDatas removeAllObjects];
    }
    [self cancelTimeoutTimer];
    self.isExecuting = NO;
    self.isBLECallback = YES;
}

- (BOOL)isMatchWithData:(NSData *)data{
    return self.responseHeaderData && [self.responseHeaderData isEqualToData:data.copy];
}

#pragma mark- Private methods

- (BSBLECommandModel *)commandModelWithData:(NSData *)data{
    return [BSBLECommandModel modelWithCommandData:data
                                             model:self.bleDevice.name
                                               mac:self.bleDevice.mac
                                              type:self.bleDevice.type];
}

- (BOOL)isValidCommand:(NSData *)data{
    return [self isConnected] && [self isValidData:data];
}

- (BOOL)isValidData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        NSString *msg = [NSString stringWithFormat:@"BSBLECommandControl: executeCommandWithData:(%@)",NSStringFromClass([data class])];
        
        NSLog(@"%@", msg);
//        [BSCrashProtectionManager reportErrorWithMessage:msg];
        return NO;
    }
    return data && data.length > 0;
}

- (void)executeCommandIfNeeded{
    [self.executeLock lock];
    if (![self isConnected]) {
        //断开连接
        [self clearAllCommand];
        [self.executeLock unlock];
        return;
    }
    if (self.isExecuting) {
        //正在执行
        [self.executeLock unlock];
        return;
    }
    NSData *data = [self commandData2BeWritten];
    if (!data) {
        //数据发送完毕,取消超时处理
        [self cancelTimeoutTimer];
        [self.executeLock unlock];
        return;
    }
    //发送数据
    self.isExecuting = YES;
    self.isBLECallback = NO;
    self.responseHeaderData = [BSBLECommandModel ResponseHeaderData:data model:self.bleDevice.name type:self.bleDevice.type];
    [self.executeLock unlock];
    [self innerExecuteCommand:data];
    [self registerCommandWriteTimeoutCallback];
}

- (void)innerExecuteCommand:(NSData *)data{
    NSLog(@"进入队列");
    if (self.bleDevice && [self.bleDevice respondsToSelector:@selector(executeCommand:inQueue:)]) {
        [self.bleDevice executeCommand:data.mutableCopy inQueue:NO];
    }
    //写入后,从数组中清除
    @synchronized (self.commandDatas) {
        [self.commandDatas removeObject:data];
    }
}

- (BOOL)isConnected{
    return self.bleDevice && self.bleDevice.isConnected;
}

- (nullable NSData *)commandData2BeWritten{
    NSData *data = nil;
    @synchronized (self.commandDatas) {
        if (self.commandDatas.count > 0) {
            data = self.commandDatas.firstObject;
        }
    }
    return data;
}

- (void)registerCommandWriteTimeoutCallback{
    [self cancelTimeoutTimer];
    weakSelf(self);
    dispatch_source_t timeoutTimer = [self timerWithInterval:kBSDefaultCommandResponseTimeoutInterval immediately:NO repeat:NO block:^{
        if(weakSelf) [weakSelf executeTimeoutTimerHandler];
    }];
    self.timeoutTimer = timeoutTimer;
}

- (void)executeTimeoutTimerHandler{
    if (self.isBLECallback) {
        //如果写入指令已经回调了
        return;
    }
    NSLog(@"超时了");
    self.isExecuting = NO;
    [self executeCommandIfNeeded];
}

- (void)registerCommandResponseCallback{
    @weakify(self);
    _bleDevice.didResponseCommandCallback = ^{
        @strongify(self);
        self.isBLECallback = YES;
        self.isExecuting = NO;
        [self executeCommandIfNeeded];
    };
}

#pragma mark- Utils

- (dispatch_source_t)timerWithInterval:(double)interval immediately:(BOOL)immediately repeat:(BOOL)repeat block:(dispatch_block_t)handler{
    // 在自定义线程
    dispatch_queue_t queue = dispatch_queue_create("com.baseus.ble.write.command.timeout", NULL);
    // 创建一个定时器
    // Dispatch Source Timer 是间隔定时器，也就是说每隔一段时间间隔定时器就会触发。在 NSTimer 中要做到同样的效果需要手动把 repeats 设置为 YES。
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    // 开始执行时间
    dispatch_time_t start = dispatch_walltime(NULL, immediately ? : interval * NSEC_PER_SEC);
    /**
     * 设置参数
     * 第一个参数:定时器对象
     * 第二个参数，当我们使用dispatch_time 或者 DISPATCH_TIME_NOW 时，系统会使用默认时钟来进行计时。然而当系统休眠的时候，默认时钟是不走的，也就会导致计时器停止。
     * 使用 dispatch_walltime 可以让计时器按照真实时间间隔进行计时。
     * 第三个参数:间隔时间 GCD里面的时间最小单位为 纳秒; DISPATCH_TIME_FOREVER 为仅执行一次, interval * NSEC_PER_SEC: 每隔一段时间间隔定时器就会触发
     * 第四个参数 leeway 指的是一个期望的容忍时间，将它设置为 1 秒，意味着系统有可能在定时器时间到达的前 1 秒或者后 1 秒才真正触发定时器。
     * 在调用时推荐设置一个合理的 leeway 值。需要注意，就算指定 leeway 值为 0，系统也无法保证完全精确的触发时间，只是会尽可能满足这个需求。
     */
    dispatch_source_set_timer(timer, start, repeat ? interval * NSEC_PER_SEC : DISPATCH_TIME_FOREVER, 0.010 * NSEC_PER_SEC);
    // 设置回调
    dispatch_source_set_event_handler(timer, handler);
    // 启动定时器
    dispatch_resume(timer);
    return timer;
}

- (void)cancelTimeoutTimer{
    @synchronized (self.timeoutTimer) {
        if (!self.timeoutTimer || self.timeoutTimer == NULL) return;
        NSInteger result = -1;
        @try {
            result = dispatch_source_testcancel(self.timeoutTimer);
            if (result == 0) dispatch_source_cancel(self.timeoutTimer);
        } @catch (NSException *exception) { }
        if(self.timeoutTimer) self.timeoutTimer = nil;
    }
}

#pragma mark- Setters && Getters

- (void)setBleDevice:(BSDeviceBLE *)bleDevice{
    _bleDevice = bleDevice;
    if(!_bleDevice){
        return;
    }
    [self registerCommandResponseCallback];
}

- (NSLock *)executeLock{
    if (!_executeLock) {
        _executeLock = [NSLock new];
    }
    return _executeLock;
}

@end
