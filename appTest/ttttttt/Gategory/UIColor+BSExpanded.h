//
//  UIColor+BSExpanded.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (BSExpanded)

/**
 * 随机颜色
 *
 * @return 颜色color
*/
+ (UIColor *)bs_randomColor;


/**
 * 颜色方法
 *
 * @param hexString    颜色值
 *
 * @return 颜色color
*/
+ (UIColor *)bs_colorFromARGB:(NSString *)hexString;

/**
 * 带有透明度的颜色
 *
 * @param hexString    颜色值
 * @param alpha  透明度
 *
 * @return 颜色color
*/
+ (UIColor *)bs_colorFromARGB:(NSString *)hexString
                         alpha:(CGFloat)alpha;

/**
 * 背景颜色
 * @return 颜色color
*/
+ (UIColor *)bs_backgroundColor;

+ (UIColor *)bs_backgroundColor_LightGray;

/**
 * 按钮背景颜色
 * @return 颜色color
*/
+ (UIColor *)bs_BtnBackColor;
+ (UIColor *)bs_BtnBackColor_Yellow;

+ (UIColor *)bs_BtnBackGrayColor ;
+ (UIColor *)bs_BtnBackDisabledColor ;
@end

NS_ASSUME_NONNULL_END
