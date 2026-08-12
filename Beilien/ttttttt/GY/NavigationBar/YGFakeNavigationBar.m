//
//  YGFakeNavigationBar.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/16.
//

#import "YGFakeNavigationBar.h"
#import "UIViewController+YGNavigationBar.h"

@implementation YGFakeNavigationBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initSubview];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self)
    {
        [self initSubview];
    }
    return self;
}

- (void)initSubview
{
    self.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    [self addSubview:self.fakeBackgroundEffectView];
    [self addSubview:self.fakeBackgroundImageView];
    [self addSubview:self.fakeShadowImageView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.fakeBackgroundEffectView.frame = self.bounds;
    self.fakeBackgroundImageView.frame = self.bounds;
    self.fakeShadowImageView.frame = CGRectMake(0, self.bounds.size.height-0.5, self.bounds.size.width, 0.5);
}


- (void)bs_updateFakeBarBackGroundForViewController:(UIViewController *)viewController
{
    self.fakeBackgroundEffectView.subviews.lastObject.backgroundColor = viewController.bs_backgroundColor;
    self.fakeBackgroundImageView.image = viewController.bs_backgroundImage;
    if (viewController.bs_backgroundImage) {
        // 直接使用fakeBackgroundEffectView.alpha控制台会有提示
        // 这样避免警告
        [self.fakeBackgroundEffectView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = 0;
        }];
    } else {
        [self.fakeBackgroundEffectView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            obj.alpha = viewController.bs_barAlpha;
        }];
    }
    self.fakeBackgroundImageView.alpha = viewController.bs_barAlpha;
    self.fakeShadowImageView.alpha = viewController.bs_barAlpha;
}

- (void)bs_updateFakeBarShadowForViewController:(UIViewController *)viewController
{
    self.fakeShadowImageView.hidden = viewController.bs_shadowHidden;
    self.fakeShadowImageView.backgroundColor = viewController.bs_shadowColor;
}


- (UIImageView *)fakeBackgroundImageView {
    if (!_fakeBackgroundImageView) {
        _fakeBackgroundImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fakeBackgroundImageView.userInteractionEnabled = NO;
        _fakeBackgroundImageView.contentScaleFactor = 1;
        _fakeBackgroundImageView.contentMode = UIViewContentModeScaleToFill;
        _fakeBackgroundImageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0];
    }
    return _fakeBackgroundImageView;
}

- (UIVisualEffectView *)fakeBackgroundEffectView {
    if (!_fakeBackgroundEffectView) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        _fakeBackgroundEffectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        _fakeBackgroundEffectView.userInteractionEnabled = NO;
    }
    return _fakeBackgroundEffectView;
}

- (UIImageView *)fakeShadowImageView {
    if (!_fakeShadowImageView) {
        _fakeShadowImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _fakeShadowImageView.userInteractionEnabled = NO;
        _fakeShadowImageView.contentScaleFactor = 1;
    }
    return _fakeShadowImageView;
}

@end
