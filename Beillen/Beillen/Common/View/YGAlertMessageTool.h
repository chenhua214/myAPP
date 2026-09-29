//
//  YGAlertMessageTool.h
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import <Foundation/Foundation.h>
#import "BSAlertMessageTool.h"
NS_ASSUME_NONNULL_BEGIN


/// 操作事件回调
typedef void(^BSAlertMessageHandle)(BSAlertMessageAction action,id object);

@interface YGAlertMessageTool : NSObject
/// 背景dismiss手势 enable
@property (nonatomic, assign) BOOL bgGestureEnabel;

+ (instancetype)shareInstance;
#pragma mark Set Method

/// 更新背景dismiss手势 enable
+ (void)updateBgGestureEnable:(BOOL)enable;
/// 更新输入框是否可为空
+ (void)updateInputNoneText:(BOOL)none;

#pragma mark Publick Method

/*      * BSAlertMessageTypeDefault *
 *     |▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔|
 *     |            Title            |
 *     |            Message          |
 *     |   -----------------------   |
 *     |     Cancel   |   Action     |
 *     |_____________________________|
 */

+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
           cancelTxt:(NSString *)cancel
           actionTxt:(NSString *)action
              handle:(BSAlertMessageHandle)handle;

/// 红色确认按钮
+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
           cancelTxt:(NSString *)cancel
        actionTxtRed:(NSString *)action
              handle:(BSAlertMessageHandle)handle;

/*     * BSAlertMessageTypeTextFeild *
 *     |▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔|
 *     |            Title            |
 *     |            Message          |
 *     |        Input TestFeild      |
 *     |   -----------------------   |
 *     |     Cancel   |   Action     |
 *     |_____________________________|
 */
+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
         placeholder:(NSString *)placeholder
           txtFldTxt:(NSString *)txtFldTxt
           cancelTxt:(NSString *)cancel
           actionTxt:(NSString *)action
              handle:(BSAlertMessageHandle)handle;
//// 输入框类型
+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
         placeholder:(NSString *)placeholder
           txtFldTxt:(NSString *)txtFldTxt
           cancelTxt:(NSString *)cancel
           actionTxt:(NSString *)action
         MessageType:(BSAlertMessageType )MessageType
              handle:(BSAlertMessageHandle)handle;

/*       * BSAlertMessageTypeAlert *
 *     |▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔▔|
 *     |            Title            |
 *     |            Message          |
 *     |            Action           |
 *     |_____________________________|
 *
 *    Tips: BSAlertMessageTypeAlert 不支持修改字体颜色与外形
 */

+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
           actionTxt:(NSString *)action
              handle:(BSAlertMessageHandle)handle;


/*       * BSAlertMessageTypeAlert *
 *               |▔▔▔▔▔▔▔▔▔|
 *     |---------|  Image  |---------|
 *     |         |         |         |
 *     |          ▔▔▔▔▔▔▔▔▔          |
 *     |            Title            |
 *     |                             |
 *     |            Action           |
 *     |_____________________________|
 *
 *    Tips: BSAlertMessageTypeAlert 不支持修改字体颜色与外形
 */

+ (void)alertMessage:(id)msg
           imageName:(NSString*)imageName
           actionTxt:(NSString *)action
              handle:(BSAlertMessageHandle)handle;

/// 退出 Alert
+(void)dismissAlertMessage;

/// 更新提示语详情的字体大小、颜色
+ (void)updateDetailLabFont:(UIFont *)font color:(UIColor *)color;
///弹框中显示错信息
+(void)setAlertErrorLabelMessage:(NSString*)errorMessage ;


@end

NS_ASSUME_NONNULL_END
