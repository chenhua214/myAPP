//
//  BSAroModeDBHelper.m
// 
//
//  Created by chen on 2022/9/14.
//  Copyright
//

#import "BSAroModeDBHelper.h"
//#import "BSAroModelModel.h"
#import "BSCommonDevice.h"

@implementation BSAroModeDBHelper

+ (void)aroModesWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback{
    if(!model.isEnable || !sn.isEnable ){
        NSLog(@"参数异常,请确认");
        return;
    }
    return;
//    NSDictionary *where = @{@"model":model,@"sn":sn};
//    [self search:BSAroModeDBModel.class where:where orderBy:nil callback:callback];
}

+ (void)updateAroMode:(BSAroModeDBModel *)model callback:(nullable operationBlock)callback{
//    [self executeOperation:BSDataOperationUpdate model:model callback:callback];
}

/// 移除香薰模式
+ (void)deleteAroModeWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback{
    if(!model.isEnable || ![self enabledForModel:model] || !sn.isEnable){
        return;
    }
    return;
//    BSAroModeDBModel *dbModel = [BSAroModeDBModel new];
//    dbModel.model = model;
//    dbModel.sn = sn;
//    [self executeOperation:BSDataOperationDelete model:dbModel callback:callback];
}

+ (BOOL)enabledForModel:(NSString *)model{
    return NO;
//    BSDeviceSubType subType = [BSCommonDevice deviceSubTypeWithModel:model];
//    return ( subType == BSDeviceSubTypeSmartAromatherapy || subType == BSDeviceSubTypeSmartAromatherapyS );
}

@end
