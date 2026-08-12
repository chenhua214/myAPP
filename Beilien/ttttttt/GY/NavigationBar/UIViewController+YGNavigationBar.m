//
//  UIViewController+YGNavigationBar.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import "UIViewController+YGNavigationBar.h"
#import "YGNavigationController.h"

static NSString * const BSBarStyle         = @"BSNavigationBarKeys_barStyle";
static NSString * const BSTintColor        = @"BSNavigationBarKeys_tintColor";
static NSString * const BSTitleColor       = @"BSNavigationBarKeys_titleColor";
static NSString * const BSTitleFont        = @"BSNavigationBarKeys_titleFont";
static NSString * const BSBackgroundColor  = @"BSNavigationBarKeys_backgroundColor";
static NSString * const BSBackgroundImage  = @"BSNavigationBarKeys_backgroundImage";
static NSString * const BSBarAlpha         = @"BSNavigationBarKeys_barAlpha";
static NSString * const BSShadowHidden     = @"BSNavigationBarKeys_shadowHidden";
static NSString * const BSShadowColor      = @"BSNavigationBarKeys_shadowColor";
static NSString * const BSEnablePopGesture = @"BSNavigationBarKeys_enablePopGesture";

@implementation UIViewController (YGNavigationBar)

// 导航栏样式、默认样式
- (void)setBs_barStyle:(UIBarStyle)bs_barStyle
{
    objc_setAssociatedObject(self, &BSBarStyle, @(bs_barStyle), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarTintUpdate];
}
- (UIBarStyle)bs_barStyle
{
    UIBarStyle barstyle = (UIBarStyle)objc_getAssociatedObject(self, &BSBarStyle);
    return barstyle ?: [UINavigationBar appearance].barStyle;
}

// 导航栏前景色（Item的文字图标颜色）（默认黑色）
- (void)setBs_tintColor:(UIColor *)bs_tintColor
{
    objc_setAssociatedObject(self, &BSTintColor, bs_tintColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarTintUpdate];
}
- (UIColor *)bs_tintColor
{
    UIColor *tintColor;
    tintColor = objc_getAssociatedObject(self, &BSTintColor);
    if (!tintColor) tintColor = [UINavigationBar appearance].tintColor;
    return tintColor ?: [UIColor blackColor];
}

// 导航栏标题文字颜色
- (void)setBs_titleColor:(UIColor *)bs_titleColor
{
    objc_setAssociatedObject(self, &BSTitleColor, bs_titleColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarTintUpdate];
}
- (UIColor *)bs_titleColor
{
    UIColor *titleColor;
    titleColor = objc_getAssociatedObject(self, &BSTitleColor);
    if (!titleColor) titleColor = [UINavigationBar appearance].titleTextAttributes[NSForegroundColorAttributeName];
    return titleColor ?: [UIColor bs_colorFromARGB:@"#111113"];
}

// 导航栏标题文字字体
- (void)setBs_titleFont:(UIFont *)bs_titleFont
{
    objc_setAssociatedObject(self, &BSTitleFont, bs_titleFont, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarTintUpdate];
}
- (UIFont *)bs_titleFont
{
    UIFont *font;
    font = objc_getAssociatedObject(self, &BSTitleFont);
    if (!font) font = [UINavigationBar appearance].titleTextAttributes[NSFontAttributeName];
    return font ?: [UIFont bs_regularFontWithFontSize:18];
}

// 导航栏背景色
- (void)setBs_backgroundColor:(UIColor *)bs_backgroundColor
{
    objc_setAssociatedObject(self, &BSBackgroundColor, bs_backgroundColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarBackgroundUpdate];
}
- (UIColor *)bs_backgroundColor
{
    UIColor *backgroundColor;
    backgroundColor = objc_getAssociatedObject(self, &BSBackgroundColor);
    if (!backgroundColor) backgroundColor = [UINavigationBar appearance].barTintColor;
    return backgroundColor ?: [UIColor whiteColor];
}

// 导航栏背景图片
- (void)setBs_backgroundImage:(UIImage *)bs_backgroundImage
{
    objc_setAssociatedObject(self, &BSBackgroundImage, bs_backgroundImage, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarBackgroundUpdate];
}
- (UIImage *)bs_backgroundImage
{
    UIImage *image = objc_getAssociatedObject(self, &BSBackgroundImage);
    return image ?: [[UINavigationBar appearance] backgroundImageForBarMetrics:UIBarMetricsDefault];
}

// 导航栏背景透明度
- (void)setBs_barAlpha:(CGFloat)bs_barAlpha
{
    objc_setAssociatedObject(self, &BSBarAlpha, @(bs_barAlpha), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarBackgroundUpdate];
}
- (CGFloat)bs_barAlpha
{
    id alpha = objc_getAssociatedObject(self, &BSBarAlpha);
    return alpha ? [alpha floatValue] : 1;
}

// 导航栏底部分割线是否隐藏
- (void)setBs_shadowHidden:(BOOL)bs_shadowHidden
{
    objc_setAssociatedObject(self, &BSShadowHidden, @(bs_shadowHidden), OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarShadowUpdate];
}
- (BOOL)bs_shadowHidden
{
    return [objc_getAssociatedObject(self, &BSShadowHidden) boolValue];
}

// 导航栏底部分割线颜色
- (void)setBs_shadowColor:(UIColor *)bs_shadowColor
{
    objc_setAssociatedObject(self, &BSShadowColor, bs_shadowColor, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self bs_setNeedsNavigationBarShadowUpdate];
}
- (UIColor *)bs_shadowColor
{
    UIColor *color = objc_getAssociatedObject(self, &BSShadowColor);
    return color ?: [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1];
}

// 是否开启手势返回
- (void)setBs_enablePopGesture:(BOOL)bs_enablePopGesture
{
    objc_setAssociatedObject(self, &BSEnablePopGesture, @(bs_enablePopGesture), OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (BOOL)bs_enablePopGesture
{
    id gesture = objc_getAssociatedObject(self, &BSEnablePopGesture);
    return gesture ? [gesture boolValue] : YES;
}




// MARK:- 更新UI

/// 整体更新
- (void)bs_setNeedsNavigationBarUpdate
{
    YGNavigationController *naviController = (YGNavigationController *)self.navigationController;
    if (naviController) {
        [naviController bs_updateNavigationBarForController:self];
    }
}

/// 更新文字、Title颜色
- (void)bs_setNeedsNavigationBarTintUpdate
{
    YGNavigationController *naviController = (YGNavigationController *)self.navigationController;
    if (naviController) {
        [naviController bs_updateNavigationBarTintForController:self ignoreTintColor:NO];
    }
}

/// 更新背景
- (void)bs_setNeedsNavigationBarBackgroundUpdate
{
    YGNavigationController *naviController = (YGNavigationController *)self.navigationController;
    if (naviController) {
        [naviController bs_updateNavigationBarBackgroundColorForController:self];
    }
}

/// 更新Shadow
- (void)bs_setNeedsNavigationBarShadowUpdate
{
    YGNavigationController *naviController = (YGNavigationController *)self.navigationController;
    if (naviController) {
        [naviController bs_updateNavigationBarShadowForController:self];
    }
}


@end
