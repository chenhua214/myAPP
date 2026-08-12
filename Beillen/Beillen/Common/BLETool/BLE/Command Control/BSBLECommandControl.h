//
//  BSBLECommandControl.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BSDeviceBLE;
@interface BSBLECommandControl : NSObject

@property(nonatomic, strong) BSDeviceBLE *bleDevice;

- (instancetype)initWithBLEDevice:(BSDeviceBLE *)bleDevice;

/// 执行指令
/// @param data 指令数据
- (void)executeCommandWithData:(NSData *)data;

/// 清空所有指令
- (void)clearAllCommand;

/// 给定的数据与responseHeaderData 是否匹配
/// @param data 给定的数据
- (BOOL)isMatchWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
