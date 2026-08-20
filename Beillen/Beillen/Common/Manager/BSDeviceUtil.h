//
//  ZLJDeviceUtil.h
//  Beillen
//
//

#import <Foundation/Foundation.h>

#define kAppleLanguages @"AppleLanguages"
#define k_zh_Han @"zh-Han"

@interface BSDeviceUtil : NSObject

@property (nonatomic, strong) NSArray *languagesArray;

+ (instancetype)shareInstance;

/// 设备型号
+ (NSString *)iphoneType;
/// 设备型号
+ (NSString *)machineName;
/// 是否模拟器
+ (BOOL)isSimulator;

/// 获取当前系统语言
+(NSString *)getCurrentLanguage;
+(NSString *)getCurrentLanguageStr;

/// 当前语言是否是英文
+ (BOOL)isEnglishLanguage;
/// 更新当前使用的语种
+ (void)updateLanguage:(NSString *)language;
/// 获取当前应用程序所支持的语种
+ (NSArray *)getSurpportLanguages;
/// 当前使用的APP语言
+ (NSString *)appCurrentLanguage;

@end
