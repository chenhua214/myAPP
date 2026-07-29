//
//  UITabBar+BSAddition.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITabBar (BSAddition)

/// 设置TabBar背景色 和 分割线颜色
/// @param backgroundColor 背景色
/// @param separatorColor 分割线颜色
- (void)tabBarBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorColor:(nullable UIColor *)separatorColor;

/// 设置TabBar背景色 和 分割线颜色、高度
/// @param backgroundColor 背景色
/// @param separatorColor 分割线颜色
/// @param height 分割线高度
- (void)tabBarBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorColor:(nullable UIColor *)separatorColor height:(CGFloat)height;

/// 设置TabBar背景色 和 分割线视图
/// @param view _UIBarBackground 视图
/// @param backgroundColor 背景色
/// @param separatorView 分割线视图
- (BOOL)tabBarBackgroundView:(UIView *)view resetBackgroundColor:(nullable UIColor *)backgroundColor customSeparatorView:(nullable UIView *)separatorView;

@end

NS_ASSUME_NONNULL_END
