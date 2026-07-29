//
//  UIColor+BSExpanded.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/18.
//

#import "UIColor+BSExpanded.h"

@implementation UIColor (BSExpanded)

+ (UIColor *)bs_randomColor {
    return [UIColor colorWithRed:(arc4random()%256)/256.f
                           green:(arc4random()%256)/256.f
                            blue:(arc4random()%256)/256.f
                           alpha:1.0f];
}

+ (UIColor *)colorWithRGBHex:(UInt32)hex {
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f
                           green:g / 255.0f
                            blue:b / 255.0f
                           alpha:1.0f];
}

+ (UIColor *)bs_colorFromARGB:(NSString *)hexString {
    if (!hexString || hexString.length == 0 || [hexString isEqualToString:@"#"]) {
        return [UIColor clearColor];
    }
    NSString *cleanString = [hexString stringByReplacingOccurrencesOfString:@"#" withString:@""];
    cleanString = [cleanString stringByReplacingOccurrencesOfString:@" " withString:@""];
    if(cleanString.length != 3 && cleanString.length != 4 && cleanString.length != 6 && cleanString.length != 8){
        return [UIColor clearColor];
    }
    if([cleanString length] == 3) {
        cleanString = [NSString stringWithFormat:@"ff%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)]];
    }else if([cleanString length] == 4){
        cleanString = [NSString stringWithFormat:@"%@%@%@%@%@%@%@%@",
                       [cleanString substringWithRange:NSMakeRange(0, 1)],[cleanString substringWithRange:NSMakeRange(0, 1)],
                       [cleanString substringWithRange:NSMakeRange(1, 1)],[cleanString substringWithRange:NSMakeRange(1, 1)],
                       [cleanString substringWithRange:NSMakeRange(2, 1)],[cleanString substringWithRange:NSMakeRange(2, 1)],
                       [cleanString substringWithRange:NSMakeRange(3, 1)],[cleanString substringWithRange:NSMakeRange(3, 1)]];
    }else if([cleanString length] == 6) {
        cleanString = [NSString stringWithFormat:@"%@%@", @"ff",cleanString];
    }
    NSString *aString = [cleanString substringWithRange:NSMakeRange(0, 2)];
    NSString *rString = [cleanString substringWithRange:NSMakeRange(2, 2)];
    NSString *gString = [cleanString substringWithRange:NSMakeRange(4, 2)];
    NSString *bString = [cleanString substringWithRange:NSMakeRange(6, 2)];
    
    // Scan values(16进制转10进制)
    unsigned int a, r, g, b;
    [[NSScanner scannerWithString:aString] scanHexInt:&a];
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a/255.f];
    
}

+ (UIColor *)colorFromHexString:(NSString *)colorString {
    return [self colorFromHexString:colorString alpha:1.0f];
}

+ (UIColor *)colorFromHexString:(NSString *)colorString
                          alpha:(CGFloat)alpha {
    NSString *cString = [[colorString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];// 转成大写
    if (cString.length < 6) {
        return [UIColor whiteColor];
    }
    
    if ([cString hasPrefix:@"0X"]) {
        cString = [cString substringFromIndex:2];
    }else if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    
    if (cString.length != 6) {
        return [UIColor whiteColor];
    }
    
    NSString *rString = [cString substringWithRange:NSMakeRange(0, 2)];
    NSString *gString = [cString substringWithRange:NSMakeRange(2, 2)];
    NSString *bString = [cString substringWithRange:NSMakeRange(4, 2)];
    
    // Scan values(16进制转10进制)
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:alpha];
    
}

+ (UIColor *)bs_colorFromARGB:(NSString *)hexString
                         alpha:(CGFloat)alpha {
    return [[UIColor bs_colorFromARGB:hexString] colorWithAlphaComponent:alpha];
}

+ (UIColor *)bs_backgroundColor
{
    return [[UIColor bs_colorFromARGB:@"#EBEBEB"] colorWithAlphaComponent:1.0f];
}

+ (UIColor *)bs_backgroundColor_LightGray
{
    return [[UIColor bs_colorFromARGB:@"#F8F8F8"] colorWithAlphaComponent:1.0f];
}

+ (UIColor *)bs_BtnBackColor{
    return [[UIColor bs_colorFromARGB:@"#FD6906"] colorWithAlphaComponent:1.0f];
}

+ (UIColor *)bs_BtnBackColor_Yellow{
    return [[UIColor bs_colorFromARGB:@"#FFE800"] colorWithAlphaComponent:1.0f];
}

+ (UIColor *)bs_BtnBackGrayColor  {
    return [[UIColor bs_colorFromARGB:@"#F0F0F1"] colorWithAlphaComponent:1.0f];
}

+ (UIColor *)bs_BtnBackDisabledColor  {
    return [[UIColor bs_colorFromARGB:@"#FFD1B3"] colorWithAlphaComponent:1.0f];
}



@end
