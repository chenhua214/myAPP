//
//  BSDeviceManager.m
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
///Users/chenhua/Desktop/APP/JDKJAPP/JDKJAPP/Common/BLETool

#import "BSDeviceManager.h"
#import "BSHomeModel.h"
#import "BSPowerBankDevice.h"

NSString *const kBSDeviceNotification = @"BSDeviceNotification";

@implementation BSDeviceNotificationModel
+ (instancetype)modelWithDevice:(BSCommonDevice *)device type:(BSDeviceNotificationType)type{
    BSDeviceNotificationModel *model = [BSDeviceNotificationModel new];
    model.device = device;
    model.type = type;
    return model;
}
@end

@interface BSDeviceManager ()<BSCommonDeviceDelegate>
/// 已经添加的设备 需要从服务器取或者从本地取
@property(nonatomic,strong) NSMutableDictionary<NSString *,BSCommonDevice *> *myDeviceDict;
@property(nonatomic,strong) NSMutableSet<NSNumber *> *deviceTypeSet;
/// <型号-BLE类名>字典
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *>*typeClassNameDict;
/// <型号-BLE类名>字典
@property (nonatomic, strong) NSDictionary<NSString *, NSString *>*modelClassNameDict;
/// Mqtt 查询设备备份字典
@property (nonatomic, strong) NSMutableDictionary *mqttSearchDictionary;
/// 临时不需要自动回连的设备
@property (nonatomic, strong) Class tempNotAutoConnectClass;

@end

@implementation BSDeviceManager
#pragma mark- Life cycle

+ (instancetype)shareInstance{
    static BSDeviceManager *shared;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [BSDeviceManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [BSDeviceManager shareInstance];
}

#pragma mark- Public methods

- (void)addDevice:(BSCommonDevice *)device{
    @synchronized (self.myDeviceDict) {
        [self.myDeviceDict setValue:device forKey:[self.class uniqueIdWithIdentifier:device.identifier]];
    }
}

/// 移除设备
/// @param identifier sn或者mac
- (void)removeDeviceWithIdentifier:(NSString *)identifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device) {
        return;
    }
    device.isUnbundling = YES;
    [self disconnectAndUnbindDevice:device];
    
}

- (void)disconnectAndUnbindDevice:(BSCommonDevice *)device {
    [device disconnect];
    device.delegate = nil;
    @synchronized (self.myDeviceDict) {
        [self.myDeviceDict removeObjectForKey:[self.class uniqueIdWithIdentifier:device.identifier]];
    }
}

/// 是否已拥有
- (BOOL)isOwnedWithIdentifier:(NSString *)identifier{
    return [self findDeviceWithIdentifier:identifier] ? YES : NO ;
}


- (NSInteger)numberOfDevices{
    return self.myDeviceDict.count;
}

/// 根据id获取对应的设备的连接状态
- (BOOL)isConnectedWithIdentifier:(NSString *)identifier{
   BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device) {
        return NO;
    }
    return device.isConnected;
}

//- (BOOL)isMqAndBleConnectedWithIdentifier:(NSString *)identifier {
//    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
//    if (!device || ![self isUsedMqttAndBLEServerWithModel:device.model]) {
//        return NO;
//    }
//    return (device.isConnected || device.mqonline);
//}


///// 根据id获取对应的设备的工作状态
///// @param identifier 唯一标识
//- (BOOL)isWorkStateWithIdentifier:(NSString *)identifier {
//    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
//    if (!device) {
//        return NO;
//    }
//    if ([device isKindOfClass:[BSSmartSocketDevice class]]) {
//        return ((BSSmartSocketDevice *)device).powerON;
//    }
//    if ([device isKindOfClass:[BSCharger240wDevice class]]) {
//        return ((BSCharger240wDevice *)device).power_ON;
//    }
//    return NO;
//}

///// 列表返回设备类型(BSMqBaseDevice)
///// @param clientId sn或者mac
//- (Class)findDeviceClassWithClientId:(NSString *)clientId {
//    if (!clientId.isEnable || ![clientId isKindOfClass:[NSString class]]) return nil;
//    NSString *deviceCls = [self.mqttSearchDictionary objectForKey:clientId];
//    if (deviceCls.isEnable) return NSClassFromString(deviceCls);
//    NSDictionary *deviceDict = [self getDeviceMacOneToOneSnList];
//    deviceCls = [deviceDict objectForKey:clientId];
//    if (![deviceCls isKindOfClass:[NSString class]] || !deviceCls.isEnable) return nil;
//    @try {
//        [self.mqttSearchDictionary setObject:deviceCls forKey:clientId];
//    } @catch (NSException *exception) {
//        NSLog(@"exception :%@",exception);
//        [BSCrashProtectionManager reportException:exception message:@"findDeviceClassWithClientId"];
//    }
//    return NSClassFromString(deviceCls);
//}


/// 自动连接该设备
- (void)autoConnectWithIdentifier:(NSString *)identifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device || device.bleDevice.isConnected || [self notAutoConnectWithDevice:device]) {
        return;
    }
    if (device.deviceType == BSDeviceTypeOutdoorPower) {
        if (device.isEnable) {
            [device connect];
        }
        return;
    }
    [device connect];
}

- (void)autoConnectWithIdentifier:(NSString *)identifier mainIdentifier:(NSString*)mainIdentifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device || device.bleDevice.isConnected || [self notAutoConnectWithDevice:device]) {
        return;
    }
    device.mainIdentifier = mainIdentifier ;
    if (device.deviceType == BSDeviceTypeOutdoorPower) {
        /// 个别设备启动之后才能回自动连接
        if (device.isEnable) {
            [device connect];
        }
        return;
    }
    [device connect];
}

// 不用自动连接的设备
- (BOOL)notAutoConnectWithDevice:(BSCommonDevice *)device {
    NSLog(@"class : %@",self.tempNotAutoConnectClass);
    return NO; /// 前期默认全部自动连接，后期有其他设备再加上判断
//    return [device isKindOfClass:[BSWashingMachine class]] ||
//            (self.tempNotAutoConnectClass && [device isKindOfClass:self.tempNotAutoConnectClass]) ||
//            [self isUsedMqttServerWithModel:device.model];
}

/// 临时不需要自动连接的设备类型
- (void)tempNotAutoConnectDevices:(Class)classes
{
    /**
     * 某些设备在某些时候，不需要主动回连
     * 比如电容笔在OTA时，由于独立的OTA程序，需要单独扫描连接设备，故此不能被主框架的蓝牙控制中心连接，故需要过滤主动回连
     */
    self.tempNotAutoConnectClass = classes;
}

//如何监听device的状态 单个
- (void)congfigDevicesWithDevices:(NSArray *)devices{
    @synchronized (self.deviceTypeSet) {
        [self.deviceTypeSet removeAllObjects];
    }
    if (devices.count == 0) {
        @synchronized (self.myDeviceDict) {
            NSArray *allDevies = self.myDeviceDict.allValues.copy;
            for (BSCommonDevice *device in allDevies) {
                if (device.delegate) {
                    device.delegate = nil;
                }
            }
            [self.myDeviceDict removeAllObjects];
        }
        return;
    }
    NSMutableSet *data = [NSMutableSet set];
    [devices enumerateObjectsUsingBlock:^(BSCommonDevice * _Nonnull device, NSUInteger idx, BOOL * _Nonnull stop) {
        if (device && device.identifier && device.identifier.length > 0) {
            [data addObject:[self.class uniqueIdWithIdentifier:device.identifier]];
        }
    }];
    @synchronized (self.myDeviceDict) {
        NSMutableSet *allIds = [NSMutableSet setWithArray:self.myDeviceDict.allKeys];
        //找出不存在的数据
        [allIds minusSet:data];
        if(allIds.count > 0){ [self.myDeviceDict removeObjectsForKeys:allIds.allObjects]; }
    }
    //同步服务器的数据
    for (BSHomeDeviceModel *model in devices) {
        @synchronized (self.deviceTypeSet) {
            [self.deviceTypeSet addObject:@(model.deviceType)];
        }
        @synchronized (self.myDeviceDict) {
            BSCommonDevice *device = [self findDeviceWithIdentifier:model.sn];
            if (!device) {
                device = [self deviceWithIdentifier:model.sn type:model.deviceType model:model.model];
            }
            if(!device){
                continue;
            }
            [model syncData2Device:device];
            device.delegate  = self;
            [self.myDeviceDict setValue:device forKey:[self.class uniqueIdWithIdentifier:model.sn]];
//            if (device.deviceType == BSDeviceTypeOutdoorPower) {
//                [self antiLostAlarm:(BSTagDevice *)device model:model];
//            }
        }
    }
    [self try2ConnectOnceIfNeeded];
}


/// 从服务器获取已经绑定的设备,配置部分信息
- (void)configDevicesWithDevices:(NSArray *)deviceArr callback:(nullable void(^)(void))callback{
    NSMutableArray<BSHomeDeviceModel *> *devices = [NSMutableArray arrayWithArray:deviceArr];
    [BSConfigManager sharedInstance].totalDeviceCount = devices.count;
    [self congfigDevicesWithDevices:devices]; // 为了提升BLE连接速度，将此步骤从“1”提到此处
//    [self downloadProductResourceWithDevices:devices callback:^{
//        [[BSDeviceResourceDownloader instance] syncData2Devices:devices];
////        [self congfigDevicesWithDevices:devices]; // 1
//        if(callback){
//            callback();
//        }
//    }];
}

/// 替换某个设备设备
- (void)replaceDevice:(BSCommonDevice *)oldDevice withDevice:(BSCommonDevice *)newDevice devicesInfo:(NSArray *)devicesInfo {
    //服务器拉取 本地缓存
    //得知你的设备是什么 根据你的设备 identifier 建立设备
    BSHomeDeviceModel *dataModel;
    for (BSHomeDeviceModel *model in devicesInfo) {
        if ([model.sn isEqualToString:oldDevice.identifier]) {
            dataModel = model;
            break;
        }
    }
    if (!dataModel) return;
    [dataModel syncData2Device:newDevice];
    newDevice.delegate  = self;
    @synchronized (self.myDeviceDict) {
        NSString *oldUniqueId = [self.class uniqueIdWithIdentifier:oldDevice.identifier];
        [self.myDeviceDict removeObjectForKey:oldUniqueId];
        NSString *uniqueId = [self.class uniqueIdWithIdentifier:newDevice.identifier];
        [self.myDeviceDict setValue:newDevice forKey:uniqueId];
    }
}

/// 根据唯一标识、设备类型、型号创建类
- (BSCommonDevice *)deviceWithIdentifier:(NSString *)identifier type:(BSDeviceType)type model:(NSString *)model {
    NSString *className = self.typeClassNameDict[@(type)];
    if (!className && model && model.length > 0) {
        className = self.modelClassNameDict[model];
    }
    if (!className || className.length == 0) {
        return nil;
    }
    BSCommonDevice *device = nil;
    Class class = NSClassFromString(className);
    if ([class isSubclassOfClass:BSCommonDevice.class]) {
        device = [BSCommonDevice modelWithClass:class identifier:identifier type:type model:model];
    }
    NSLog(@"device: %@",device);
    return device;
}

/// 根据唯一标识返回设备类型
- (NSString *)modelWithIdentifier:(NSString *)identifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    return (device != nil) ? device.model : nil;
}

/// 列表返回设备(BSCommonDevice)
- (nullable id)findDeviceWithIdentifier:(NSString *)identifier{
    if (!identifier || identifier.length == 0 ) { return nil; }
    BSCommonDevice *targetDevice = nil;
    @synchronized (self.myDeviceDict) {
        if(self.myDeviceDict.count == 0) { return nil; }
        NSString *uniqueId = [self.class uniqueIdWithIdentifier:identifier];
        targetDevice = self.myDeviceDict[uniqueId];
    }
//    if(targetDevice)
//        NSLog(@"identifier:%@,model:%@,targetDevice:%p",identifier,targetDevice.model,targetDevice);
    return targetDevice;
}

///// 根据SN返回设备经纬度   暂时不需要
//- (CLLocationCoordinate2D)coordinate2DWithIdentifier:(NSString *)identifier{
//    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
//    if (!device) {
//        return CLLocationCoordinate2DMake(0, 0);
//    }
//    return CLLocationCoordinate2DMake(device.latitude, device.longitude);
//}


- (void)doLogoutIfNeeded{
//    if(!IS_GUEST_MODE){/*非访客模式,无需处理*/ return; }
    [self doLogout];
}

- (void)doLogout{
//    if (!self.myDeviceDict || self.myDeviceDict.count == 0) {
//        return;
//    }
//    NSArray *tempDevices = [NSArray arrayWithArray:self.myDeviceDict.allValues];
//    for (BSCommonDevice *device in tempDevices) {
//        device.isUnbundling = YES;
//        device.delegate = nil;
//        [device disconnect];
//    }
//    @synchronized (self.myDeviceDict) {
//        [self.myDeviceDict removeAllObjects];
//    }
//    [[BSHeadsetGesSettingManager shareInstance] cleanAllGestureCacheInMemory];
}

- (void)updateName:(NSString *)name forIdentifier:(NSString *)identifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device) {
        return;
    }
    device.name = name;
}

/// 清除BLE指令
/// @param identifier sn或者mac
- (void)cleanBLECommandWithIdentifier:(NSString *)identifier{
    BSCommonDevice *device = [self findDeviceWithIdentifier:identifier];
    if (!device || !device.bleDevice) { return; }
    NSLog(@"清空 %@(%@) 所有BLE 指令",device.identifier,device.name);
    @try {
        [device.bleDevice clearAllCommand];
    } @catch (NSException *exception) {
        NSLog(@"exception : %@",exception.reason);
    }
}

/// 仅有一个设备时尝试直连一次
- (void)try2ConnectOnceIfNeeded {
    
    [self.myDevices enumerateObjectsUsingBlock:^(BSCommonDevice *device, NSUInteger idx, BOOL *stop) {
        
        if (device && !device.isConnected) {
            /**
             以下情况不自动连接
             1.设备不存在
             2.设备是电容笔系列、洗地机、智能排插
             3.设备已经连接
             */
            [device try2Connect];
        }
    }];
}


#pragma mark- download resources

/// 请求服务器数据
//- (void)downloadProductResourceWithDevices:(NSArray<BSHomeDeviceModel *> *)devices callback:(void(^)(void))callback{
//    NSMutableSet *modelSet = [NSMutableSet set];
//    for (BSHomeDeviceModel *device in devices) {
//        if (device.model && device.model.length > 0) {
//            [modelSet addObject:device.model];
//        }
//    }
//    [[BSDeviceResourceDownloader instance] downloadProductResourceWithModels:modelSet resourceBlock:callback];
//}


#pragma mark- BSCommonDeviceDelegate

- (void)didConnectWithDevice:(BSCommonDevice *)device{
    NSLog(@"didConnectWithDevice");
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSDeviceNotification object:[BSDeviceNotificationModel modelWithDevice:device type:BSDeviceNotificationTypeConnected]];
}

- (void)didDisConnectWithDevice:(BSCommonDevice *)device{
    NSLog(@"didDisConnectWithDevice");
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSDeviceNotification object:[BSDeviceNotificationModel modelWithDevice:device type:BSDeviceNotificationTypeDisconnected]];
}

#pragma mark- Utils

+ (NSString *)uniqueIdWithIdentifier:(NSString *)identifier{
    return [identifier.copy uppercaseString];
}

#pragma mark- Setters && Getters

- (NSMutableArray<BSCommonDevice *> *)myDevices{
    return self.myDeviceDict.allValues.mutableCopy;
}

- (NSMutableDictionary<NSString *,BSCommonDevice *> *)myDeviceDict{
    if(!_myDeviceDict){
        _myDeviceDict = [NSMutableDictionary dictionary];
    }
    return _myDeviceDict;
}

- (NSMutableSet<NSNumber *> *)deviceTypeSet{
    if (!_deviceTypeSet) {
        _deviceTypeSet = [NSMutableSet set];
    }
    return _deviceTypeSet;
}

- (NSArray<NSNumber *> *)allBoundDeviceTypes{
    NSArray<NSNumber *> *allObjects = self.deviceTypeSet.allObjects;
    if (!allObjects || allObjects.count == 0) {
        return nil;
    }
    return allObjects;
}

- (NSMutableDictionary *)mqttSearchDictionary {
    if (!_mqttSearchDictionary) {
        _mqttSearchDictionary = [NSMutableDictionary dictionary];
    }
    return _mqttSearchDictionary;
}

/// 型号-BLE类名
- (NSDictionary<NSNumber *,NSString *> *)typeClassNameDict{
    if (!_typeClassNameDict) {
        _typeClassNameDict = @{
            /* 移动电源设备 */
            @(BSDeviceTypeOutdoorPower)          : NSStringFromClass(BSPowerBankDevice.class),
            /* 移动电源设备 */
//            @(BSDeviceTypeEarphone)     : NSStringFromClass(BSEarphones.class),
        };
    }
    return _typeClassNameDict;
}


- (NSDictionary<NSString *,NSString *> *)modelClassNameDict{
    if (!_modelClassNameDict) {
        _modelClassNameDict = @{
            /* 移动电源设备*/
            kBSDeviceModelTag : NSStringFromClass(BSPowerBankDevice.class),
        };
    }
    return _modelClassNameDict;
}


@end
