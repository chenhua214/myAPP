//
//  BSBLEManager.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import <Foundation/Foundation.h>
#import "BSDeviceBLE.h"
#import "BSCommonDevice.h"
NS_ASSUME_NONNULL_BEGIN
typedef void(^searchBlock)(BOOL finished,NSArray<BSDeviceBLE *> * _Nullable devices);

@interface BSBLEManager : NSObject
@property(nonatomic,strong) NSMutableDictionary<NSString *,BSDeviceBLE *> *discoveredDevices;

@property(nonatomic,strong) NSMutableDictionary<NSString *,NSMutableSet<NSString *> *> *searchDevices;
@property(nonatomic,assign) BOOL isSearch;
/// 蓝牙打开与否
@property(nonatomic,assign) BOOL isBlePowerOn;
/// 蓝牙授权与否
@property(nonatomic,assign) BOOL isAuthorized;
/// 第一次蓝牙授权弹框
@property(nonatomic,assign) BOOL isFirstAuthorized;
+ (instancetype)shareInstance;

+ (instancetype)new NS_UNAVAILABLE;
- (instancetype)init NS_UNAVAILABLE;

//扫描设备
- (void)scanBLEDevices;

/// 扫描model类型的可被添加的设备,model为nil时,返回扫描到的可绑定的所有设备;否则model类型下的可绑定的设备
/// @param model 设备类型
/// @param seconds 扫描时间回调 一般设置为5秒
/// @param callback 回调
- (void)scanBLEDevicesWithModel:(nullable NSString *)model delayInSeconds:(float)seconds callback:(nullable searchBlock)callback;

/// 扫描所有model类型的的设备
/// ⚠️ ：此方法跟上面方法，上面方法扫描后会返回已经过滤自己设备的数据，而此方法会返回全部扫描到的当前Model下的所有设备
/// @param model 设备类型
/// @param seconds 扫描时间回调 一般设置为5秒
/// @param callback 回调
- (void)scanAllBLEDevicesWithModel:(nullable NSString *)model delayInSeconds:(float)seconds callback:(nullable searchBlock)callback;

//停止扫描
- (void)stopScanBLEDevices;
//停止扫描
- (void)stopMustScanBLEDevices;
/// ble 连接
/// @param deviceBLE ble device
- (void)connect:(BSDeviceBLE *)deviceBLE;

/// 尝试去连接
/// @param device device
- (void)try2ConnectDevice:(BSCommonDevice *)device;

/// 断开ble 连接
/// @param deviceBLE  ble device
- (void)disconnect:(BSDeviceBLE *)deviceBLE;

/// 检测蓝牙权限状态
/// @param viewController 控制器
- (void)checkBluetoothStatusForVC:(UIViewController *)viewController;

/// 是否需要显示蓝牙提示
/// @param viewController 控制器
- (BOOL)shouldShowBluetoothTipsForVC:(UIViewController *)viewController;

/// 根据mac地址获取 ble device
/// @param macAddress mac address
+ (BSDeviceBLE *)bleDeviceWithMacAddress:(NSString *)macAddress;

/// 更新设备mac地址
/// @param oldMac 原始的mac地址
/// @param newMac 新的mac地址
+ (void)updateBLEDeviceMacWithOldMac:(NSString *)oldMac mac:(NSString *)newMac;

/// 是否启用实时回调数据
/// @param enabled YES/NO
+ (void)realTimeCallbackEnabled:(BOOL)enabled;

@end

NS_ASSUME_NONNULL_END
