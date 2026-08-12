//
//  BSStringUtil.h
//  JDKJAPP
//
//  Created by chenyi on 2026/7/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BSStringUtil : NSObject

/**
 * 判断空  YES：空字符串 NO：非空
 *
 * @param string 判空字符串
 *
 * @return YES / NO
 */
+ (BOOL)isBlankWithString:(NSString *)string;

/**
 * 数字去空
 *
 * @param string 需要去空字符串
 *
 * @return 去除空格后字符串
 */
+ (NSString *)removePhoneBugWithString:(NSString *)string;

/**
 * 验证邮箱
 *
 * @param string 需要验证字符串
 *
 * @return YES / NO
 */
+ (BOOL)isEmailAddressWithString:(NSString *)string;

/// 去除首尾空格
/// @param string 待处理的字符串
+ (NSString *)removeBothSideBlankWithString:(NSString *)string;

/// 去除所有空格
/// @param string  待处理的字符串
+ (NSString *)removeBlankWithString:(NSString *)string;

/**
 *  手机号码中间几位处理  打码
 */
+ (NSString *)encryptPhoneWithString:(NSString *)string;

/// md5
/// @param input 待处理的字符串
+ (NSString *)md5:(NSString *)input;

/// 过滤HTML标签
/// @param htmlString 待处理的字符串
+ (NSString *)filterHTML:(NSString *)htmlString;

/// 判断是否有字母
/// @param string 待处理的字符串
+ (BOOL)isContainLetterWithString:(NSString *)string;


@end

NS_ASSUME_NONNULL_END
