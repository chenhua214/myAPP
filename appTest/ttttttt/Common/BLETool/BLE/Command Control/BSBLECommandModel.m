//
//  BSBLECommandModel.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSBLECommandModel.h"


@interface BSBLECommandModel()
/// 型号
@property(nonatomic,  copy)NSString *model;
/// mac 地址
@property(nonatomic,  copy)NSString *mac;
/// 类型
@property(nonatomic,assign)BSDeviceType type;
/// 写入指令数据
@property(nonatomic,strong)NSData *data;
/// 响应的协议头数据
@property(nonatomic,strong)NSData *responseHeaderData;
@property(nonatomic,assign)BOOL inQueue;
@end

@implementation BSBLECommandModel

+ (instancetype)modelWithCommandData:(NSData *)data model:(NSString *)model mac:(NSString *)mac type:(BSDeviceType)type{
    if (!data) {
        return nil;
    }
    BSBLECommandModel *command = [BSBLECommandModel new];
    command.data  = data;
    command.model = model;
    command.mac   = mac;
    command.type  = type;
    command.inQueue = [self isExecuteCommandInQueue:data model:model type:type];
    [command buildResponseHeaderData:data model:model type:type];
    return command;
}

/// 是否在队列中执行
/// @param data  指令
/// @param model 型号
/// @param type  类型
+ (BOOL)isExecuteCommandInQueue:(NSData *)data model:(NSString *)model type:(BSDeviceType)type{
    return (type == BSDeviceTypeOutdoorPower);
}

+ (nullable NSData *)ResponseHeaderData:(NSData *)commandData model:(NSString *)model type:(BSDeviceType)type{
    UInt8 *command = (UInt8 *)[commandData bytes];
    if (commandData.length < 2) {
        return nil;
    }
    Byte byte[2] = {0};
    byte[1] = command[1];
    if (type == BSDeviceTypeOutdoorPower) {
        byte[0] = 0XAA;
    }
    return [NSData dataWithBytes:byte length:sizeof(byte)];
}

#pragma mark- Private methods

- (void)buildResponseHeaderData:(NSData *)commandData model:(NSString *)model type:(BSDeviceType)type{
    self.responseHeaderData = [BSBLECommandModel ResponseHeaderData:commandData model:model type:type];
}

@end
