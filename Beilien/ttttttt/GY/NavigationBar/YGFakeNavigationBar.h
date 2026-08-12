//
//  YGFakeNavigationBar.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/16.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGFakeNavigationBar : UIView

@property (nonatomic, strong) UIImageView *fakeBackgroundImageView;

@property (nonatomic, strong) UIVisualEffectView *fakeBackgroundEffectView;

@property (nonatomic, strong) UIImageView *fakeShadowImageView;

- (void)bs_updateFakeBarBackGroundForViewController:(UIViewController *)viewController;

- (void)bs_updateFakeBarShadowForViewController:(UIViewController *)viewController;
@end

NS_ASSUME_NONNULL_END
