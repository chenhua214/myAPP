//
//  UIViewController+ZLJCommon.h
//  BaseusAPP
//
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (BSCommon)

/// 返回当前栈顶控制器（不包括present的控制器）
+ (UIViewController *)bs_noPresentedCurrentViewController;

/// 返回当前栈顶控制器（包括present的控制器）
+ (UIViewController *)bs_currentViewController;

/// 返回window的rootviewcontroller
+ (UIViewController *)bs_topRootViewController;

#pragma mark hideNavExtension *********************** hideNavExtension ******************************
///隐藏导航栏 @param animated 是否需要动画
- (void)bs_hideNavigationBarWithAnimated:(BOOL)animated;

/// 显示NavigationBar
/// @param animated YES/NO
- (void)bs_showNavigationBarWithAnimated:(BOOL)animated;

/// 某个控制器是否在导航栈中
/// @param controllerName 控制器名称
- (BOOL)inNavigationStackWithControllerName:(NSString *)controllerName;

#pragma mark- Alert

- (void)alertWithMessage:(nullable NSString *)message
         confirmCallback:(nullable void (^)(void))confirmCallback
          cancelCallback:(nullable void (^)(void))cancelCallback;

- (void)alertWithMessage:(nullable NSString *)message
              subMessage:(nullable NSString *)subMessage
         confirmCallback:(nullable void (^)(void))confirmCallback
          cancelCallback:(nullable void (^)(void))cancelCallback;

- (void)alertWithTitle:(nullable NSString *)title
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
       confirmCallback:(nullable void (^)(void))confirmCallback
        cancelCallback:(nullable void (^)(void))cancelCallback;

/// 显示alert
/// @param title 标题
/// @param message 信息
/// @param confirmBtnTitle 确认按钮标题<与cancelBtnTitle 不能同时为空>
/// @param cancelBtnTitle  取消按钮标题<与confirmBtnTitle 不能同时为空>
/// @param preferredStyle alert style
/// @param confirmCallback 确认按钮action
/// @param cancelCallback  取消按钮action
- (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
       confirmCallback:(nullable void (^)(void))confirmCallback
        cancelCallback:(nullable void (^)(void))cancelCallback;

/// 显示alert
/// @param title 标题
/// @param confirmBtnTitle 确认按钮标题<与cancelBtnTitle 不能同时为空>
/// @param cancelBtnTitle  取消按钮标题<与confirmBtnTitle 不能同时为空>
/// @param preferredStyle alert style
/// @param callback 按钮action
- (void)alertWithTitle:(nullable NSString *)title
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
              callback:(nullable void (^)(BOOL cancel))callback;

@end

NS_ASSUME_NONNULL_END
