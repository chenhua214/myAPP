//
//  BSBLECommandModel.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 指令数据类
@interface BSBLECommandModel : NSObject
/// 指令数据
@property(nonatomic,strong,readonly)NSData *data;
/// 响应的header数据
@property(nonatomic,strong,readonly)NSData *responseHeaderData;
@property(nonatomic,assign,readonly)BOOL inQueue;

/// 指令实例
/// @param data  写入数据
/// @param model 型号
/// @param mac   mac地址
/// @param type  类型
+ (instancetype)modelWithCommandData:(NSData *)data model:(NSString *)model mac:(NSString *)mac type:(BSDeviceType)type;

/// 是否在队列中执行
/// @param data  指令
/// @param model 型号
/// @param type  类型
+ (BOOL)isExecuteCommandInQueue:(NSData *)data model:(NSString *)model type:(BSDeviceType)type;

/// 响应头数据
/// @param commandData 指令数据
/// @param model 型号
/// @param type 类型
+ (nullable NSData *)ResponseHeaderData:(NSData *)commandData model:(NSString *)model type:(BSDeviceType)type;

@end

NS_ASSUME_NONNULL_END
