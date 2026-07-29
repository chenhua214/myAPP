//
//  YGNavigationController.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGNavigationController : UINavigationController

- (void)bs_updateNavigationBarForController:(UIViewController *)vc;

- (void)bs_updateNavigationBarTintForController:(UIViewController *)vc ignoreTintColor:(BOOL)ignoreTintColor;

- (void)bs_updateNavigationBarBackgroundColorForController:(UIViewController *)vc;

- (void)bs_updateNavigationBarShadowForController:(UIViewController *)vc;
@end

NS_ASSUME_NONNULL_END
