//
//  BSCommonDevice.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSCommonDevice.h"
#import "BSBLEManager.h"
#import "NSString+BSCommon.h"
#import "BSDeviceManager.h"
#import "LKDBHelper.h"
@interface BSCommonDevice ()
/// 设备是否在附近
@property(nonatomic,assign) BOOL isNearby;
/// 连接状态
@property(nonatomic,assign) BOOL connectStatus;
@property(nonatomic,strong) NSMutableArray<BSBLEResponse *> *respBlocks;
@property(nonatomic,assign,readwrite) BSDeviceSubType deviceSubType;
/// 设备是否连接
@property(nonatomic,assign,readwrite) BOOL isConnected;
@end

@implementation BSCommonDevice

#pragma mark- LKDB Helper



//2026  后面处理
/// 存入数据库的字段(白名单)
+ (NSDictionary *)getTableMapping{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super getTableMapping]];
    [dict addEntriesFromDictionary:@{
        @"identifier": LKSQL_Mapping_Inherit,
        @"deviceType": LKSQL_Mapping_Inherit,
        @"model": LKSQL_Mapping_Inherit,
        @"deviceImgUrl": LKSQL_Mapping_Inherit,
        @"started": LKSQL_Mapping_Inherit,
        @"name": LKSQL_Mapping_Inherit,
        @"prodName": LKSQL_Mapping_Inherit,
        @"shared": LKSQL_Mapping_Inherit,
        @"shareId": LKSQL_Mapping_Inherit,
        @"accounts": LKSQL_Mapping_Inherit,
        @"accountId": LKSQL_Mapping_Inherit,
//        @"delayMode": LKSQL_Mapping_Inherit,
//        @"des": LKSQL_Mapping_Inherit,
//        @"afterSale": LKSQL_Mapping_Inherit,
        @"categoryId": LKSQL_Mapping_Inherit,
//        @"gestureUrl": LKSQL_Mapping_Inherit,
//        @"fqa": LKSQL_Mapping_Inherit,
//        @"feedback": LKSQL_Mapping_Inherit,
        @"deviceOrder": LKSQL_Mapping_Inherit,
    }];
    return dict;
}

+ (NSArray *)getPrimaryKeyUnionArray{
    return @[@"model",@"identifier"];
}

#pragma mark- Life cycle

+ (instancetype)modelWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(NSString *)model{
    return [self modelWithClass:self.class identifier:identifier type:type model:model];
}

+ (instancetype)modelWithClass:(Class)className identifier:(NSString *)identifier type:(BSDeviceType)type model:(NSString *)model{
    return [[className alloc] initWithIdentifier:identifier type:type model:model];
}

- (instancetype)initWithIdentifier:(NSString *)identifier type:(BSDeviceType)type{
    return [self initWithIdentifier:identifier type:type model:nil];
}

- (instancetype)initWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(NSString *)model{
    self = [super init];
    if (self) {
        self.deviceType = type;
        self.identifier = identifier ? identifier.copy : nil;
        self.model = model ? model.copy : nil;
        [self addNotificationObserver];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self addNotificationObserver];
    }
    return self;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"%@----BSCommonDevice_Dealloc",NSStringFromClass(self.class));
}

#pragma mark- setup

- (void)addNotificationObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blePowerONNotification:)  name:kBSBLEDidPowerONNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(blePowerOffNotification:) name:kBSBLEPoweredOffNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didDiscoverDevice:) name:kBSBluetoothDidDiscoverDevice object:nil];
}


#pragma mark- BLE NSNotification
//发现设备 这个通知的作用待定
- (void)didDiscoverDevice:(NSNotification *)notification{
 
}

//蓝牙打开
- (void)blePowerONNotification:(NSNotification *)notification{

}

//蓝牙关闭
- (void)blePowerOffNotification:(NSNotification *)notification{
    if (self.connectStatus) {
        [self didDisconnected];
    }
}


+ (BOOL)isSupportedDevice:(NSString *)model{
    if (!model.isEnable){
        return NO;
    }
    return YES;
    return ([self deviceSubTypeDict][model] != nil);
}

//连接蓝牙设备
- (void)connect{
    if (!self.bleDevice) {
        return;
    }
    [[BSBLEManager shareInstance] connect:self.bleDevice];
}

//断开连接蓝牙设备
- (void)disconnect{
    [self bluetoothDisconnect];
}

- (void)try2Connect{
    [[BSBLEManager shareInstance] try2ConnectDevice:self];
}


- (void)bluetoothDisconnect{
    if (self.bleDevice) {
        [[BSBLEManager shareInstance] disconnect:self.bleDevice];
    }
}




- (void)readRssi:(BSResponseBlock)block{
    Byte bytes[] = {0xBA,0x01,0x01};
    NSData *data = [NSData dataWithBytes:bytes length:3];
    [self addBleCommandByte:data responseBlock:block];
    [self.bleDevice setNeedUpdateRSSI];
}

//添加命令的回调
- (void)addBleCommandByte:(NSData *)commandByte responseBlock:(BSResponseBlock)block{
    [self addBleCommandByte:commandByte maxTimes:1 responseBlock:block];
}

//添加命令的回调
- (void)addBleCommandByte:(NSData *)commandByte maxTimes:(int)maxTimes responseBlock:(BSResponseBlock)block{
    [self addBleCommandByte:commandByte maxTimes:maxTimes delayInSeconds:2 responseBlock:block];
}

//添加命令的回调
- (void)addBleCommandByte:(NSData *)commandByte maxTimes:(int)maxTimes delayInSeconds:(int)delayInSeconds responseBlock:(BSResponseBlock)block{
    BSBLEResponse *response = [[BSBLEResponse alloc] init];
    response.commandByte = commandByte;
    response.commandBlock = block;
    response.maxTimes = maxTimes;
    response.delayInSeconds = delayInSeconds;
    @synchronized (self.respBlocks) {
        [self.respBlocks addObject:response];
    }
}


//block回调
- (void)commandRspCallBackWithType:(NSData *)type result:(BOOL)result responseDic:(NSDictionary *)responseDic{
    BSResponseBlock block = [self responseBlockWithCommandByte:type];
    if (block) {
        block(result, responseDic);
    }
}

//查找block 并删除同类型且同一个sendobject的block
- (nullable BSBLEResponse *)responseWithCommandByte:(NSData *)commandByte{
    __block BSBLEResponse *retModel = nil;
    @synchronized (self.respBlocks) {
        NSMutableArray *removeArr = [NSMutableArray array];
        [self.respBlocks enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(BSBLEResponse * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
            if (!retModel && [model.commandByte isEqualToData:commandByte]) {
                retModel = model;
            }
            if (retModel && [model.commandByte isEqualToData:retModel.commandByte]) {
                [removeArr addObject:model];
            }
        }];
//        AppLog(@"response====%@, command: %@",retModel,commandByte);
        if (removeArr && removeArr.count > 0) {
            [self.respBlocks removeObjectsInArray:removeArr];
        }
    }
    return retModel;
}

- (nullable BSResponseBlock)responseBlockWithCommandByte:(NSData *)commandByte{
    BSBLEResponse *retModel = [self responseWithCommandByte:commandByte];
    if(!retModel){
        return nil;
    }
    return retModel.commandBlock;
}


- (void)removeAllResponseBlockIfNeeded{
    if (!_respBlocks || self.respBlocks.count == 0) {
        return;
    }
    @synchronized (self.respBlocks) {
        [self.respBlocks removeAllObjects];
    }
}



/// 设备绑定的时候，或者OTA升级时需要查询设备版本信息
- (void)readDeviceVersionWithResponseBlock:(BSResponseBlock)block
{
    //... 在子类中重载
    if (block) block(YES,@"");
}



- (nonnull NSString *)validValueForBattery:(NSString *)batteryString{
    if (![batteryString isValidNumber]) {
        return @"-";
    }
    NSInteger batteryValue = batteryString.integerValue;
    batteryValue = MAX(0, batteryValue);
    batteryValue = MIN(batteryValue, 100);
    return [NSString stringWithFormat:@"%ld",batteryValue];
}

- (nonnull NSString *)validValueMultiplesOfTenForBattery:(NSString *)batteryString{
    if (![batteryString isValidNumber]) {
        return @"-";
    }
    NSInteger batteryValue = batteryString.integerValue;
    batteryValue = MAX(0, batteryValue);
    batteryValue = MIN(batteryValue, 100);
    NSInteger numberValue =  lroundf(batteryValue/10.0) ;
    return [NSString stringWithFormat:@"%ld",numberValue*10];
}


#pragma mark - BSBaseusBLEDelegate

- (void)didUpdateValue:(NSData *)value{
//    UInt8 *command = (UInt8 *)[value bytes];
//    if (command[0] == 0xAA){
//        if (command[1] == 0x08) {
//            [self showNotificationAlert];
//        }
//    }
}

- (void)didReadRSSI:(NSNumber *)RSSI{
    
    if (RSSI.integerValue>-85) {
        
        self.isNearby = YES;
    }
    
    Byte bytes[] = {0xBA,0x01,0x01};
    NSData *data = [NSData dataWithBytes:bytes length:3];
    BSResponseBlock block = [self responseBlockWithCommandByte:data];
    if (block) {
        block(YES,@{@"RSSI":RSSI});
    }
}

- (BOOL)isConnected{
    return self.bleDevice && (self.bleDevice.isConnected);
}


- (void)didDisconnected {
    self.connectStatus = NO;
    self.isConnected = NO;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didDisConnectWithDevice:)]) {
            [self.delegate didDisConnectWithDevice:self];
        }
    });
}


- (void)didConnected{
    self.connectStatus = YES;
    //连接成功的处理
    self.isConnected = YES;
    //更新设备信息
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.delegate && [self.delegate respondsToSelector:@selector(didConnectWithDevice:)]) {
            [self.delegate didConnectWithDevice:self];
        }
    });
}

+ (BSDeviceSubType)deviceSubTypeWithModel:(NSString *)model{
//    NSAssert(model, @"model不能为空");
    NSNumber *subTypeNum = [self deviceSubTypeDict][model?:@""];
    return (subTypeNum != nil) ? [subTypeNum integerValue] : BSDeviceSubTypeTag;
}

- (void)setModel:(NSString *)model{
    _model = model;
    if(!_model || _model.length == 0){
        return;
    }
    self.deviceSubType = [BSCommonDevice deviceSubTypeWithModel:_model];
}

- (BOOL)online{
    return _online;
}

/// 是否可用
- (BOOL)isEnable{
    return (self.started == 0);
}

//设备返回
- (BSDeviceBLE *)bleDevice{
    BSDeviceBLE * bleDevice = [BSDeviceBLE deviceFromMac:_identifier];
    bleDevice.delegate = self;
    bleDevice.name = self.model;
    bleDevice.type = self.deviceType;
    return bleDevice;
}

- (NSMutableArray *)respBlocks{
    if (!_respBlocks) {
        _respBlocks = @[].mutableCopy;
    }
    return _respBlocks;
}


/// 根据类型获取model名称
+ (NSString *)modelWithDeviceSubType:(BSDeviceSubType)type
{
    NSDictionary <NSString *, NSNumber *> *dict = [self deviceSubTypeDict];
    __block NSString *model = kBSDeviceModelAirNora;
    [dict enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSNumber * _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj.integerValue == type) {
            model = key;
            *stop = YES;
        }
    }];
    return model;
}

//**//////////////////////**


+ (NSDictionary<NSString *,NSNumber *> *)deviceSubTypeDict{
    return @{
        /******** 设备类型 ********/
        kBSDeviceModelTag:@(BSDeviceSubTypeTag)
    };
}


+ (BOOL)isSimulator
{
    return (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1);
}

@end
