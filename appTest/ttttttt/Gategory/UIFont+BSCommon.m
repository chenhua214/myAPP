//
//  UIFont+BSCommon.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import "UIFont+BSCommon.h"
#import <CoreText/CoreText.h>
@implementation UIFont (BSCommon)


+ (UIFont *)bs_dinBoldFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"DINAlternate-Bold" size:fontSize];
}

+ (UIFont *)bs_PingFangHeavyFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}

+ (UIFont *)bs_PingFangBoldFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}

+ (UIFont *)bs_mediumFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Medium" size:fontSize];
}

+ (UIFont *)bs_regularFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
}

+ (UIFont *)bs_semiboldFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Semibold" size:fontSize];
}

+ (UIFont *)bs_thinFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Thin" size:fontSize];
}

+ (UIFont *)bs_lightFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"PingFangSC-Light" size:fontSize];
}

+ (UIFont *)bs_helveticaFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Helvetica" size:fontSize];
}

+ (UIFont *)bs_helveticaBoldFontWithFontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:@"Helvetica-Bold" size:fontSize];
}

+ (UIFont *)bs_FuturaMediumFontWithFontSize:(CGFloat)fontSize {
    NSString *familyName = @"Futura";
    NSString *fontName = @"Futura-Medium";
    NSArray<NSString *> *fontNames = [UIFont fontNamesForFamilyName:familyName];
    if ([fontNames containsObject:fontName]) {
        return [UIFont fontWithName:fontName size:fontSize];
    }
    return [self bs_helveticaFontWithFontSize:fontSize];
}

+ (UIFont *)bs_systemFontWithFontSize:(CGFloat)fontSize weight:(UIFontWeight)weight{
    return [UIFont systemFontOfSize:fontSize weight:weight];
}

+ (UIFont *)bs_fontWithName:(NSString *)fontName fontSize:(CGFloat)fontSize {
    return [UIFont fontWithName:fontName size:fontSize];
}
@end
