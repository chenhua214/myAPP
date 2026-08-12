//
//  UIViewController+YGNavigationBar.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (YGNavigationBar)
/// 导航栏样式、默认样式
@property (nonatomic, assign) UIBarStyle bs_barStyle;

/// 导航栏前景色（Item的文字图标颜色）（默认黑色）
@property (nonatomic, strong) UIColor *bs_tintColor;

/// 导航栏标题文字颜色 （默认黑色）
@property (nonatomic, strong) UIColor *bs_titleColor;

/// 导航栏标题文字字体（默认18号）
@property (nonatomic, strong) UIFont *bs_titleFont;

/// 导航栏背景色（白色）
@property (nonatomic, strong) UIColor *bs_backgroundColor;

/// 导航栏背景图片
@property (nonatomic, strong) UIImage *bs_backgroundImage;

/// 导航栏背景透明度 （默认1）
@property (nonatomic) CGFloat bs_barAlpha;

/// 导航栏底部分割线是否隐藏（默认隐藏）
@property (nonatomic) BOOL bs_shadowHidden;

/// 导航栏底部分割线颜色
@property (nonatomic, strong) UIColor *bs_shadowColor;

/// 是否开启手势返回
@property (nonatomic) BOOL bs_enablePopGesture;



@end

NS_ASSUME_NONNULL_END
