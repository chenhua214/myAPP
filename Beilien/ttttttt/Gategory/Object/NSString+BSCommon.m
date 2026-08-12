//
//  NSString+BSCommon.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import "NSString+BSCommon.h"
#import <CoreTelephony/CTCarrier.h>
//#import <C1oreTel111ephony/C1TTelephony111NetworkInfo.h>
#import <CommonCrypto/CommonDigest.h>
//#import "BSDeviceUtil.h"
#include <CommonCrypto/CommonHMAC.h>
#import "BSCommonDevice.h"
@implementation NSString (BSCommon)

- (CGSize)bs_sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font{
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

- (CGSize)bs_sizeWithLabelWidth:(CGFloat)width font:(UIFont *)font maxHeight:(CGFloat)maxHeight{
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, MIN(maxHeight, sizeHieght));
}

- (CGSize)bs_sizeWithLabelHeight:(CGFloat)height font:(UIFont *)font{
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:NSStringDrawingTruncatesLastVisibleLine |
    NSStringDrawingUsesLineFragmentOrigin |
    NSStringDrawingUsesFontLeading attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(sizeWidth, sizeHieght);
}

- (CGSize)bs_sizeWithLabelHeight:(CGFloat)height font:(UIFont *)font maxWidth:(CGFloat)maxWidth {
    NSDictionary *dict=@{NSFontAttributeName : font};
    CGRect rect=[self boundingRectWithSize:CGSizeMake(MAXFLOAT, height) options:(NSStringDrawingUsesLineFragmentOrigin) attributes:dict context:nil];
    CGFloat sizeWidth=ceilf(CGRectGetWidth(rect));
    CGFloat sizeHieght=ceilf(CGRectGetHeight(rect));
    return CGSizeMake(MIN(maxWidth, sizeWidth), sizeHieght);
}

//根据时间戳获取星期几
+ (NSString *)getWeekDayForDate:(int64_t)date
{
    long long time= date /1000;
    NSArray *weekday = [NSArray arrayWithObjects: [NSNull null],@"week_7", @"week_1", @"week_2", @"week_3", @"week_4", @"week_5", @"week_6", nil];
    NSDate *newDate = [NSDate dateWithTimeIntervalSince1970:time];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [calendar components:NSCalendarUnitWeekday fromDate:newDate];

    NSString *weekStr = [weekday objectAtIndex:components.weekday];
    return weekStr;
//    return NSLocalizedStringkey(weekStr) ;
}

+(NSString *)getYMD:(NSDate *)date
{
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"yyyy-MM-dd"];
    
    //获取传过来的时间的时分
    NSDateFormatter *fo = [[NSDateFormatter alloc] init];
    [fo setDateFormat:@"HH:mm"];
    fo.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSString *hoursandSec = [fo stringFromDate:date];
    
    //获取传过来的时间的date
    NSString *createDate = [format stringFromDate:date];
    
    //获取今天
    NSDate *nowDate = [NSDate date];
    NSString *today = [format stringFromDate:nowDate];
    
    //获取昨天
    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [format stringFromDate:yesterdayDate];
    
    if ([createDate isEqualToString:today]) {
        return [NSString stringWithFormat:@"今天%@",hoursandSec];
    }else if ([createDate isEqualToString:yesterday])
    {
         return [NSString stringWithFormat:@"昨天%@",hoursandSec];
    }else
    {
        return [NSString stringWithFormat:@"%@ %@",createDate,hoursandSec];
    }
}

+ (NSDateFormatter *)formatter{
    static NSDateFormatter *_formatter = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _formatter = [[NSDateFormatter alloc] init];
    });
    return _formatter;
}

+ (NSString *)ConvertStrToTime:(int64_t)timestamp format:(NSString*)format{
    if (timestamp <= 0) {
        return @"";
    }
//     如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    NSTimeInterval createTime = timestamp /1000;
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    NSTimeInterval time = currentTime - createTime;
    
    NSDate *dateHH = [[NSDate alloc] initWithTimeIntervalSince1970:createTime];
    NSDateFormatter *formatter = [self formatter];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:[[NSLocale currentLocale] localeIdentifier]];
    [formatter setDateFormat:@"hh:mm aa"];
    NSString*HHmm = [formatter stringFromDate:dateHH];
    
    NSDate *date1 = [[NSDate alloc]initWithTimeIntervalSince1970:createTime];
    NSDate *dateNow = [[NSDate alloc]initWithTimeIntervalSince1970:currentTime];

    [formatter setDateFormat:@"yyyyMMdd"];
    NSString*dayString = [formatter stringFromDate:date1];
    NSString*dayNowString = [formatter stringFromDate:dateNow];

    NSDate *yesterdayDate = [NSDate dateWithTimeIntervalSinceNow:-(24*60*60)];
    NSString *yesterday = [formatter stringFromDate:yesterdayDate];
    
    if ([dayString isEqualToString:dayNowString]) {
        return HHmm ;
    }
    
    if ([yesterday isEqualToString:dayString]) {
//        return [NSString stringWithFormat:@"%@ %@",NSLocalizedStringkey(@"yesterday_label"),HHmm];;
        return [NSString stringWithFormat:@"%@ %@",(@"时间"),HHmm];;
    }
    
    //  本周内显示星期
    NSInteger days = time/3600/24;
    if (days < 7 && [self isSameWeek:[NSDate dateWithTimeIntervalSince1970:timestamp/1000]]) {
        NSString *weak = [NSString getWeekDayForDate:timestamp];
        return  [NSString stringWithFormat:@"%@ %@",weak,HHmm];;
    }
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:createTime];
    if(format){
        [formatter setDateFormat:format];
    }else{
        [formatter setDateFormat:@"yyyy-MM-dd"];
    }
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}


+(NSString *)ConvertStrToDateTime:(NSInteger)timestamp datype:(NSString*)format
{

//     如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    NSTimeInterval createTime = timestamp /1000;
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setDateFormat:format ];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}



//给定日期与今天是否在同一周
+ (BOOL)isSameWeek:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    int unit = NSCalendarUnitWeekday | NSCalendarUnitMonth | NSCalendarUnitYear ;
    //1.获得当前时间的 年月日
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[NSDate date]];
    //2.获得self
    NSDateComponents *selfCmps = [calendar components:unit fromDate:date];
    return (selfCmps.year == nowCmps.year) && (selfCmps.month == nowCmps.month) && (selfCmps.day == nowCmps.day);
}

+ (NSString*)stringTtime:(NSInteger)createTime{
    NSDate *date = [[NSDate alloc]initWithTimeIntervalSince1970:createTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"dd"];
    return [formatter stringFromDate:date];
}

+ (NSString *)updateTimeForTimeInterval:(NSInteger)timeInterval {
    // 获取当前时时间戳 1466386762.345715 十位整数 6位小数
    NSTimeInterval currentTime = [[NSDate date] timeIntervalSince1970];
    // 创建歌曲时间戳(后台返回的时间 一般是13位数字)
    NSTimeInterval createTime = timeInterval/1000;
    // 时间差
    NSTimeInterval time = currentTime - createTime;
    if (time < 1) {
//        return NSLocalizedStringkey(@"just");
        return (@"刚刚");
    }
    // 秒转分钟
    NSInteger minute = time/60;
    if (minute < 1) {
//        return [NSString stringWithFormat:NSLocalizedStringkey(@"seconds_ago"),(int)time];
        return [NSString stringWithFormat:@"%d秒",(int)time];
    }
    if (minute < 60) {
        return [NSString stringWithFormat:@"%d分钟",(int)minute];
//        return [NSString stringWithFormat:NSLocalizedStringkey(@"minutes_ago"),minute];
    }
    // 秒转小时
    NSInteger hours = time/3600;
    if (hours<24) {
        return [NSString stringWithFormat:@"%d小时",(int)hours];
//        return [NSString stringWithFormat:NSLocalizedStringkey(@"hours_ago"),hours];
    }
    //秒转天数
    NSInteger days = time/3600/24;
    if (days < 30) {
        return [NSString stringWithFormat:@"%d天",(int)days];
//        return [NSString stringWithFormat:NSLocalizedStringkey(@"days_ago"),days];
    }
    //秒转月
    NSInteger months = time/3600/24/30;
    if (months < 12) {
        return [NSString stringWithFormat:@"%d月",(int)months];
//        return [NSString stringWithFormat:NSLocalizedStringkey(@"months_ago"),months];
    }
    //秒转年
    NSInteger years = time/3600/24/30/12;
    return [NSString stringWithFormat:@"%d年",(int)years];
//    return [NSString stringWithFormat:NSLocalizedStringkey(@"years_ago"),years];
}

- (BOOL)isEnable
{
    BOOL isEnableStr = YES ;
    if ( self == nil || self == NULL|| self.length<=0) {
        isEnableStr = NO;
    }
    return isEnableStr;
}

// 判断字符是否存在
+ (BOOL )isEnableWithString:(NSString *)inputStr{
    BOOL isEnableStr = NO ;
    if ([inputStr isKindOfClass:[NSString class]] && inputStr.isEnable){
        isEnableStr = YES;
    }
    return isEnableStr;
}

-(BOOL)isStrcheckIsHaveNumAndLetter{

    
    NSRegularExpression *tNumber= [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil] ;
    NSUInteger tNumMatchCount = [tNumber numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)] ;
    
    NSRegularExpression *tLetterRegularExpression= [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil] ;

    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    
    if (tNumMatchCount == self.length) {
//        全部数字，表示沒有英文
        return NO;
    }
    if ( tLetterMatchCount == self.length) {
//        全部符合英文，表示沒有数字
        return NO;
    }
    if (tNumMatchCount + tLetterMatchCount == self.length) {
//        全部符合英文，和数字
        return  YES;
    }
    else {
//        存在其他英文和数字之外的 字符
        return YES;
    }

}

- (NSData *)convertBytesStringToData{
    
    
    NSMutableData* data = [NSMutableData data];
       int idx;
       for (idx = 0; idx+2 <= self.length; idx+=2) {
           NSRange range = NSMakeRange(idx, 2);
           NSString* hexStr = [self substringWithRange:range];
           NSScanner* scanner = [NSScanner scannerWithString:hexStr];
           unsigned int intValue;
           [scanner scanHexInt:&intValue];
           [data appendBytes:&intValue length:1];
       }
       return data;
}

//十六进制数字字符串转换为10进制数字字符串的。
- (NSString *)hexNumberStringToNumberString:(NSString *)hexNumberString{

    unsigned int value = 0;

    NSScanner *scanner = [NSScanner scannerWithString:hexNumberString];

    [scanner setScanLocation:0];

    [scanner scanHexInt:&value];

    return [NSString stringWithFormat:@"%d",value];

}

- (NSString *)hexNumberStringToNumberString{
    unsigned int value = 0;
    NSScanner *scanner = [NSScanner scannerWithString:self];
    [scanner setScanLocation:0];
    [scanner scanHexInt:&value];
    return [NSString stringWithFormat:@"%d",value];
}

//将16进制的字符串转换成NSData
- (NSMutableData *)convertHexStrToData:(NSString *)str {
    return [NSString convertHexStrToData:str];
}

+ (NSMutableData *)convertHexStrToData:(NSString *)str {
    if (!str || [str length] == 0) {
        return nil;
    }
    NSMutableData *hexData = [[NSMutableData alloc] initWithCapacity:8];
    NSRange range;
    if ([str length] %2 == 0) {
        range = NSMakeRange(0,2);
    } else {
        range = NSMakeRange(0,1);
    }
    for (NSInteger i = range.location; i < [str length]; i += 2) {
        unsigned int anInt;
        NSString *hexCharStr = [str substringWithRange:range];
        NSScanner *scanner = [[NSScanner alloc] initWithString:hexCharStr];
        
        [scanner scanHexInt:&anInt];
        NSData *entity = [[NSData alloc] initWithBytes:&anInt length:1];
        [hexData appendData:entity];
        
        range.location += range.length;
        range.length = 2;
    }
    return hexData;
}

//将十进制转化为十六进制
 -(NSString *)ToHex:(long long int)tmpid
{
//    NSLog(@"10进制===%lld",tmpid) ;
    NSString *nLetterValue;
     NSString *str =@"";
    long long int ttmpig;
    for (int i = 0; i<19; i++) {
         ttmpig=tmpid%16;
        tmpid=tmpid/16;
        switch (ttmpig)
        {
            case 10:
                 nLetterValue =@"A";break;
            case 11:
                 nLetterValue =@"B";break;
            case 12:
                 nLetterValue =@"C";break;
            case 13:
                 nLetterValue =@"D";break;
            case 14:
                 nLetterValue =@"E";break;
            case 15:
                 nLetterValue =@"F";break;
            default:nLetterValue=[[NSString alloc]initWithFormat:@"%lli",ttmpig];
         }
         str = [nLetterValue stringByAppendingString:str];
         if (tmpid == 0) {
             break;
         }
     }
//    NSLog(@"16进制====%@  ",str) ;
     return str;
}

- (NSString *)toHex{
    NSInteger tmpid = self.integerValue;
    NSString *hexStr = [self ToHex:tmpid];
    //不够一个字节凑0
    if(hexStr.length == 1){
        return [NSString stringWithFormat:@"0%@",hexStr];
    }
    return hexStr;
}

/**
 二进制转换为十进制
  
 @param binary 二进制数
 @return 十进制数
 */
+ (NSInteger)getDecimalByBinary:(NSString *)binary {
    
    NSInteger decimal = 0;
    for (int i=0; i<binary.length; i++) {
        
        NSString *number = [binary substringWithRange:NSMakeRange(binary.length - i - 1, 1)];
        if ([number isEqualToString:@"1"]) {
            
            decimal += pow(2, i);
        }
    }
    return decimal;
}

/**
 十进制转换为二进制
  
 @param decimal 十进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByDecimal:(NSInteger)decimal {
    
    NSString *binary = @"";
    while (decimal) {
        
        binary = [[NSString stringWithFormat:@"%ld", decimal % 2] stringByAppendingString:binary];
        if (decimal / 2 < 1) {
            
            break;
        }
        decimal = decimal / 2 ;
    }
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    return binary;
}

/**
 二进制转换成十六进制
   
 @param binary 二进制数
 @return 十六进制数
 */
+ (NSString *)getHexByBinary:(NSString *)binary {
    
    NSMutableDictionary *binaryDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [binaryDic setObject:@"0" forKey:@"0000"];
    [binaryDic setObject:@"1" forKey:@"0001"];
    [binaryDic setObject:@"2" forKey:@"0010"];
    [binaryDic setObject:@"3" forKey:@"0011"];
    [binaryDic setObject:@"4" forKey:@"0100"];
    [binaryDic setObject:@"5" forKey:@"0101"];
    [binaryDic setObject:@"6" forKey:@"0110"];
    [binaryDic setObject:@"7" forKey:@"0111"];
    [binaryDic setObject:@"8" forKey:@"1000"];
    [binaryDic setObject:@"9" forKey:@"1001"];
    [binaryDic setObject:@"A" forKey:@"1010"];
    [binaryDic setObject:@"B" forKey:@"1011"];
    [binaryDic setObject:@"C" forKey:@"1100"];
    [binaryDic setObject:@"D" forKey:@"1101"];
    [binaryDic setObject:@"E" forKey:@"1110"];
    [binaryDic setObject:@"F" forKey:@"1111"];
    
    if (binary.length % 4 != 0) {
        
        NSMutableString *mStr = [[NSMutableString alloc]init];;
        for (int i = 0; i < 4 - binary.length % 4; i++) {
            
            [mStr appendString:@"0"];
        }
        binary = [mStr stringByAppendingString:binary];
    }
    NSString *hex = @"";
    for (int i=0; i<binary.length; i+=4) {
        
        NSString *key = [binary substringWithRange:NSMakeRange(i, 4)];
        NSString *value = [binaryDic objectForKey:key];
        if (value) {
            
            hex = [hex stringByAppendingString:value];
        }
    }
    return hex;
}

/**
 十六进制转换为二进制
   
 @param hex 十六进制数
 @return 二进制数
 */
+ (NSString *)getBinaryByHex:(NSString *)hex {
    
    NSMutableDictionary *hexDic = [[NSMutableDictionary alloc] initWithCapacity:16];
    [hexDic setObject:@"0000" forKey:@"0"];
    [hexDic setObject:@"0001" forKey:@"1"];
    [hexDic setObject:@"0010" forKey:@"2"];
    [hexDic setObject:@"0011" forKey:@"3"];
    [hexDic setObject:@"0100" forKey:@"4"];
    [hexDic setObject:@"0101" forKey:@"5"];
    [hexDic setObject:@"0110" forKey:@"6"];
    [hexDic setObject:@"0111" forKey:@"7"];
    [hexDic setObject:@"1000" forKey:@"8"];
    [hexDic setObject:@"1001" forKey:@"9"];
    [hexDic setObject:@"1010" forKey:@"A"];
    [hexDic setObject:@"1011" forKey:@"B"];
    [hexDic setObject:@"1100" forKey:@"C"];
    [hexDic setObject:@"1101" forKey:@"D"];
    [hexDic setObject:@"1110" forKey:@"E"];
    [hexDic setObject:@"1111" forKey:@"F"];
    
    NSString *binary = @"";
    for (int i=0; i<[hex length]; i++) {
        
        NSString *key = [hex substringWithRange:NSMakeRange(i, 1)];
        NSString *value = [hexDic objectForKey:key.uppercaseString];
        if (value) {
            
            binary = [binary stringByAppendingString:value];
        }
    }
    return binary;
}

// 将十进制转十六进制、不足4位补足4位
+ (NSString *)stringTo4Lenght16Hex:(long long int)hex {
    NSString *str = @"";
    str = [str ToHex:hex];
    if (str.length == 0 || str.length > 4) return @"";
    for (int i = (int)str.length; i < 4; i++) {
        str = [NSString stringWithFormat:@"0%@",str];
    }
    return str;
}

- (void)call{
    if ([BSCommonDevice isSimulator]) {
        NSLog(@"模拟器无法拨打电话");
        return;
    }
//不会弹出提示
//    NSString *str = [NSString stringWithFormat:@"tel:%@",self];
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    //弹出提示
    NSString * phone = [NSString stringWithFormat:@"telprompt://%@",self];
    NSURL *phoneURL = [NSURL URLWithString:phone];
    if (![[UIApplication sharedApplication] canOpenURL:phoneURL]) {
        return;
    }
    if (@available(iOS 10, *)) {
        [[UIApplication sharedApplication] openURL:phoneURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly: @(NO)} completionHandler:nil];
    } else {
//        [[UIApplication sharedApplication] openURL:phoneURL];
    }
}


- (NSAttributedString *)setDeleteModelWithTextColor:(UIColor *)color font:(UIFont *)font
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSDictionary *dict = @{
        NSFontAttributeName:font,
        NSForegroundColorAttributeName:color,
        NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),
        NSStrikethroughColorAttributeName:color
    };
    [attributedString addAttributes:dict range:NSMakeRange(0, self.length)];
    return attributedString;
}


+ (NSString *)bs_priceShowTwoPointStr:(double)price {
    NSString *priceStr = [NSString stringWithFormat:@"￥%.2f",price] ;
    return priceStr;
    
}

+ (NSString *)validNumberStringWith:(id)number
{
    if (!number) return @"";
    NSString *value = [NSString stringWithFormat:@"%@",number];
    double valueNumber = [value doubleValue];
    value = [NSString stringWithFormat:@"%.2f",valueNumber];
    
//    if ([[value substringWithRange:NSMakeRange(value.length-2, 2)] isEqual:@"00"])
//    {
//        value = [NSString stringWithFormat:@"%.0f",valueNumber];
//    }
//    else if ([[value substringWithRange:NSMakeRange(value.length-1, 1)] isEqual:@"0"])
//    {
//        value = [NSString stringWithFormat:@"%.1f",valueNumber];
//    }
    return value;
}

+ (NSString *)bs_validNumberStringWith:(double)number{
    
//   NSString *price = [NSString validNumberStringWith:number] ;
    
  NSString *priceStr = [NSString stringWithFormat:@"￥%@",[NSString validNumberStringWith:@(number)]] ;
    return priceStr;
}

+ (NSMutableAttributedString *)priceWithNum:(double)number tFont:(UIFont *)font tColor:(UIColor *)color cFont:(UIFont *)cellFont cColor:(UIColor *)cellColor
{
    NSMutableAttributedString *priceMutAttributeString = [[NSMutableAttributedString alloc] init];
    NSString *cellStr = @"¥";
    NSMutableAttributedString *cell = [[NSMutableAttributedString alloc] initWithString:cellStr];
    NSDictionary *cellAttriDict = @{
        NSFontAttributeName:cellFont,
        NSForegroundColorAttributeName:cellColor,
    };
    [cell addAttributes:cellAttriDict range:NSMakeRange(0, cellStr.length)];
    [priceMutAttributeString appendAttributedString:cell];
    
    NSString *priceStr = [NSString stringWithFormat:@"%.2f",number];
    NSMutableAttributedString *priceValue = [[NSMutableAttributedString alloc] initWithString:priceStr];
    NSDictionary *valueAttriDict = @{
        NSFontAttributeName:font,
        NSForegroundColorAttributeName:color,
    };
    [priceValue addAttributes:valueAttriDict range:NSMakeRange(0, priceStr.length)];
    [priceMutAttributeString appendAttributedString:priceValue];
    return priceMutAttributeString;
}

+ (NSString *)removeInvalidNumberWithData:(id)number
{
    if (!number) return @"";
    NSString *value = [NSString stringWithFormat:@"%@",number];
    double valueNumber = [value doubleValue];
    value = [NSString stringWithFormat:@"%.2f",valueNumber];
    
    if ([[value substringWithRange:NSMakeRange(value.length-2, 2)] isEqual:@"00"])
    {
        value = [NSString stringWithFormat:@"%.0f",valueNumber];
    }
    else if ([[value substringWithRange:NSMakeRange(value.length-1, 1)] isEqual:@"0"])
    {
        value = [NSString stringWithFormat:@"%.1f",valueNumber];
    }
    return value;
}


+ (BOOL )bs_isMobileNumber:(NSString *)mobileNum {
    
    if (mobileNum.length != 11){
        return NO;
    }
    //  默认 1开头 第2位为 3-9 的11位数
    NSString * MOBILE = @"^1([3-9])\\d{9}$";
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    if ([regextestcu evaluateWithObject:mobileNum] == YES){
        return YES;
    } else {
        return NO;
    }
}

//  是否是邮箱注册
+ (BOOL )bs_isEmailWithAccount:(NSString *)account {
    return [account containsString:@"@"];
}

- (BOOL)isValidNumber{
    if (!self || self.length <= 0) {
        return NO;
    }
    NSScanner*scan = [NSScanner scannerWithString:self];
    NSDecimal val;
    return [scan scanDecimal:&val] && [scan isAtEnd];

}

/// 判断是否含有非法字符  yes 有  no没有
- (BOOL)isJudgeTheillegalCharacter{
    //提示 标签不能输入特殊字符
    // （字母 数字  汉字  空格符 ） 其他为特殊字符
      NSString *str =@"^[A-Za-z0-9 \\u4e00-\u9fa5]+$";
      NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
      if (![emailTest evaluateWithObject:self]) {
          return YES;
      }
      return NO;
}

/// 判断是否只有数字和字母方法
- (BOOL)isJudgeOnlyNumbersAndLetters
{
    NSString *str =@"^[A-Za-z0-9]+$";
    NSPredicate* emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", str];
    if ([emailTest evaluateWithObject:self]) {
        return YES;
    }
    return NO;
}


//  隐藏手机号码中间的四位数字  打码
- (NSString *)bs_HidingPhoneNumber{
    if (self.length<=7) {
        return self;
    }
    NSString *numberString = [self stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    return numberString;
}


- (NSString *)bs_hiddenEmailNum
{
    NSString *symbolStr = @"******************";
    NSString * lastStr =  @"@";//截取符
    NSRange rangeLenth = [self rangeOfString:lastStr];
    //开始
    NSRange rangeBegin = NSMakeRange(0, 2);
    NSString *beginStr = [self substringWithRange:rangeBegin];
    
    //隐藏部分
    NSRange rangeHidden = NSMakeRange(2, rangeLenth.location - 4);
    NSString * hiddenStr = [self substringWithRange:rangeHidden];
    
    //替换隐藏部分
    NSRange rangSymbol = NSMakeRange(0, hiddenStr.length);
    NSString *newHiddenStr = [symbolStr substringWithRange:rangSymbol];
    
    //结尾
    NSRange rangeEnd = NSMakeRange(rangeLenth.location - 2, self.length - rangeLenth.location + 2);
    NSString *endStr = [self substringWithRange:rangeEnd];
    
    NSString * newStr = [NSString stringWithFormat:@"%@%@%@",beginStr,newHiddenStr,endStr];
    
    return newStr;
}

- (NSString *)replaceUnicode{
    NSString *tempStr = [self stringByReplacingOccurrencesOfString:@"\\u" withString:@"\\U"];
    tempStr = [tempStr stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
    tempStr = [[@"\"" stringByAppendingString:tempStr]stringByAppendingString:@"\""];
    NSData *tempData = [tempStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSString *returnStr = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:&error];
    return !error ? [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n" withString:@"\n"] : nil;
}

//ASCII码0.5长度 中文1长度
- (CGFloat)bs_length{
    CGFloat n = [self length];
    int l = 0;
    int a = 0;
    int b = 0;
    CGFloat wLen = 0;
    unichar c;
    for(int i = 0; i < n; i++){
        c = [self characterAtIndex:i];//按顺序取出单个字符
        if(isblank(c)){//判断字符串为空或为空格
            b++;
        }else if(isascii(c)){
            a++;
        }else{
            l++;
        }
        wLen = l+(CGFloat)((CGFloat)(a+b)/2.0);
    }
    if(a == 0 && l == 0){
        return 0;//只有isblank
    }
    return wLen;//长度，中文占1，英文等能转ascii的占0.5
}

+ (NSString *)randomStringWithLength:(int)length{
    //随机字符表
    NSString *randomAlphabet = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    return [self randomStringWithLength:length letters:randomAlphabet];
}

+ (NSString *)randomStringWithLength:(int)length letters:(NSString *)letters{
    uint32_t totalLength = (uint32_t)[letters length];
    NSAssert(totalLength > 0, @"letters 长度必须大于 0");
    NSAssert(length > 0, @"length 必须大于 0");
    NSMutableString *randomString = [NSMutableString stringWithCapacity:length];
    for (int i = 0; i < length; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex:arc4random_uniform(totalLength)]];
    }
    return randomString.copy;
}

- (NSAttributedString *)strikethroughStyle{
    if(!self.isEnable) return nil;
    return [[NSAttributedString alloc] initWithString:self attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}].copy;
}

- (BOOL)isMatchRegex:(NSString *)regex{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [predicate evaluateWithObject:self];
}

- (BOOL)isNumberGreaterThanZero{
    if(![self isEnable]) { return NO; }
    NSError *error = nil;
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:@"[1-9]" options:NSRegularExpressionCaseInsensitive error:&error];
    NSInteger count = [regular numberOfMatchesInString:self options:NSMatchingReportProgress range:NSMakeRange(0, self.length)];
    return count > 0;
}

- (NSData *)byteData4NumberString{
    if(![self isValidNumber]){ return nil; }
    NSMutableString *hexString = [NSMutableString stringWithString:@""];
    for(NSUInteger i = 0 ; i < self.length; i++){
        NSString *num = [NSString stringWithFormat:@"%C",[self characterAtIndex:i]];
        [hexString appendString:[num toHex]];
    }
    return [hexString convertBytesStringToData];
}

#pragma mark - HmacSHA1加密；
+ (NSString *)HmacSha1:(NSString *)key data:(NSString *)data
{
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    //Sha256:
    // unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    //CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    NSString *hash = [HMAC base64EncodedStringWithOptions:0];//将加密结果进行一次BASE64编码。
    return hash;
}

#pragma mark - sha1 哈希算法
+ (NSString *)sha1:(NSString *)inputString{
    NSData *data = [inputString dataUsingEncoding:NSUTF8StringEncoding];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes,(unsigned int)data.length,digest);
    NSMutableString *outputString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
    
    for (int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [outputString appendFormat:@"%02x",digest[i]];
    }
    return [outputString lowercaseString];
}

// 当使用 “stringByAddingPercentEncodingWithAllowedCharacters:NSCharacterSet.URLPathAllowedCharacterSet”
// 还不能完全转译的时候就需要使用以下方法去转编译
- (NSString *)urlEncode {
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
            [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

/// 截取部分范围
- (NSString*)substring:(NSString*)originalString range:(NSRange)range {
    // 使用substringWithRange:方法截取部分范围
    NSString *extractedString = [originalString substringWithRange:range];
    return extractedString;
}

- (nullable NSDictionary *)toJson{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
    if (error) {
        NSLog(@"NSJSONSerialization error:%@", error.localizedDescription);
    }
    if (!jsonObj || ![jsonObj isKindOfClass:NSDictionary.class]) { return nil; }
    return jsonObj;
}
- (nullable NSArray<NSDictionary *> *)toJsonArr{
    NSData *data = [self dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    id jsonObj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingFragmentsAllowed error:&error];
    if (error) {
        NSLog(@"NSJSONSerialization error:%@", error.localizedDescription);
    }
    if (!jsonObj || ![jsonObj isKindOfClass:NSArray.class]) { return nil; }
    return jsonObj;
}

@end
