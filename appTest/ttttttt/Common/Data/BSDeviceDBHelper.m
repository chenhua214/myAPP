//
//  BSDeviceDBHelper.m
//
//
//  Created by chen on 2022/9/14.

//

#import "BSDeviceDBHelper.h"
#import "BSHomeModel.h"
#import "BSAroModeDBHelper.h"

@implementation BSDeviceDBHelper

+ (void)deleteDeviceWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback{
    if(!model.isEnable || !sn.isEnable){
        NSLog(@"参数异常,请确认");
        return;
    }
    BSHomeDeviceModel *device = [BSHomeDeviceModel new];
    device.model = model;
    device.sn = device.identifier = sn;
    [self executeOperation:BSDataOperationDelete model:device callback:callback];
    ///移除香薰数据
    [BSAroModeDBHelper deleteAroModeWithModel:model sn:sn callback:callback];
}

+ (void)updateDevice:(nullable BSHomeDeviceModel *)model callback:(nullable nullable operationBlock)callback{
    [self updateDeviceWithParams:nil device:model callback:callback];
}

+ (void)updateDeviceWithParams:(NSDictionary *)params model:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback{
    BSHomeDeviceModel *device = [BSHomeDeviceModel new];
    if (model.isEnable) { device.model = model; }
    if (sn.isEnable) { device.sn = device.identifier = sn; }
    [self updateDeviceWithParams:params device:device callback:callback];
}

+ (void)allDevicesWithCallback:(nullable operationBlock)callback{
    [self deviceWithModel:nil sn:nil callback:callback];
}

+ (void)deviceWithModel:(NSString *)model sn:(NSString *)sn callback:(nullable operationBlock)callback{
    BSHomeDeviceModel *device = nil;
    BOOL validModel = model.isEnable;
    BOOL validSN = sn.isEnable;
    if(validModel || validSN ){
        device = [BSHomeDeviceModel new];
    }
    if (validModel) { device.model = model; }
    if (validSN) { device.sn = device.identifier = sn; }
    [self devicesWithDevice:device callback:callback];
}

+ (void)devicesWithDevice:(nullable BSHomeDeviceModel *)model callback:(nullable operationBlock)callback{
    NSMutableDictionary *where = nil;
    NSString *orderBy = @"bindTime desc";
    if (model) {
        where = [NSMutableDictionary dictionary];
        [where setValue:model.model forKey:@"model"];
        [where setValue:model.identifier ?: model.sn forKey:@"identifier"];
    }
    [self search:BSHomeDeviceModel.class where:where orderBy:orderBy callback:callback];
}

+ (void)updateDeviceWithParams:(NSDictionary *)params device:(BSHomeDeviceModel *)model callback:(nullable operationBlock)callback{
    if(!model || !model.model.isEnable){
        NSLog(@"参数 model 不正确,请确认");
        return;
    }
    NSString *set = [self stringWithParams:params];
    if(set.isEnable){
        NSMutableDictionary *where = [NSMutableDictionary dictionary];
        [where setValue:model.model forKey:@"model"];
        [where setValue:model.identifier ?: model.sn forKey:@"identifier"];
        NSLog(@"set: %@ where %@",set,where);
        [self updateToDB:model.class set:set where:where callback:callback];
        return;
    }
    if(!model.sn.isEnable || !model.identifier.isEnable){
        //需要传入sn 或 identifier
        NSLog(@"sn/identifier 需要传入");
        return;
    }
    [self executeOperation:BSDataOperationUpdate model:model callback:callback];
}

@end
