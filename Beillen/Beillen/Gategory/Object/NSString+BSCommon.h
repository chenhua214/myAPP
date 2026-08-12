//
//  NSString+BSCommon.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (BSCommon)
#pragma mark - 简单计算textsize
- (CGSize)bs_sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font;
- (CGSize)bs_sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font maxHeight:(CGFloat)maxHeight;

- (CGSize)bs_sizeWithLabelHeight:(CGFloat)height font:(UIFont *)font;
- (CGSize)bs_sizeWithLabelHeight:(CGFloat)height font:(UIFont *)font maxWidth:(CGFloat)maxWidth;

- (BOOL)isEnable;
// 判断字符是否存在
+ (BOOL )isEnableWithString:(NSString *)inputStr;
+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval;
+ (NSString *)getWeekDayForDate:(int64_t)date;
//+ (NSString *)ConvertStrToTime:(NSInteger)timestamp datype:(NSString*)format ;
+ (NSString *)ConvertStrToDateTime:(NSInteger)timestamp datype:(NSString*)format ;
+ (NSString *)ConvertStrToTime:(int64_t)timestamp format:(NSString*)format ;
- (BOOL)isStrcheckIsHaveNumAndLetter;

- (NSData *)convertBytesStringToData;
- (NSString *)hexNumberStringToNumberString:(NSString *)hexNumberString ;
- (NSString *)hexNumberStringToNumberString;
- (NSMutableData *)convertHexStrToData:(NSString *)str;
+ (NSMutableData *)convertHexStrToData:(NSString *)str;
- (NSString *)ToHex:(long long int)tmpid;
- (NSString *)toHex;
/// 将数字字符串转为16进制的byte数据
- (NSData *)byteData4NumberString;

/**
 二进制转换为十进制
  
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary;
/**
 十进制转换为二进制
  
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal;
/**
 二进制转换成十六进制
   
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary;
/**
 十六进制转换为二进制
   
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex;
// 将十进制转十六进制、不足4位补足4位
+ (NSString *)stringTo4Lenght16Hex:(long long int)hex;

/// 将字符串转换成带删除线的富文本
- (NSAttributedString *)setDeleteModelWithTextColor:(UIColor *)color font:(UIFont *)font;

+ (NSString *)bs_priceShowTwoPointStr:(double)price;
+ (NSString *)validNumberStringWith:(id)number;
+ (NSString *)bs_validNumberStringWith:(double)number ;
+ (NSMutableAttributedString *)priceWithNum:(double)number tFont:(UIFont *)font tColor:(UIColor *)color cFont:(UIFont *)cellFont cColor:(UIColor *)cellColor;
/// 转成有效的数字字符串 ex：80.00 -> 80；80.10 -> 80.1
+ (NSString *)removeInvalidNumberWithData:(id)number;
//  是否是手机电话
+ (BOOL )bs_isMobileNumber:(NSString *)mobileNum ;
//  是否是邮箱注册
+ (BOOL )bs_isEmailWithAccount:(NSString *)account ;
/// 拨打电话
- (void)call;

/// 判断字符串是否为数字<正负整数,正负浮点数,0>
- (BOOL)isValidNumber;
- (NSString *)replaceUnicode;
/// 判断是否含有非法字符
- (BOOL)isJudgeTheillegalCharacter;
/// 判断是否只有数字和字母方法
- (BOOL)isJudgeOnlyNumbersAndLetters;
- (NSString*)bs_HidingPhoneNumber ;
- (NSString *)bs_hiddenEmailNum;

//ASCII码0.5长度 中文1长度
- (CGFloat)bs_length;

/// 生成指定长度(length)的随机字符串
/// - Parameter length: 长度
+ (NSString *)randomStringWithLength:(int)length;

/// 给定字符串添加删除线
- (NSAttributedString *)strikethroughStyle;

- (BOOL)isMatchRegex:(NSString *)regex;

/// 数字是否大于0
- (BOOL)isNumberGreaterThanZero;

//HmacSHA1加密；
+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data;

// sha1 哈希算法
+ (NSString *)sha1:(NSString *)inputString;

// url ecoding
- (NSString *)urlEncode;

/// 截取部分范围
- (NSString*)substring:(NSString*)originalString range:(NSRange)range;

- (nullable NSDictionary *)toJson;
- (nullable NSArray<NSDictionary *> *)toJsonArr;
@end

NS_ASSUME_NONNULL_END
