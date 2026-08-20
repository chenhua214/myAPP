//
//  UIView+Common.h
//  Beillen
//
//  Created by  wang on 2021/1/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (BSCommon)

+ (UILabel *)bs_labelWithFont:(UIFont * __nullable)font
              textAlignment :(NSTextAlignment)textAlignment
                   textColor:(UIColor * __nullable)textColor;

+ (UILabel *)bs_labelWithFont:(UIFont *__nullable)font
              textAlignment :(NSTextAlignment )textAlignment
                   textColor:(UIColor *__nullable)textColor
                     bgColor:(UIColor *__nullable)bgColor;

+(UITextField *)bs_textFieldWithFont:(UIFont * __nullable)font
                      textAlignment :(NSTextAlignment)textAlignment
                           textColor:(UIColor * __nullable)textColor
                         placeholder:(NSString * __nullable)placeholder
                    placeholderColor:(UIColor * __nullable)placeholderColor
                     placeholderFont:(UIFont * __nullable)placeholderFont;

/// 根据userInteractionEnabled设置view及子视图的透明度
/// @param userInteractionEnabled userInteractionEnabled
/// @param alpha alpha
- (void)setUserInteractionEnabled:(BOOL)userInteractionEnabled alphaForAll:(float)alpha;

/// 添加/移除默认渐变layer
- (void)addGradientLayer:(BOOL)add;

- (void)addGradientLayer:(BOOL)add colors:(NSArray<UIColor *> *)colors;

- (void)addGradientLayer:(BOOL)add startPoint:(CGPoint)startPoint endPoint:(CGPoint)endPoint colors:(NSArray<UIColor *> *)colors locations:(NSArray<NSNumber *> *)locations;

@end

NS_ASSUME_NONNULL_END
