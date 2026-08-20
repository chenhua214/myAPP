//
//  BSAlertMessageTool+Events.h
//  Beillen
//
//  Created by wushuang on 2023/12/13.
//  Copyright © 2023 Beillen. All rights reserved.
//

#import "BSAlertMessageTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSAlertMessageTool (Events)

/// 需要登录
/// @param need : 是否必须登录
/// @param handle : 确认按钮点击后回调
+ (void)loginIfNeeded:(BOOL)need handle:(void (^) (void))handle;


/// 设备返回设置失败，提示框
+ (void)alertMessageDeviceReturnFailure;

@end

NS_ASSUME_NONNULL_END
