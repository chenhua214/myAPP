//
//  BSDeviceBLE.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import "BSBLECommandControl.h"

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const kBSBLEDidConnectNotification;
FOUNDATION_EXTERN NSString *const kBSBLEDidDisconnectNotification;
FOUNDATION_EXTERN NSString *const kBSBLEDidIdentifyAuthNotification;
FOUNDATION_EXTERN NSString *const kBSBLEDidPowerONNotification;
FOUNDATION_EXTERN NSString *const kBSBLEPoweredOffNotification;
FOUNDATION_EXTERN NSString *const kBSBluetoothDidDiscoverDevice;

@protocol BSDeviceBLEDelegate <NSObject>

@optional
/// 已经断开连接
- (void)didDisconnected;

/// 已经连接
- (void)didConnected;

/// 写命令回调更新处理
/// @param value 数据
- (void)didUpdateValue:(NSData *)value;
- (void)didUpdateValue:(NSData *)value characteristic:(CBCharacteristic *)characteristic;

/// 写入数据结果回调
/// @param error error
- (void)didWriteValueWithError:(NSError *)error;
- (void)didWriteValueWithError:(NSError *)error characteristic:(CBCharacteristic *)characteristic;

- (void)didReadRSSI:(NSNumber *)RSSI;

@end


@interface BSDeviceBLE : NSObject <CBPeripheralDelegate>
@property(nonatomic,assign,readonly) NSUInteger maximumWriteValue;
/// 外设
@property(nonatomic,strong) CBPeripheral *peripheral;
/// 设备名称
@property(nonatomic,  copy) NSString *name;

//peripheral?.identifier.uuidString
@property(nonatomic,  copy) NSString *identifier;

@property(nonatomic,strong) NSDictionary *advertisementData;

@property(nonatomic,strong) NSNumber *RSSI;

@property(nonatomic,  copy) NSString *mac;
//  两个地址下划线_拼接起来    地址A_地址B
@property(nonatomic,  copy) NSString *longMac;
@property(nonatomic,assign) NSInteger type;

@property(nonatomic,assign) BOOL isConnected;
@property(nonatomic,weak) id <BSDeviceBLEDelegate>delegate;

@property(nonatomic,copy,nullable) void(^didResponseCommandCallback)(void);

@property(nonatomic, strong)CBCharacteristic *characteristic;

/// 写指令
/// @param data 数据
- (BOOL)writeCommand:(NSData *)data;

/// 执行指令
/// @param data 数据
/// @param inQueue 是否在队列中写入
- (BOOL)executeCommand:(NSData *)data inQueue:(BOOL)inQueue;

/// 执行指令(在队列中)
/// @param data 数据
- (BOOL)executeCommandInQueue:(NSData *)data;

/// 清除所有的指令
- (void)clearAllCommand;

- (void)didConnected;
- (void)didDisconnected;

/// 读取信号值
- (void)setNeedUpdateRSSI;

- (void)discoverServices;

- (void)cancelPeripheralConnection;

- (CBCharacteristic *)characteristicWithUUID:(NSString *)uuid serviceUUID:(NSString *)serviceUUID;

- (void)executeCommand:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type;

- (void)executeCommand:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic;

+ (BSDeviceBLE *)deviceFromMac:(NSString *)macAddress;

@end

NS_ASSUME_NONNULL_END
