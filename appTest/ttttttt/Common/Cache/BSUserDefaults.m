//
//  BSUserDefaults.m
//  JDKJAPP
//
//  Created by  on 2026/1/13.
//

#import "BSUserDefaults.h"

@implementation BSUserDefaults

+ (void)setObject:(nullable id)object forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setObject:object forKey:defaultName];
    [self synchronize];
}

+ (id)objectForKey:(nonnull NSString *)key{
    return [[self standardUserDefaults] objectForKey:key];
}

+ (void)setCustomObject:(nullable NSObject *)object forKey:(NSString *)defaultName{
    [self setObject:object ? [object yy_modelToJSONObject] : nil forKey:defaultName];
}

+ (id)customObjectForKey:(nonnull NSString *)key className:(NSString *)className{
    NSDictionary *dict = [self objectForKey:key];
    if(!dict || ![dict isKindOfClass:NSDictionary.class]){ return nil; }
    return [NSClassFromString(className) yy_modelWithDictionary:dict];
}

/// 自定义的数据类型数组
+ (nullable id)customObjectArrayForKey:(NSString *)key className:(NSString *)className{
    NSArray *jsonArr = [self objectForKey:key];
    if(!jsonArr || ![jsonArr isKindOfClass:NSArray.class]){ return nil; }
    return [NSArray yy_modelArrayWithClass:NSClassFromString(className) json:jsonArr];
}

+ (void)removeObjectForKey:(NSString *)defaultName{
    [[self standardUserDefaults] removeObjectForKey:defaultName];
}

+ (nullable NSString *)stringForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] stringForKey:defaultName];
}

+ (nullable NSArray *)arrayForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] arrayForKey:defaultName];
}

+ (nullable NSDictionary<NSString *, id> *)dictionaryForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] dictionaryForKey:defaultName];
}

+ (nullable NSData *)dataForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] dataForKey:defaultName];
}

+ (nullable NSArray<NSString *> *)stringArrayForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] stringArrayForKey:defaultName];
}

+ (NSInteger)integerForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] integerForKey:defaultName];
}

+ (float)floatForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] floatForKey:defaultName];
}

+ (double)doubleForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] doubleForKey:defaultName];
}

+ (BOOL)boolForKey:(NSString *)defaultName{
    return [[self standardUserDefaults] boolForKey:defaultName];
}

+ (nullable NSURL *)URLForKey:(NSString *)defaultName{
    if (@available(iOS 4.0, *)) {
        return [[self standardUserDefaults] URLForKey:defaultName];
    }
    return nil;
}

+ (void)setInteger:(NSInteger)value forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setInteger:value forKey:defaultName];
    [self synchronize];
}

+ (void)setFloat:(float)value forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setFloat:value forKey:defaultName];
    [self synchronize];
}

+ (void)setDouble:(double)value forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setDouble:value forKey:defaultName];
    [self synchronize];
}

+ (void)setBool:(BOOL)value forKey:(NSString *)defaultName{
    [[self standardUserDefaults] setBool:value forKey:defaultName];
    [self synchronize];
}

+ (void)setURL:(nullable NSURL *)url forKey:(NSString *)defaultName{
    if (@available(iOS 4.0, *)) {
        [[NSUserDefaults standardUserDefaults] setURL:url forKey:defaultName];
        [self synchronize];
    }
}

+ (NSUserDefaults *)standardUserDefaults{
    return [NSUserDefaults standardUserDefaults];
}

+ (BOOL)synchronize{
    NSUserDefaults *standardUserDefaults = [self standardUserDefaults];
    if ([standardUserDefaults respondsToSelector:@selector(synchronize)]) {
        [standardUserDefaults synchronize];
    }
    return YES;
}

@end
