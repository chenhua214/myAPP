//
//  UIFont+BSCommon.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIFont (BSCommon)
/**
 * 设置 DINAlternate-Bold 字体   一般用于价格
 *
 * @return UIFont
 */
+ (UIFont *)bs_dinBoldFontWithFontSize:(CGFloat)fontSize;
/**
 * 设置 DINAlternate-Heavy 字体   一般用于价格
 *
 * @return UIFont
 */
+ (UIFont *)bs_PingFangHeavyFontWithFontSize:(CGFloat)fontSize ;
/**
 * pingfung Bold 字体  ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_PingFangBoldFontWithFontSize:(CGFloat)fontSize;
/**
 * pingfung medium 字体  ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_mediumFontWithFontSize:(CGFloat)fontSize;

/**
 * pingfung regular 字体  ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_regularFontWithFontSize:(CGFloat)fontSize;

/**
 * pingfung semibold 字体 ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_semiboldFontWithFontSize:(CGFloat)fontSize;

/**
 * pingfung thin 字体 ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_thinFontWithFontSize:(CGFloat)fontSize;

/**
 * pingfung Light 字体 ios9
 *
 * @return UIFont
 */
+ (UIFont *)bs_lightFontWithFontSize:(CGFloat)fontSize;

/**
 * Helvetica字体
 *
 * @return UIFont
 */
+ (UIFont *)bs_helveticaFontWithFontSize:(CGFloat)fontSize;


/// Helvetica粗体
/// @param fontSize 字体大小

+ (UIFont *)bs_helveticaBoldFontWithFontSize:(CGFloat)fontSize;

/// Futura中粗
/// @param fontSize 字体大小
+ (UIFont *)bs_FuturaMediumFontWithFontSize:(CGFloat)fontSize;

/// 返回字体
/// @param fontSize 大小
/// @param weight 字重
+ (UIFont *)bs_systemFontWithFontSize:(CGFloat)fontSize weight:(UIFontWeight)weight;

/// 自定义字体
/// @param fontName 字体的名字
/// @param fontSize 字体大小
+ (UIFont *)bs_fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
