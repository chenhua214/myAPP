//
//  UIViewController+ZLJCommon.m
//  Beillen
//
//

#import "UIViewController+BSCommon.h"
//#import "BSCustomAlertView.h"

@implementation UIViewController (BSCommon)

+ (UIViewController *)bs_noPresentedCurrentViewController {
    return [self topViewControllerWithoutPresentedWithRootViewController:[self bs_topRootViewController]];
}

+ (UIViewController *)bs_currentViewController {
    return [self topViewControllerWithRootViewController:[self bs_topRootViewController]];
}

+ (UIViewController *)bs_topRootViewController {
    UIWindow *topWindow = [[UIApplication sharedApplication].delegate window];
    if (topWindow.windowLevel != UIWindowLevelNormal){
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows){
            if (topWindow.windowLevel == UIWindowLevelNormal){
                break;
            }
        }
    }
    return topWindow.rootViewController;
}

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if (rootViewController.presentedViewController) {
        return [self topViewControllerWithRootViewController:rootViewController.presentedViewController];
    } else if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *temp = [navigationController topViewController];
        return [self topViewControllerWithRootViewController:temp];
    }
    return rootViewController;
}

+ (UIViewController *)topViewControllerWithoutPresentedWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithoutPresentedWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        UIViewController *temp = [navigationController topViewController];
        return [self topViewControllerWithoutPresentedWithRootViewController:temp];
    }
    return rootViewController;
}

#pragma mark hideNavExtension *********************** hideNavExtension ******************************

- (void)bs_hideNavigationBarWithAnimated:(BOOL)animated {
    self.bs_barAlpha = 0;
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    //self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIView new]];
}

- (void)bs_showNavigationBarWithAnimated:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}

- (BOOL)inNavigationStackWithControllerName:(NSString *)controllerName{
    if(!self.navigationController || self.navigationController.viewControllers.count == 0 ){ return NO; }
    NSArray*viewControllers = self.navigationController.viewControllers.copy;
    __block BOOL inNavigationStack = NO;
    [viewControllers enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(UIViewController *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if([NSStringFromClass(obj.class) isEqualToString:controllerName]){
            inNavigationStack = YES;
            *stop = YES;
        }
    }];
    return inNavigationStack;
}

#pragma mark- Alert

- (void)alertWithMessage:(nullable NSString *)message
         confirmCallback:(nullable void (^)(void))confirmCallback
          cancelCallback:(nullable void (^)(void))cancelCallback{
    [self alertWithTitle:message message:nil confirmBtnTitle:NSLocalizedStringkey(@"str_confirm") cancelBtnTitle:NSLocalizedStringkey(@"str_cancel") preferredStyle:UIAlertControllerStyleAlert confirmCallback:confirmCallback cancelCallback:cancelCallback];
}

- (void)alertWithMessage:(nullable NSString *)message
              subMessage:(nullable NSString *)subMessage
         confirmCallback:(nullable void (^)(void))confirmCallback
          cancelCallback:(nullable void (^)(void))cancelCallback {
    [self alertWithTitle:message message:subMessage confirmBtnTitle:NSLocalizedStringkey(@"str_confirm") cancelBtnTitle:NSLocalizedStringkey(@"str_cancel") preferredStyle:UIAlertControllerStyleAlert confirmCallback:confirmCallback cancelCallback:cancelCallback];
}

- (void)alertWithTitle:(nullable NSString *)title
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
       confirmCallback:(nullable void (^)(void))confirmCallback
        cancelCallback:(nullable void (^)(void))cancelCallback{
    [self alertWithTitle:title message:nil confirmBtnTitle:confirmBtnTitle cancelBtnTitle:cancelBtnTitle preferredStyle:preferredStyle confirmCallback:confirmCallback cancelCallback:cancelCallback];
}

- (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
       confirmCallback:(nullable void (^)(void))confirmCallback
        cancelCallback:(nullable void (^)(void))cancelCallback{

    [BSAlertMessageTool alertMessage:title subMessage:message cancelTxt: cancelBtnTitle actionTxt: confirmBtnTitle handle:^(BSAlertMessageAction action, id object) {
        if (action == BSAlertMessageActionEvents) {
            if (confirmCallback) { confirmCallback(); }
        }else if(action == BSAlertMessageActionCancel){
            if (cancelCallback) { cancelCallback(); }
        }
    }];
    
}

- (void)alertWithTitle:(NSString *)title confirmBtnTitle:(NSString *)confirmBtnTitle cancelBtnTitle:(NSString *)cancelBtnTitle preferredStyle:(UIAlertControllerStyle)preferredStyle callback:(void (^)(BOOL))callback{
    [self alertWithTitle:title message:nil confirmBtnTitle:confirmBtnTitle cancelBtnTitle:cancelBtnTitle preferredStyle:preferredStyle callback:callback];
}

/// 显示alert
/// @param title 标题
/// @param message 信息
/// @param confirmBtnTitle 确认按钮标题<与cancelBtnTitle 不能同时为空>
/// @param cancelBtnTitle  取消按钮标题<与confirmBtnTitle 不能同时为空>
/// @param preferredStyle alert style
/// @param callback 按钮action
- (void)alertWithTitle:(nullable NSString *)title
               message:(nullable NSString *)message
       confirmBtnTitle:(nullable NSString *)confirmBtnTitle
        cancelBtnTitle:(nullable NSString *)cancelBtnTitle
        preferredStyle:(UIAlertControllerStyle)preferredStyle
              callback:(nullable void (^)(BOOL cancel))callback {
        
    [BSAlertMessageTool alertMessage:title subMessage:message cancelTxt:cancelBtnTitle actionTxt:confirmBtnTitle handle:^(BSAlertMessageAction action, id object) {
        if (!callback) { return; }
        if (action == BSAlertMessageActionEvents) {
            callback(NO);
        }else if(action == BSAlertMessageActionCancel){
            callback(YES);
        }
    }];
    
}

@end
