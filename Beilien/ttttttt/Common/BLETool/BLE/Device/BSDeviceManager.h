//
//  BSDeviceManager.h
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import <Foundation/Foundation.h>
#import "BSCommonDevice.h"
NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXTERN NSString *const kBSDeviceNotification;

typedef NS_ENUM(NSInteger, BSDeviceNotificationType) {
    BSDeviceNotificationTypeConnected,//已连接
    BSDeviceNotificationTypeDisconnected,//已断开连接
    BSDeviceNotificationTypeAlarm//报警
};

@interface BSDeviceNotificationModel : NSObject
@property(nonatomic,strong) BSCommonDevice *device;
@property(nonatomic,assign) BSDeviceNotificationType type;
@end

@interface BSDeviceManager : NSObject

/// 获取账号下所有的设备类型
@property(nullable,nonatomic,strong,readonly)NSArray<NSNumber *> *allBoundDeviceTypes;

/// 已经添加的设备 需要从服务器取或者从本地取
@property(nonatomic,strong,readonly) NSMutableArray<BSCommonDevice *> *myDevices;

+ (instancetype)shareInstance;

/// 添加设备
/// @param device 设备
- (void)addDevice:(BSCommonDevice *)device;

/// 移除设备
/// @param identifier sn或者mac
- (void)removeDeviceWithIdentifier:(NSString *)identifier;

/// 从服务器获取已经绑定的设备,配置部分信息
- (void)configDevicesWithDevices:(NSArray *)deviceArr callback:(nullable void(^)(void))callback;

/// 替换某个设备设备
/// @param oldDevice 需要被替换的设备
/// @param newDevice 新设备
/// @param devicesInfo 所有从服务器拿下来的数据信息
- (void)replaceDevice:(BSCommonDevice *)oldDevice withDevice:(BSCommonDevice *)newDevice devicesInfo:(NSArray *)devicesInfo;

/// 根据唯一标识、设备类型、型号创建类
/// @param identifier 唯一标识
/// @param type 设备类型
/// @param model 设备型号
- (BSCommonDevice *)deviceWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(NSString *)model;

/// 是否已拥有
/// @param identifier sn 或 mac
- (BOOL)isOwnedWithIdentifier:(NSString *)identifier;


/// 判断是否是使用的mqtt服务
//- (BOOL)isMqttServerUsed;

/// BLE class 名称与设备mqtt需要用到的 sn 一一对应
//- (NSDictionary *)getDeviceMacOneToOneSnList;

/// mqtt设备在线状态刷新
//- (void)updateMqttDevicesOnlineState:(NSArray <BSMQTTSessionStateDeviceModel *> *)devices;

/// 获取当前账号下的设备个数
- (NSInteger)numberOfDevices;

/// 根据id获取对应的设备的连接状态
/// @param identifier 唯一标识
- (BOOL)isConnectedWithIdentifier:(NSString *)identifier;

/// 根据id获取对应的设备的连接状态
/// @param identifier 唯一标识
//- (BOOL)isMqConnectedWithIdentifier:(NSString *)identifier;

/// 根据id获取对应的设备的连接状态
/// @param identifier 唯一标识
//- (BOOL)isMqAndBleConnectedWithIdentifier:(NSString *)identifier;

/// 是否使用的 Mqtt 与 BLE 双通道 服务
//- (BOOL)isUsedMqttAndBLEServerWithModel:(NSString *)model;

/// 根据id获取对应的设备的工作状态
/// @param identifier 唯一标识
//- (BOOL)isWorkStateWithIdentifier:(NSString *)identifier;

/// 列表返回设备类型(BSMqBaseDevice)
/// @param clientId 使用mqtt server需要用到的烧录到设备的sn和固定规则字段组合成的
//- (Class)findDeviceClassWithClientId:(NSString *)clientId;

/// 自动连接该设备
/// @param identifier 唯一标识
- (void)autoConnectWithIdentifier:(NSString *)identifier;
- (void)autoConnectWithIdentifier:(NSString *)identifier mainIdentifier:(NSString*)mainIdentifier;

/// 临时不需要自动连接的设备类型
- (void)tempNotAutoConnectDevices:(_Nullable Class)classes;

/// 列表返回设备(BSCommonDevice)
/// @param identifier sn或者mac
- (nullable id)findDeviceWithIdentifier:(NSString *)identifier;

/// 根据唯一标识返回设备类型
/// @param identifier 唯一标识
- (NSString *)modelWithIdentifier:(NSString *)identifier;

/// 根据SN返回设备经纬度
/// @param identifier 唯一标识
//- (CLLocationCoordinate2D)coordinate2DWithIdentifier:(NSString *)identifier;

/// 登出操作
- (void)doLogout;

///如果是访客模式,则需先做登出处理
- (void)doLogoutIfNeeded;


/// 更新设备名称
/// @param name 设备名称
/// @param identifier 唯一标识
- (void)updateName:(NSString *)name forIdentifier:(NSString *)identifier;

/// 清除BLE指令
/// @param identifier sn或者mac
- (void)cleanBLECommandWithIdentifier:(NSString *)identifier;

/// 仅有一个设备时尝试直连一次
- (void)try2ConnectOnceIfNeeded;


@end

NS_ASSUME_NONNULL_END
