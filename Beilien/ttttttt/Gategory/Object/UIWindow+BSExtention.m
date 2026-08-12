//
//  UIWindow+BSExtention.m
//  JDKJAPP
//
//  Created by chenyi on 2026/7/20.
//

#import "UIWindow+BSExtention.h"

@implementation UIWindow (BSExtention)
- (nullable UIViewController *)topViewController {
    UIViewController *resultVC;
//    resultVC = [self _topViewController:[[UIApplication sharedApplication].windows.firstObject rootViewController]];
    
    for (UIScene *scene in UIApplication.sharedApplication.connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] &&
            scene.activationState == UISceneActivationStateForegroundActive) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            UIWindow *window = windowScene.windows.firstObject;
            resultVC = [window rootViewController];
            // 使用 window
            break;
        }
    }
    
    while (resultVC.presentedViewController) {
        resultVC = [self _topViewController:resultVC.presentedViewController];
    }
    return resultVC;
}

- (UIViewController *)_topViewController:(UIViewController *)vc {
    if ([vc isKindOfClass:[UINavigationController class]]) {
        return [self _topViewController:[(UINavigationController *)vc topViewController]];
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        return [self _topViewController:[(UITabBarController *)vc selectedViewController]];
    } else {
        return vc;
    }
    return nil;
}


@end
