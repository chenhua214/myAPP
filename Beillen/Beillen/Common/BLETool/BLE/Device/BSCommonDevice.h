//
//  BSCommonDevice.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSBaseDatabaseModel.h"
#import "BSDeviceBLE.h"
#import "BSBLEResponse.h"

NS_ASSUME_NONNULL_BEGIN
@class BSCommonDevice;

@protocol BSCommonDeviceDelegate <NSObject>

@optional
- (void)didConnectWithDevice:(BSCommonDevice *)device;

- (void)didDisConnectWithDevice:(BSCommonDevice *)device;

/// 设备报警手机
/// @param device device
//- (void)alertPolicWithDevice:(BSCommonDevice *)device;

@end


@interface BSCommonDevice : BSBaseDatabaseModel<BSDeviceBLEDelegate>
@property (nonatomic, assign) NSInteger deviceOrder;
/// 设备唯一标识 （mac地址 大写）
@property(nonatomic,  copy) NSString *identifier;
@property(nonatomic,  copy) NSString *mainIdentifier;
// 设备类型
@property(nonatomic,assign) BSDeviceType deviceType;
/// 设备型号
@property(nonatomic,  copy) NSString *model;
/// 设备子类型
@property(nonatomic,assign,readonly) BSDeviceSubType deviceSubType;

///设备服务器图片地址
@property(nonatomic,  copy) NSString *deviceImgUrl;

/// 是否开启报警 0- 开启 1-关闭
@property(nonatomic,  assign) NSInteger started;
///是否是分享的设备：0-不是，1-是
@property(nonatomic,assign) NSInteger shared;
///设备分享ID
@property(nonatomic,assign) int64_t shareId;
@property(nonatomic,strong) NSArray<NSString *> *accounts;

/// 设备是否启用
@property(nonatomic,assign,readonly) BOOL isEnable;
@property(nonatomic,assign) BOOL isUnbundling;
@property(nonatomic,weak) id <BSCommonDeviceDelegate>delegate;

/// 设备是否连接
@property(nonatomic,assign,readonly) BOOL isConnected;
/// 蓝牙外设
@property(nonatomic, strong) BSDeviceBLE *bleDevice;

/// 蓝牙信号码
@property(nonatomic,strong) NSNumber *RSSI;
/// 设备电量
@property(nonatomic,assign) NSInteger power;
/// 设备别名
@property(nonatomic,  copy) NSString *name;
///产品名称
@property(nonatomic,  copy) NSString *prodName;
///付文信息
@property(nonatomic,  copy) NSString *detailName;
@property (nonatomic, assign) BOOL online;// 是否在线
@property (nonatomic, assign,readonly) BOOL lastOnline;// 上一次的在/离线状态

/// 设备版本号
@property (nonatomic,   copy) NSString *versionCode;
/// 设备持有者的id
@property(nonatomic,assign) int64_t accountId;
/// 分类Id
@property(nonatomic,assign)int64_t categoryId;
/// 软件版本
@property(nonatomic,  copy) NSString *softVersion;


+ (instancetype)modelWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(nullable NSString *)model;

+ (instancetype)modelWithClass:(Class)className identifier:(NSString *)identifier type:(BSDeviceType)type model:(nullable NSString *)model;

- (instancetype)initWithIdentifier:(NSString *)identifier type:(BSDeviceType)type;
- (instancetype)initWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(nullable NSString *)model;

/// 是否支持该设备
/// @param model 设备型号
+ (BOOL)isSupportedDevice:(NSString *)model;

- (void)connect;
- (void)disconnect;

- (void)try2Connect;

/// 根据型号返回对应的子类型
/// @param model 设备型号
+ (BSDeviceSubType)deviceSubTypeWithModel:(NSString *)model;

/// ⚠️⚠️⚠️⚠️⚠️ 此方法需要子类重载⚠️⚠️⚠️⚠️⚠️⚠️
/// 如果子类设备支持版本读取，则需要重载此方法
/// 设备绑定的时候，或者OTA升级时需要查询设备版本信息
- (void)readDeviceVersionWithResponseBlock:(BSResponseBlock)block;

/// 读取最新的rssi码
/// @param block 回调
- (void)readRssi:(BSResponseBlock)block;

- (void)addBleCommandByte:(NSData *)commandByte responseBlock:(BSResponseBlock)block;
//添加命令的回调
- (void)addBleCommandByte:(NSData *)commandByte maxTimes:(int)maxTimes responseBlock:(BSResponseBlock)block;
//添加命令的回调
- (void)addBleCommandByte:(NSData *)commandByte maxTimes:(int)maxTimes delayInSeconds:(int)delayInSeconds responseBlock:(BSResponseBlock)block;

- (void)commandRspCallBackWithType:(NSData *)type result:(BOOL)result responseDic:(NSDictionary *)responseDic;

- (void)removeAllResponseBlockIfNeeded;


- (nullable BSResponseBlock)responseBlockWithCommandByte:(NSData *)commandByte;

- (nullable BSBLEResponse *)responseWithCommandByte:(NSData *)commandByte;

/// 电量有效值
/// @param batteryString 电量字符串
- (nonnull NSString *)validValueForBattery:(NSString *)batteryString;
/// @param batteryString 电量字符串  四舍五入 返回10的倍数的整数 10、20、30
- (nonnull NSString *)validValueMultiplesOfTenForBattery:(NSString *)batteryString ;


/// 根据类型获取model名称
+ (NSString *)modelWithDeviceSubType:(BSDeviceSubType)type;

/// 是否模拟器
+ (BOOL)isSimulator;
@end

NS_ASSUME_NONNULL_END
