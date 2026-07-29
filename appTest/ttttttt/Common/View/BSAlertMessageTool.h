//
//  BSAlertMessageTool.h
//  BaseusAPP
//
//  Created by wushuang on 2023/11/29.
//  Copyright © 2023 Baseus. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, BSAlertMessageAction) {
    BSAlertMessageActionCancel, ///< 取消
    BSAlertMessageActionEvents, ///< 操作事件
};

typedef NS_ENUM(NSUInteger, BSAlertMessageType) {
    BSAlertMessageTypeDefault,   ///< 默认
    BSAlertMessageTypeAlert,     ///< 单个按钮提示框
    BSAlertMessageTypeTextFeild, ///< 输入框
    BSAlertMessageTypeTextFeildToNull, ///< 自定义名称空格与判空处理
    BSAlertMessageTypeTextFeildToIsEmail, ///< 输入的框内容为Email 判断
    BSAlertMessageTypeTopImgAndBottonCancel, ///< 顶部图片和底部取消图标
    BSAlertMessageTypeTextFeildAlertShowError, ///< 自定义名称空格与判空处理与错误显示，错误显示时，点击确定弹框不消失
};

/// 操作事件回调
typedef void(^BSAlertMessageHandle)(BSAlertMessageAction action,id object);

/// 提示弹窗
@interface BSAlertMessageTool : NSObject
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
