//
//  BSDeviceDBHelper.h
//
//
//  Created by chen on 2022/9/14.
//  Copyright ©
//

#import "BSGuestModeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@class BSHomeDeviceModel;
@interface BSDeviceDBHelper : BSGuestModeHelper

/// 删除数据(model 和 sn 均需传入)
/// - Parameters:
///   - model: 型号
///   - sn: sn/identifier
///   - callback: 回调
+ (void)deleteDeviceWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback;

/// 更新数据库
/// - Parameters:
///   - model: 待更新的数据(已在数据库中)
///   - callback:
+ (void)updateDevice:(nullable BSHomeDeviceModel *)model callback:(nullable operationBlock)callback;

/// 更新 已知 model和sn 项的数据
/// - Parameters:
///   - params: 需要更新的数据
///   - model: 型号
///   - sn:    sn/identifier
///   - callback: 回调
+ (void)updateDeviceWithParams:(nullable NSDictionary *)params model:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback;

/// 查询所有的数据
/// - Parameter callback: 回调
+ (void)allDevicesWithCallback:(nullable operationBlock)callback;

/// 查询型号为model, 唯一标识 为sn 的数据
/// - Parameters:
///   - model: 型号
///   - sn: sn/identifier
///   - callback: 回调
+ (void)deviceWithModel:(nullable NSString *)model sn:(nullable NSString *)sn callback:(nullable operationBlock)callback;

@end

NS_ASSUME_NONNULL_END
