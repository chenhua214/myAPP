//
//  BSPowerBankHomeViewModel.m
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import "BSPowerBankHomeViewModel.h"
#import "BSHomeModel.h"
#import "BSGCDTimer.h"
#import "BSDeviceManager.h"
#import "NSTimer+YYAdd.h"

static NSString *const kBSBLEReadDeviceTimer  = @"BSBLEReadDeviceTimer";
static NSString *const kBSBLEReadTypeCDeviceTimer  = @"BSBLEReadTypeCDeviceTimer";
@interface BSPowerBankHomeViewModel()
/// 设备
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) BSHomeDeviceModel *model;

@end

@implementation BSPowerBankHomeViewModel
- (void)deallocDevice
{
    [self.device removeObserver:self forKeyPath:@"isConnected"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self stopReadCmd];
    [self stopReadTypeCCmd];
}

- (instancetype)initWithModel:(BSHomeDeviceModel *)model {
    if (self = [super init]) {
        _model = model;
    }
    return self;
}

- (void)initData  {
    __weak typeof(self) weakSelf = self;
    self.device = (BSPowerBankDevice *)[[BSDeviceManager shareInstance] findDeviceWithIdentifier:self.model.sn];
    if (self.device.isConnected) {
        self.isConnected = YES;
        [self readCommand];
        [self ReadCmdToOnce];
    }
    [self.device addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.device.dataDidChangedBlock = ^(BOOL success) {
        
        [weakSelf chageDdate];
    };
    
    /// 接口状态发生变化的时候
    [RACObserve(self.device, typeConnectState) subscribeNext:^(id  _Nullable x) {
        [weakSelf updateForTypeConnectState];
    }];
}

-(void)chageDdate {
    if (self.PowerBankValueChange) {
        self.PowerBankValueChange(YES);
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        __weak typeof(self) weakSelf = self;
        id newName = [change objectForKey:NSKeyValueChangeNewKey];
        if ([keyPath isEqualToString:@"isConnected"])
        {
            BOOL isConnected = [newName boolValue];
            self.isConnected = isConnected;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.85 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (isConnected) {
                    [weakSelf readCommand];
                } else {
                    [weakSelf chageDdate];
                    [weakSelf stopReadCmd];
                }
            });
        }
    });
}

#pragma mark 读取设备信息
/// 根据界面要求读取数据
- (void)readCommand
{
    dispatch_queue_t queue = dispatch_queue_create("com.Beillen.scanBLEDevices", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    //每3秒
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSBLEReadDeviceTimer timeInterval:1.2 queue:queue repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf startReadCmd];
    }];
}

-(void)stopReadCmd{
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSBLEReadDeviceTimer];
}

/// 一直读取数据
-(void)startReadCmd{
    
    /// 需要1S循环读取数据
    /// 1.1 必须循环读取的接口有   15H 接口状态  16H电量  17H电池温度
    /// 1.2进来读取一次的接口有  1C 1D 电池循环次数  1E健康度   45H 46H电池剩余容量
    /// 2 如果接口都没有连接，只读取数据一次，循环读接口信息。
    /// 3 如果存在接口，循环读取数据  00 --13  15--17   45-46    D2-D5
    [self.device readValueWithStartCommand:BSPowerBankCmdDevice_state_Read endCommand:BSPowerBankCmdBatteryT_Read block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"请求数据返回成功33");
    }];
}

-(void)updateForTypeConnectState{
    if (self.device.typeConnectState == 0) {
        [self stopReadTypeCCmd];
    } else {
        [self TimerForReadTypeCOpenCommand];
    }
}

- (void)TimerForReadTypeCOpenCommand
{
    if (self.device.isConnected == NO) {
        return;
    }
    dispatch_queue_t queue = dispatch_queue_create("com.BeillenTypeC.scanBLEDevices", DISPATCH_QUEUE_CONCURRENT);
    __weak typeof(self) weakSelf = self;
    //每3秒
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSBLEReadTypeCDeviceTimer timeInterval:1.2 queue:queue repeats:YES actionOption:AbandonPreviousAction action:^{
        [weakSelf ReadCmdToOpenTypeC];
    }];
}

-(void)stopReadTypeCCmd{
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSBLEReadTypeCDeviceTimer];
}

/// 有typec 接口数   循环读取数据
/// 3 如果存在接口，循环读取数据  00 --13  15--17   45-46    D2-D5
///  放电剩余时间 21-22
-(void)ReadCmdToOpenTypeC {
    
    [self.device readValueWithStartCommand:BSPowerBankCmdTypeC1_R_OutputA_L endCommand:BSPowerBankCmdCharge_USBA_TCP_Read block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"请求数据返回成功33");
    }];
    
    [self.device readValueWithStartCommand:BSPowerBankCmd_Output_Time_L_Read endCommand:BSPowerBankCmd_Output_Time_H_Read block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"请求数据返回成功33");
    }];
    
    [self.device readValueWithStartCommand:BSPowerBankCmdBattery_R_Number_L endCommand:BSPowerBankCmdBattery_R_Number_H block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"请求数据返回成功33");
    }];
    
    [self.device readValueWithStartCommand:BSPowerBankCmdWireRod_R_C1 endCommand:BSPowerBankCmdMessage_R_C2 block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"请求数据返回成功33");
    }];
}

/// 读取一次
/// 1.2进来读取一次的接口有  1C 1D 电池循环次数  1E健康度   45H 46H电池剩余容量
-(void)ReadCmdToOnce {
    
    //  1C 1D 电池循环次数  1E健康度
    [self.device readValueWithStartCommand:BSPowerBankCmdBattery_LoopNum_L_Read endCommand:BSPowerBankCmdBattery_State_Read block:^(BOOL result, id  _Nullable responseDic) {
      
    }];
    [self.device readValueWithStartCommand:BSPowerBankCmdClock_RW_open endCommand:BSPowerBankCmdClock_RW_open block:^(BOOL result, id  _Nullable responseDic) {
        
    }];
    //  45H 46H电池剩余容量
    [self.device readValueWithStartCommand:BSPowerBankCmdBattery_R_Number_L endCommand:BSPowerBankCmdBattery_R_Number_H block:^(BOOL result, id  _Nullable responseDic) {
        
    }];
}

@end
