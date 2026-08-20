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

@interface BSPowerBankHomeViewModel()
/// 设备
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) BSHomeDeviceModel *model;
/// 需要查询的指令
@property (nonatomic, strong) NSArray *readCommandArray;
@end

@implementation BSPowerBankHomeViewModel
- (void)deallocDevice
{
    [self.device removeObserver:self forKeyPath:@"isConnected"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
//        [self readEnergyInfoCommand:self.readCommandArray];
        [self readCommand:BSPowerBankCmdTypeC1_R_OutputV_L length:20];
    }
    [self.device addObserver:self forKeyPath:@"isConnected" options:NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld context:nil];
    self.device.dataDidChangedBlock = ^(BOOL success) {
      
        [weakSelf chageDdate];
    };
}

-(void)chageDdate {
    if (self.PowerBankValueChange) {
        self.PowerBankValueChange(YES);
    }
}

#pragma mark KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        @weakify(self);
        __weak typeof(self) weakSelf = self;
        id newName = [change objectForKey:NSKeyValueChangeNewKey];
        if ([keyPath isEqualToString:@"isConnected"])
        {
            BOOL isConnected = [newName boolValue];
            self.isConnected = isConnected;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.85 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                @strongify(self);
                if (isConnected) {
//                    [weakSelf readEnergyInfoCommand:weakSelf.readCommandArray];
                    [weakSelf readCommand:BSPowerBankCmdTypeC1_R_OutputV_L length:10];
                  
                } else {
                    [weakSelf chageDdate];
                }
            });
        }
    });
}

#pragma mark 读取设备信息

- (void)readEnergyInfoCommand:(NSArray *)commandArray
{
    for (NSNumber * number in commandArray) {
        [self.device readValueWithCommand:number.integerValue block:^(BOOL result, id  _Nonnull responseDic) {
                    
        }];
    }
}

- (void)readCommand:(BSPowerBankCommand) cmd length:(NSInteger)length
{
    [self.device readValueWithCommand:cmd continuity:YES length:length block:^(BOOL result, id  _Nullable responseDic) {
            
    }];
    
//    [self.device readValueWithCommand:cmd continuity:YES length:length block:^(BOOL result, id  _Nullable responseDic) {
//            
//    }];
    [self.device writeWithCommand:cmd continuity:YES length:2 block:^(BOOL result, id  _Nullable responseDic) {
            
    }];
//
//    - (void)writeWithCommand:(BSPowerBankCommand)command continuity:(BOOL)isContinuity length:(NSInteger)length block:(BSResponseBlock)block;
}

- (NSArray *)readCommandArray {
    if (!_readCommandArray) {
        _readCommandArray = @[
            @(BSPowerBankCmdTypeC1_R_OutputA_L),               ///<   *   端口状态寄存器
            @(BSPowerBankCmdTypeC1_R_OutputA_H),             ///<   *   电池电量
            @(BSPowerBankCmdTypeC1_R_OutputV_L),           ///<   *   设备异常标志寄存器
            @(BSPowerBankCmdTypeC1_R_OutputV_H),                  ///<   *   设备温度
        ];
    }
    return _readCommandArray;
}

@end
