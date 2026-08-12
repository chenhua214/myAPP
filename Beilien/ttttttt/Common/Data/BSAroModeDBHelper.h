//
//  BSAroModeDBHelper.h
//
//
//  Created by chen on 2022/9/14.
//  Copyright ©
//

#import "BSGuestModeHelper.h"

NS_ASSUME_NONNULL_BEGIN

@class BSAroModeDBModel;
@interface BSAroModeDBHelper : BSGuestModeHelper

/// 根据model 和sn 获取 本地存储的香薰模式
+ (void)aroModesWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback;

/// 更新香薰模式
+ (void)updateAroMode:(BSAroModeDBModel *)model callback:(nullable operationBlock)callback;

/// 移除香薰模式
+ (void)deleteAroModeWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback;

@end

NS_ASSUME_NONNULL_END
