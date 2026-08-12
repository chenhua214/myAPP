//
//  BSGuestModeHelper.h
//
//
//  Created by chen on 2022/9/12.
//  Copyright
//

#import <Foundation/Foundation.h>

typedef void(^operationBlock) (BOOL result, id _Nullable responseData);

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BSDataOperation) {
    BSDataOperationInsert,//增
    BSDataOperationDelete,//删
    BSDataOperationUpdate,//改
    BSDataOperationSelect,//查
};

@interface BSGuestModeHelper : NSObject

#pragma mark - Guest mode

/// 访客账户
+ (NSString *)guestAccount;

/// 当前有效账号
+ (NSString *)validAccount;

/// 切换使用模式
/// @param mode 使用模式
/// @param callback 回调
+ (void)switchUsageMode:(BSUsageMode)mode callback:(void(^)(void))callback;

/// 当前所处的模式
+ (BSUsageMode)usageMode;

/// 是否是访客模式
+ (BOOL)isGuestMode;

/// 显示访客模式视图
+ (BOOL)showGuestModeAlertViewForVC:(UIViewController *)viewController;
/// 显示蓝牙开启权限
+ (BOOL)showBluetoothAlertViewForVC:(UIViewController *)viewController;
#pragma mark - LKDBHelper

/// 查询数据
/// - Parameters:
///   - modelClass: 数据类
///   - where: 条件键值对
///   - orderBy: 排序(如: id asc 或 id desc )
///   - callback: 回调
+ (void)search:(Class)modelClass where:(nullable NSDictionary *)where orderBy:(nullable NSString *)orderBy callback:(nullable operationBlock)callback;

/// 插入一组数据至数据库
+ (void)insertToDBWithObject:(NSObject *)model callback:(nullable operationBlock)callback;

/// 插入多组数据至数据库
+ (void)insertArrayByAsyncToDB:(NSArray *)models callback:(nullable operationBlock)callback;

/// 更新数据
/// - Parameters:
///   - modelClass: 数据类
///   - setParams: 需要更新的数据键值对
///   - where: 条件键值对
///   - callback: 回调
+ (void)updateToDB:(Class)modelClass setParams:(NSDictionary *)setParams whereParam:(NSDictionary *)where callback:(nullable operationBlock)callback;

/// 更新数据
/// - Parameters:
///   - modelClass: 数据类
///   - sets: 设置语句如 (@"key1 = 'value1', key2 = 'value2'")
///   - where: 条件键值对
///   - callback: 回调
+ (void)updateToDB:(Class)modelClass set:(NSString *)sets where:(NSDictionary *)where callback:(nullable operationBlock)callback;

///根据params 生成 set 字符串
+ (nullable NSString *)stringWithParams:(NSDictionary *)params;

///执行新增/删除/修改的功能,查询请使用 search: where: orderBy: callback: 方法
+ (void)executeOperation:(BSDataOperation)operation model:(NSObject *)model callback:(nullable operationBlock)callback;

/// 回调方法
/// - Parameters:
///   - result: YES/NO
///   - callback: 回调
+ (void)callbackWithResult:(BOOL)result callback:(nullable operationBlock)callback;

/// 回调方法
/// - Parameters:
///   - result: YES/NO
///   - responseData: 回调数据
///   - callback: 回调
+ (void)callbackWithResult:(BOOL)result responseData:(id _Nullable)responseData callback:(nullable operationBlock)callback;

@end

NS_ASSUME_NONNULL_END
