//
//  BSAlertMessageTool+Events.m
//  BaseusAPP
//
//  Created by wushuang on 2023/12/13.
//  Copyright © 2023 Baseus. All rights reserved.
//

#import "BSAlertMessageTool+Events.h"

@implementation BSAlertMessageTool (Events)

/// 需要登录
/// @param need : 是否必须登录
/// @param handle : 确认按钮点击后回调
+ (void)loginIfNeeded:(BOOL)need handle:(void (^) (void))handle
{
    [self alertMessage:NSLocalizedStringkey(@"pls_login_content") subMessage:nil actionTxt:NSLocalizedStringkey(@"login_btn") handle:^(BSAlertMessageAction action, id object) {
        if (handle) handle();
    }];
    [self updateBgGestureEnable:!need];
}


/// 设备返回设置失败，提示框
+ (void)alertMessageDeviceReturnFailure
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSString *msg = NSLocalizedStringkey(@"set_failed_title") ;
        NSString *subMsg1 = NSLocalizedStringkey(@"set_failed_tip1") ;
        NSString *subMsg2 = NSLocalizedStringkey(@"set_failed_tip2") ;
        NSString *subMsg3 = NSLocalizedStringkey(@"set_failed_tip3") ;
        NSString *subMsg4 = NSLocalizedStringkey(@"set_failed_tip4") ;
        NSString*subMsg = [NSString stringWithFormat:@"%@\n%@\n%@\n%@",subMsg1,subMsg2,subMsg3,subMsg4];
        
        NSString *action = NSLocalizedStringkey(@"str_confirm");
        [self alertMessage:msg subMessage:subMsg actionTxt:action handle:nil];
    });
}
@end
