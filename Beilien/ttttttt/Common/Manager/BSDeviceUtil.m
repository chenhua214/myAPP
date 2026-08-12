//
//  ZLJDeviceUtil.m
//  BaseusAPP
//
//

#import "BSDeviceUtil.h"
#import <sys/utsname.h>
#import <AdSupport/AdSupport.h>

// 中文判断条件
#define k_Base @"Base"
#define k_zh_Hant @"zh-Hant"
#define k_zh_Hans @"zh-Hans"
#define k_Han @"Han"
#define k_en @"en"
#define k_en_US @"en_US"

// BSLanguageMode.json 中 keys
#define k_key @"key"
#define k_detail @"detail"
#define k_language @"language"
#define k_translation @"translation"
#define k_desc @"desc"


@interface BSDeviceUtil()
/// 语言码
@property (nonatomic, copy) NSString *currentLanguageCode;
/// 服务器使用的语言语种
@property (nonatomic, copy) NSString *currentLanguageUseText;
/// 使用的语言语种
@property (nonatomic, copy) NSString *currentLanguageText;

@end

@implementation BSDeviceUtil


+ (instancetype)shareInstance {
    static BSDeviceUtil *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}


+ (id)allocWithZone:(struct _NSZone *)zone {
    return [BSDeviceUtil shareInstance];
}


- (id)copyWithZone:(struct _NSZone *)zone {
    return [BSDeviceUtil shareInstance];
}


/// 设备型号
+ (NSString*)iphoneType
{
    return [self machineName];
}

+ (NSString *)machineName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *platform = [NSString stringWithCString: systemInfo.machine encoding:NSASCIIStringEncoding];
    return platform;
}

+ (BOOL)isSimulator
{
    return (TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1);
}

/// 更新当前使用的语种
+ (void)updateLanguage:(NSString *)language
{
    if (![language isKindOfClass:[NSString class]] || language.length == 0) return;
    [self shareInstance].currentLanguageCode = language;
    [[NSUserDefaults standardUserDefaults] setObject:@[language] forKey:kAppleLanguages];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/// 获取当前系统语言
+(NSString *)getCurrentLanguage
{
    NSString *currentLanguage = [self shareInstance].currentLanguageCode;
    if ([currentLanguage isKindOfClass:[NSString class]] && currentLanguage.length > 0) return currentLanguage;
    
#if 0
    NSArray *languages = [NSLocale preferredLanguages];
    if (!languages || languages.count == 0) return nil;
    NSString *currentLanguage = [languages objectAtIndex:0];
    return currentLanguage;
#else
    /** [NSLocale preferredLanguages] 和 [NSBundle mainBundle].preferredLocalizations 的区别
     *
     *  这两种方法获取的值略有不同，主要体现在以下几个方面：
     *
     *  NSBundle.mainBundle.preferredLocalizations:
     *
     *    * 这个属性返回的是当前应用程序包（main bundle）中所支持的首选本地化语言列表。
     *    * 主要用于获取应用程序在运行时支持的本地化语言集合，通常是在项目的本地化设置中配置的语言列表。
     *
     *  Locale.preferredLanguages:
     *
     *    * 这个方法返回的是设备当前设置的语言偏好列表，按优先级排列。
     *    * 这个列表不仅包括了应用程序所支持的本地化语言，还包括了设备上用户可能设置的所有语言偏好，按用户的首选顺序排列。
     *
     *  区别总结：
     *
     *    * NSBundle.mainBundle.preferredLocalizations 返回的是应用程序支持的本地化语言列表，受应用程序配置影响。
     *    * Locale.preferredLanguages 返回的是设备上用户设置的语言偏好列表，不受应用程序配置的限制，反映了用户的语言偏好设置。
     *
     *  因此，如果你需要了解用户当前设备的语言偏好，或者需要根据用户的首选语言来调整应用程序的显示语言，通常使用 Locale.preferredLanguages 更为合适。
     *  而 NSBundle.mainBundle.preferredLocalizations则更适合用来获取应用程序当前支持的本地化语言列表，以便在应用程序中进行本地化处理。
     */
    
    NSArray *localeLanguages = [NSLocale preferredLanguages];
    NSLog(@"1.用户在“语言和地区”中自定义添加的偏好语言语种: %@",localeLanguages);
    // "zh-Hans-CN", "id-CN", "en-CN","vi-CN","ja-CN","zh-Hant-MO","zh-Hant-TW","ru-CN","ko-CN",
    // "yue-Hant-CN","de-CN","es-CN","fr-CN","th-CN","it-CN","pl-CN","el-CN","yue-Hans-CN","my-CN"
    
    NSArray *custormLanguages = [[NSUserDefaults standardUserDefaults] objectForKey:kAppleLanguages];
    NSLog(@"2.数组中的元素按照用户在设备设置中指定的语言偏好顺序排列，第一个元素是用户的首选语言: %@",custormLanguages);
    // "zh-Hans-CN", "id-CN", "en-CN", "vi-CN", "ja-CN", "zh-Hant-MO", "zh-Hant-TW", "ru-CN", "ko-CN",
    // "yue-Hant-CN", "de-CN", "es-CN", "fr-CN", "th-CN", "it-CN", "pl-CN", "el-CN", "yue-Hans-CN", "my-CN"
    
    NSArray *localizations = [self bundleLocalizations];
    NSLog(@"3.应用程序所支持的语种: %@",localizations);
    // "en", "de", "ja", "en", "zh-Hant", "es", "Base", "zh-Hans", "it", "ko", "pl", "ru", "fr", "th"
    
    NSArray *currentLanguages = [self bundlePreferredLocalizations];
    NSLog(@"4.当前应用程序包（main bundle）中所支持的首选本地化语言: %@",currentLanguages);
    // "zh-Hans"
    
    currentLanguage = [currentLanguages firstObject];
    if ([currentLanguage containsString:k_Han]) currentLanguage = k_zh_Hans; // 繁体中文也使用简体中文
    if ([currentLanguage containsString:k_Base]) currentLanguage = k_en;
    
    NSLog(@"5.当前使用的语言：%@",currentLanguage);
    [self shareInstance].currentLanguageCode = currentLanguage;
    
    return currentLanguage;
    
#endif
}

/// 设置语言
- (void)setCurrentLanguageCode:(NSString *)currentLanguageCode 
{
    _currentLanguageCode = currentLanguageCode;
    
    NSArray *array = self.languagesArray;
    for (NSDictionary *dict in array) {
        NSString *key = [dict objectForKey:k_key];
        if ([currentLanguageCode isEqualToString:key]) {
            self.currentLanguageUseText = [dict objectForKey:k_detail];
            self.currentLanguageText = [dict objectForKey:k_translation];
            break;
        }
    }
}


/// 获取当前系统语言转成服务器识别语种
+(NSString *)getCurrentLanguageStr
{
    return [self shareInstance].currentLanguageUseText ?: k_en_US;
}

/// 当前使用的APP语言
+ (NSString *)appCurrentLanguage
{
    return [self shareInstance].currentLanguageText;
}


/// 获取当前应用程序所支持的语种
+ (NSArray *)getSurpportLanguages
{
    NSArray *localizations = [self bundleLocalizations];
    NSMutableSet *tempSet = [NSMutableSet setWithArray:localizations];
    if ([tempSet containsObject:k_Base]) [tempSet removeObject:k_Base];
    if ([tempSet containsObject:k_zh_Hant]) [tempSet removeObject:k_zh_Hant];
    localizations = [tempSet allObjects];
    
    NSMutableArray *array = [NSMutableArray array];
    NSArray *languagesArray = [self shareInstance].languagesArray;
    for (NSDictionary *dict in languagesArray) {
        NSString *key = [dict objectForKey:k_key];
        if ([localizations containsObject:key]) {
            [array addObject:dict];
        }
    }
    return array;
}

/// 应用程序所支持的语种
+ (NSArray *)bundleLocalizations {
    return [NSBundle mainBundle].localizations;
}

/// 当前应用程序包（main bundle）中所支持的首选本地化语言
+ (NSArray *)bundlePreferredLocalizations {
    return [NSBundle mainBundle].preferredLocalizations;
}

/// 当前语言是否是英文
+ (BOOL)isEnglishLanguage
{
    NSString *languageStr = [self getCurrentLanguage];
    return ![languageStr containsString:k_Han];
}


- (NSArray *)languagesArray {
    if (!_languagesArray) {
        NSArray *array = @[];
        NSString *path = [[NSBundle mainBundle] pathForResource:@"BSLanguageMode" ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data == nil || data.length <=0) return array;
        NSError *error;
        array = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
        if (error) return array;
        _languagesArray = array;
    }
    return _languagesArray;
}

@end
