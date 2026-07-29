//
//  BSUserDefaults.h
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static NSString *const kDefaultDataModelKey = @"homeDataModel";

@interface BSUserDefaults : NSObject
/// NSUserDefaults支持的数据类型
+ (void)setObject:(nullable id)object forKey:(NSString *)defaultName;

/// NSUserDefaults支持的数据类型
+ (nullable id)objectForKey:(NSString *)key;

/// 自定义的数据类型
+ (void)setCustomObject:(nullable NSObject *)object forKey:(NSString *)defaultName;

/// 自定义的数据类型
+ (nullable id)customObjectForKey:(NSString *)key className:(NSString *)className;

/// 自定义的数据类型数组
+ (nullable id)customObjectArrayForKey:(NSString *)key className:(NSString *)className;

+ (void)removeObjectForKey:(NSString *)defaultName;

+ (nullable NSString *)stringForKey:(NSString *)defaultName;

+ (nullable NSArray *)arrayForKey:(NSString *)defaultName;

+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName;

+ (nullable NSData *)dataForKey:(NSString *)defaultName;

+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName;

+ (NSInteger)integerForKey:(NSString *)defaultName;

+ (float)floatForKey:(NSString *)defaultName;

+ (double)doubleForKey:(NSString *)defaultName;

+ (BOOL)boolForKey:(NSString *)defaultName;

+ (nullable NSURL *)URLForKey:(NSString *)defaultName;

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName;

+ (void)setFloat:(float)value forKey:(NSString *)defaultName;

+ (void)setDouble:(double)value forKey:(NSString *)defaultName;

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName;

+ (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName;

@end

NS_ASSUME_NONNULL_END
