//
//  BSPowerBankHomeViewModel.h
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import <Foundation/Foundation.h>
#import "BSPowerBankDevice.h"
NS_ASSUME_NONNULL_BEGIN
@class BSHomeDeviceModel;
@interface BSPowerBankHomeViewModel : NSObject
@property (nonatomic, assign) BOOL isConnected;
/// 设备
@property (nonatomic, strong, readonly) BSPowerBankDevice *device;
/// 初始化ViewModel
- (instancetype)initWithModel:(BSHomeDeviceModel *)model;
/// 设备状态
@property (nonatomic, assign) NSInteger workState;

/// 数据变化 Block
@property (nonatomic,  copy ) void (^PowerBankValueChange)(BOOL isChangeValue);
- (void)initData;
- (void)deallocDevice;

@end

NS_ASSUME_NONNULL_END
