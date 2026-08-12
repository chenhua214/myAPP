//
//  BSGuestModeHelper.m
//
//
//  Created by  on 2022/9/12.
//  Copyright ©
//

#import "BSGuestModeHelper.h"
//#import "BSCustomAlertView.h"
#import "BSHomeModel.h"
#import "LKDBHelper.h"
#import "BSBLEManager.h"
@implementation BSGuestModeHelper

#pragma mark - Guest mode

+ (NSString *)guestAccount{
    if (IS_GUEST_MODE) {
        return [BSConfigManager sharedInstance].guestAccount;
    }
    return nil;
}

+ (NSString *)validAccount{
    NSString *guestAcount = [self guestAccount];
    return guestAcount ?:[BSConfigManager sharedInstance].account;
}

+ (void)switchUsageMode:(BSUsageMode)mode callback:(void(^)(void))callback{
    [BSConfigManager switchUsageMode:mode callback:callback];
}

/// 当前所处的模式
+ (BSUsageMode)usageMode{
    return [BSConfigManager usageMode];
}

/// 是否是访客模式
+ (BOOL)isGuestMode{
    return [BSConfigManager isGuestMode];
}

/// 显示访客模式视图
+ (BOOL)showGuestModeAlertViewForVC:(UIViewController *)viewController{
    if (![self isGuestMode]) {
        return NO;
    }
//    [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"str_visitor_title")
//                          subMessage:nil
//                           cancelTxt:NSLocalizedStringkey(@"str_cancel")
//                           actionTxt:NSLocalizedStringkey(@"login_btn")
//                              handle:^(BSAlertMessageAction action, id object) {
//        if (action == BSAlertMessageActionEvents) {
//            [BSLoginThirdController loginWithVC:viewController];
//        }
//    }];
    return YES;
}

/// 显示蓝牙开启权限
+ (BOOL)showBluetoothAlertViewForVC:(UIViewController *)viewController{
    if ([[BSBLEManager shareInstance] isBlePowerOn]) {
        return NO;
    }
    
    
    BOOL yyyyy = [[BSBLEManager shareInstance] isFirstAuthorized];
    if ([[BSBLEManager shareInstance] isFirstAuthorized]) {
        [BSAlertMessageTool updateBgGestureEnable:YES];
        [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"req_permission_tit") subMessage:NSLocalizedStringkey(@"str_open_bluetooth_tip") cancelTxt:NSLocalizedStringkey(@"str_cancel") actionTxt:NSLocalizedStringkey(@"req_nearby_permission_sure") handle:^(BSAlertMessageAction action, id object) {
            if (action == BSAlertMessageActionEvents) {
                NSURL *url = [NSURL URLWithString:@"App-Prefs:root=Bluetooth"];
                if (@available(iOS 10.0, *)) {
                    [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
                } else {
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }];
    }
    return YES;
}



#pragma mark-  LKDBHelper

+ (void)search:(Class)modelClass where:(nullable NSDictionary *)where orderBy:(nullable NSString *)orderBy callback:(nullable operationBlock)callback{
    [[self getUsingLKDBHelper] search:modelClass where:where orderBy:orderBy offset:0 count:0 callback:^(NSMutableArray * _Nullable array) {
        id responseData = (array && array.count > 0) ? array : nil;
        [self callbackWithResult:YES responseData:responseData callback:callback];
    }];
}

+ (void)insertToDBWithObject:(NSObject *)model callback:(nullable operationBlock)callback{
    [self executeOperation:BSDataOperationInsert model:model callback:callback];
}

+ (void)insertArrayByAsyncToDB:(NSArray *)models callback:(nullable operationBlock)callback{
    [self insertArrayByAsyncToDB:models completed:^(BOOL allInserted) {
        [self callbackWithResult:allInserted callback:callback];
    }];
}

+ (void)updateToDB:(Class)modelClass setParams:(NSDictionary *)setParams whereParam:(NSDictionary *)where callback:(nullable operationBlock)callback{
    [self updateToDB:modelClass set:[self stringWithParams:setParams] where:where callback:callback];
}

+ (void)updateToDB:(Class)modelClass set:(NSString *)sets where:(NSDictionary *)where callback:(nullable operationBlock)callback{
    if(!sets.isEnable || !where || where.count == 0){
        NSLog(@"参数异常,请确认");
        return;
    }
    BOOL result = [[self getUsingLKDBHelper] updateToDB:modelClass set:sets where:where];
    [self callbackWithResult:result callback:callback];
}

+ (nullable NSString *)stringWithParams:(NSDictionary *)params{
    if(!params || params.count == 0) return nil;
    NSString *set = nil;
    if(params && params.count > 0){
        NSMutableArray *array = [NSMutableArray array];
        [params enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            [array addObject:[NSString stringWithFormat:@"%@ = '%@'",key,obj]];
        }];
        set = [array componentsJoinedByString:@","];
    }
    return set;
}

+ (void)executeOperation:(BSDataOperation)operation model:(NSObject *)model callback:(nullable operationBlock)callback{
    if (operation == BSDataOperationSelect) {
        NSLog(@"请自行实现 search: where: orderBy: callback: 方法");
        return;
    }
    if(!model){
        [self callbackWithResult:NO callback:callback];
        return;
    }
    if (operation == BSDataOperationInsert) {
        [[self getUsingLKDBHelper] insertToDB:model callback:^(BOOL result) {
            [self callbackWithResult:result callback:callback];
        }];
    }else if (operation == BSDataOperationDelete){
        [[self getUsingLKDBHelper] deleteToDB:model callback:^(BOOL result) {
            [self callbackWithResult:result callback:callback];
        }];
    }else if (operation == BSDataOperationUpdate){
        [[self getUsingLKDBHelper] updateToDB:model where:nil callback:^(BOOL result) {
            [self callbackWithResult:result callback:callback];
        }];
    }
}

+ (void)callbackWithResult:(BOOL)result callback:(nullable operationBlock)callback{
    [self callbackWithResult:result responseData:nil callback:callback];
}

+ (void)callbackWithResult:(BOOL)result responseData:(id _Nullable)responseData callback:(nullable operationBlock)callback{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"数据操作 %@",result ? @"成功" : @"失败");
        if (callback) {
            callback(result,responseData);
        };
    });
}

#pragma mark- Private methods

+ (LKDBHelper *)getUsingLKDBHelper{
    static LKDBHelper *dbHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dbHelper = [[LKDBHelper alloc] initWithDBPath:[self dbPath]];
    });
    return dbHelper;
}

+ (NSString *)dbPath{
    NSString *dir = [@"bs_data_base" stringByAppendingFormat:@"/%@",[BSConfigManager sharedInstance].guestAccount];
    return [LKDBUtils getPathForDocuments:@"BS_Local_Data.db" inDir:dir];
}

+ (void)resetDBPathIfNeeded{
    LKDBHelper *dbHelper = [BSGuestModeHelper getUsingLKDBHelper];
    NSString *dbPath = [dbHelper valueForKey:@"dbPath"];
    NSString *targetDBPath = [self dbPath];
    if (dbPath && [dbPath isEqualToString:targetDBPath]) {
        return;
    }
    [dbHelper setDBPath:targetDBPath];
}

@end
