//
//  BSStringUtil.m
//  JDKJAPP
//
//  Created by chenyi on 2026/7/20.
//

#import "BSStringUtil.h"
#import<CommonCrypto/CommonDigest.h>


@implementation BSStringUtil
+ (BOOL)isBlankWithString:(NSString *)string {
    if (string == nil || string == NULL) {
        return YES;
    }
    if (![string isKindOfClass:[NSString class]]) {
        return YES;
    }
    if ([string isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([string isEqualToString:@"<null>"]) {
        return YES;
    }
    if (string.length == 0) {
        return YES;
    }
    
    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        return YES;
    }
    return NO;
}

+ (NSString *)removePhoneBugWithString:(NSString *)string {
    string = [[string componentsSeparatedByCharactersInSet:[[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet]] componentsJoinedByString:@""];
    return string;
}

+ (BOOL)isEmailAddressWithString:(NSString *)string {
    NSString *emailRegex = @"[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailRegex];
    return [emailTest evaluateWithObject:string];
}

+ (NSString *)removeBothSideBlankWithString:(NSString *)string {
   if (![string isKindOfClass:[NSString class]] || string == NULL || string.length == 0) {
        return string;
    }
   return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+ (NSString *)removeBlankWithString:(NSString *)string {
    return [string stringByReplacingOccurrencesOfString:@" " withString:@""];
}

+ (NSString *)encryptPhoneWithString:(NSString *)string {
    string = [self removePhoneBugWithString:string];
    if (string.length == 11) {
        NSString  *phoneNumber = [string stringByReplacingCharactersInRange:NSMakeRange(3, 4)  withString:@"****"];
        return phoneNumber;
    }
    return @"";
}

+ (NSString *)md5:(NSString *)input {
    const char *cStr = [input UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5( cStr, strlen(cStr), digest ); // This is the md5 call
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    return  output;
}

+ (NSString *)filterHTML:(NSString *)htmlString {
    NSScanner *scanner = [NSScanner scannerWithString:htmlString];
    NSString *text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"<" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@">" intoString:&text];
        //替换字符
        htmlString = [htmlString stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    return htmlString;
}

+ (BOOL)isContainLetterWithString:(NSString *)string {
   BOOL isContain = NO;
   for (int i=0; i<string.length; i++) {
        NSRange range =NSMakeRange(i, 1);
        NSString * strFromSubStr=[string substringWithRange:range];
        const char * cStringFromstr=[strFromSubStr UTF8String];
        //1、含有字母 3、是含含有汉字
        if (strlen(cStringFromstr)==1)
        {
            isContain = YES;
            break;
        }
   }
    return isContain;
}
@end
