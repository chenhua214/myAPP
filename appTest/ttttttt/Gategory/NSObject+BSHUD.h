//
//  NSObject+HUD.h
//  Baseus. All r
//
//  Created by  on 2018/7/18.
//  Copyright ©
//

#import <Foundation/Foundation.h>

@interface NSObject (BSHUD)

/// 显示loading视图
- (void)showHud;

/// 显示loading视图
/// @param duration 显示时长( <=0 标识不自动消失 )
- (void)showHudWithDuration:(NSTimeInterval)duration;

/// 显示loading视图
/// @param duration 显示时长( <=0 标识不自动消失 )
/// @param timeoutTip 超时提示文案(最长显示3秒)
- (void)showHudWithDuration:(NSTimeInterval)duration timeoutTip:(nullable NSString *)timeoutTip;

/// 显示loading视图
/// @param duration 显示时长( <=0 标识不自动消失 )
/// @param hint     提示文字
/// @param timeoutTip 超时提示文案(最长显示3秒)
- (void)showHudWithDuration:(NSTimeInterval)duration hint:(nullable NSString *)hint timeoutTip:(nullable NSString *)timeoutTip;

/// 显示视图
/// @param view 视图
- (void)showHudInView:(nullable UIView *)view;

/// 显示视图
/// @param view 视图
/// @param duration 显示时长( <=0 标识不自动消失 )
- (void)showHudInView:(nullable UIView *)view duration:(NSTimeInterval)duration;

/// 显示视图
/// @param view 父视图
/// @param hint 提示文字
- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint;

/// 显示视图
/// @param view 父视图
/// @param hint 提示文字
/// @param duration 显示时长( <= 0 时,不自动消失)
- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint duration:(NSTimeInterval)duration;

/// 显示视图
/// @param view 父视图
/// @param hint 提示文字
/// @param duration 显示时长( <= 0 时,不自动消失)
/// @param timeoutTip 超时提示文案(最长显示3秒)
- (void)showHudInView:(nullable UIView *)view hint:(nullable NSString *)hint duration:(NSTimeInterval)duration timeoutTip:(nullable NSString *)timeoutTip;

/// 显示全屏提示视图
/// @param hint 提示文字
- (void)showFullScreenLoadingViewWithHint:(nullable NSString *)hint;

/// 隐藏hud
- (void)hideHud;

/// 显示文字
/// @param hint 文字
- (void)showHint:(nullable NSString *)hint;
- (void)showHintInWindow:(nullable NSString *)hint;
- (void)showHint:(nullable NSString *)hint view:(nullable UIView*)view;
// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(nullable NSString *)hint yOffset:(float)yOffset;
- (void)showHint:(nullable NSString *)hint view:(nullable UIView*)view yOffset:(float)yOffset;
- (void)showHint:(nullable NSString *)hint backAlpha:(float)alpha ;
- (void)showActiveHUD;

- (void)showActiveHUDInView:(nullable UIView *)view;

- (void)showHudInWindow;

@end
