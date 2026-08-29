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
        [self readCommand:BSPowerBankCmdTypeC1_R_OutputV_L length:10];
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
                    [weakSelf readCommand:BSPowerBankCmdTypeC1_R_OutputV_L length:10];
                  
                } else {
                    [weakSelf chageDdate];
                }
            });
        }
    });
}

#pragma mark 读取设备信息
/// 根据界面要求读取数据
- (void)readCommand:(BSPowerBankCommand) cmd length:(NSInteger)length
{

    
    [self.device readValueWithStartCommand:BSPowerBankCmdTypeC1_R_OutputA_L endCommand:BSPowerBankCmdCharge_USBA_TCP block:^(BOOL result, id  _Nullable responseDic) {
            NSLog(@"请求数据返回成功33");
    }];
    
}



@end
