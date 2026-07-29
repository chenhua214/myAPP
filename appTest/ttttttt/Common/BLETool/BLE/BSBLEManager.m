//
//  BSBLEManager.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "BSBLEManager.h"
#import "BSDeviceBLE.h"
#import <CoreBluetooth/CoreBluetooth.h>
#import <libkern/OSAtomic.h>
#import "BSGCDTimer.h"
#import "BSCommonDevice.h"

#import "BSDeviceManager.h"
#import "BSPowerBankBLE.h"
@interface BSDeviceBLE(Additions)
+ (instancetype)modelWithType:(BSDeviceType)type;
+ (instancetype)modelWithClass:(Class)class type:(BSDeviceType)type;
@end

@implementation BSDeviceBLE(Additions)

+ (instancetype)modelWithType:(BSDeviceType)type{
    return [self modelWithClass:self.class type:type];
}

+ (instancetype)modelWithClass:(Class)class type:(BSDeviceType)type{
    BSDeviceBLE *model = [[class alloc] init];
    model.type = type;
    return model;
}

@end


static NSString *const kBSBLEScanDeviceTimer  = @"BSBLEScanDeviceTimer";
static NSString *const kBSBLEDeviceIdentityDictionary  = @"BLEDeviceIdentityDictionary";

typedef void(^scanBlock)(BOOL finished,NSDictionary<NSString *,NSMutableSet<NSString *> *> *);

@interface BSBLEManager ()<CBCentralManagerDelegate,NSCopying>{
    CBCentralManager * _centralManager;
}
/// <型号-类型>字典
@property (nonatomic, strong) NSDictionary<NSString *, NSNumber *>*modelTypeDict;
/// <类型-UUID>字典
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *>*typeServiceUUIDDict;
/// <型号-BLE类名>字典
@property (nonatomic, strong) NSDictionary<NSNumber *, NSString *>*typeBLENameDict;
/// <型号-BLE类名>字典
@property (nonatomic, strong) NSDictionary<NSString *, NSString *>*modelBLENameDict;
///搜索的model
@property (nonatomic,   copy) NSString *model;
///搜索回调
@property (nonatomic,   copy) scanBlock scanCallback;

@property (nonatomic, assign) BOOL realTimeCallbackEnabled;

@end


@implementation BSBLEManager

#pragma mark- Life cycle

+ (instancetype)shareInstance{
    static id shared = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        shared = [[super allocWithZone:NULL] init];
    });
    return shared;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [BSBLEManager shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [BSBLEManager shareInstance];
}

#pragma mark - setup

- (void)setup{
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)];
}

#pragma mark - Public methods

/// 扫描设备
- (void)scanBLEDevices{
    if (self.isSearch == YES) return;
    [self scanDevicesWithModel:nil types:[BSDeviceManager shareInstance].allBoundDeviceTypes delayInSeconds:5 callback:nil];
}

/// 扫描model类型的可被添加的设备,model为nil时,返回扫描到的可绑定的所有设备;否则model类型下的可绑定的设备
- (void)scanBLEDevicesWithModel:(NSString *)model delayInSeconds:(float)seconds callback:(nullable searchBlock)callback{
    [self scanDevicesWithModel:model delayInSeconds:seconds callback:^(BOOL finished,NSDictionary<NSString *,NSMutableSet<NSString *> *> *searchDevices) {
        [self scanDeviceFinishedWithModel:model filterOwned:YES devices:searchDevices finished:finished callback:callback];
    }];
}
/// 扫描所有model类型的的设备
- (void)scanAllBLEDevicesWithModel:(NSString *)model delayInSeconds:(float)seconds callback:(nullable searchBlock)callback {
    [self scanDevicesWithModel:model delayInSeconds:seconds callback:^(BOOL finished,NSDictionary<NSString *,NSMutableSet<NSString *> *> *searchDevices) {
        [self scanDeviceFinishedWithModel:model filterOwned:NO devices:searchDevices finished:finished callback:callback];
    }];
}

- (void)scanDevicesWithModel:(NSString *)model delayInSeconds:(float)seconds callback:(scanBlock)callback {
    NSArray *deviceTypes = [self deviceTypesWithModel:model];
    [self scanDevicesWithModel:model types:deviceTypes delayInSeconds:seconds callback:callback];
}

- (void)scanDevicesWithModel:(nullable NSString *)model types:(NSArray<NSNumber *> *)types delayInSeconds:(float)seconds callback:(scanBlock)callback {
    if (!self.isBlePowerOn) {
        NSLog(@"bluetooth is off");
        if (callback) {
            callback(YES,nil);
        }
        return;
    }
    self.model = model;
    self.scanCallback = callback;
    self.isSearch = YES;
    @synchronized (self.searchDevices) {
        [self.searchDevices removeAllObjects];
    }
    NSArray *deviceTypes = types.mutableCopy;
    [self startScanWithTypes:deviceTypes];
    dispatch_queue_t queue = dispatch_queue_create("com.baseus.scanBLEDevices", DISPATCH_QUEUE_CONCURRENT);
    @weakify(self);
    //每3秒扫描一次
    [[BSGCDTimer shareInstance] scheduledDispatchTimerWithName:kBSBLEScanDeviceTimer timeInterval:3.86 queue:queue repeats:YES actionOption:AbandonPreviousAction action:^{
        @strongify(self);
        [self startScanWithTypes:deviceTypes];
    }];
    if(callback){
        // seconds 秒后回调结果
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(seconds * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self stopScanDevListWithModel:model callback:callback];
        });
    }
}


// filterOwned : 是否过滤自己的设备
- (void)scanDeviceFinishedWithModel:(NSString *)model
                        filterOwned:(BOOL)filter
                            devices:(NSDictionary<NSString *,NSMutableSet<NSString *> *> *)searchDevices
                           finished:(BOOL)finished
                           callback:(nullable searchBlock)callback{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSLog(@"model: %@, searchDevices:%@",model,searchDevices);
        NSMutableSet *macs = [NSMutableSet set];
        [searchDevices enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, NSMutableSet<NSString *> * _Nonnull obj, BOOL * _Nonnull stop) {
            if (!model) {
                [macs unionSet:obj];
            }else{
                if ([key isEqualToString:model]) {
                    [macs setSet:obj];
                    *stop = YES;
                }
            }
        }];
        NSMutableArray<BSDeviceBLE *> *devices = [NSMutableArray array];
//        BOOL isWashingMachine = ([BSCommonDevice deviceSubTypeWithModel:model] == BSDeviceSubTypeSmartWashingMachine);
        for (NSString *mac in macs) {
            if ((filter == NO) ||
                ((filter == YES) && (![[BSDeviceManager shareInstance] isOwnedWithIdentifier:mac] ))) {
                //如果未被当前账户绑定,则可能添加(可能已被其他用户添加)
                NSMutableDictionary *dic = [[BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary] mutableCopy];
                BSDeviceBLE *deviceBle = [self.discoveredDevices objectForKey:dic[mac]];
                // if (deviceBle && (!deviceBle.isConnected) && (deviceBle.peripheral.state == CBPeripheralStateDisconnected)) {
                //     [devices addObject:deviceBle];
                if (deviceBle && (!deviceBle.isConnected) && (deviceBle.peripheral.state != CBPeripheralStateConnected)) {
                    if (![devices containsObject:deviceBle]) {
                        [devices addObject:deviceBle];
                    }
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (callback) {
                callback(finished,devices.count > 0 ? devices : nil);
            }
        });
    });
}


// 根据设备model将手机已经连接的设备添加到发现设备数组里面
- (void)insertLocalBLEConnnectedDevicesIntoDiscoveredDevicesWithModel:(NSString *)model {
    if(!model){ return; }
    [self insertLocalBLEConnnectedDevicesIntoDiscoveredDevicesWithModels:[NSSet setWithObject:model]];
}

- (void)insertLocalBLEConnnectedDevicesIntoDiscoveredDevicesWithModels:(NSSet *)models{
    if(!models || models.count == 0) { return; }
    NSMutableSet<NSString *> *uuids = [NSMutableSet set];
   
    if (uuids.count == 0) {
        return;
    }
    // 从设置-蓝牙-已连接的设备中去获取设备
    NSArray<CBUUID *> *serviceUUIDs = [self serviceUUIDsWithUUIDs:[uuids allObjects]];
    NSArray<CBPeripheral *> *retrieveArray = [self->_centralManager retrieveConnectedPeripheralsWithServices:serviceUUIDs];
    NSLog(@"\n⭐️ retrieveArray %@",retrieveArray);
    for (NSInteger i = 0; i < retrieveArray.count; i++) {
        CBPeripheral *peripheral = retrieveArray[i];
        NSString *mac = [[self class] deviceMacWithIdentifiers:peripheral.identifier.UUIDString]; // 根据identifiers找到mac
        if (mac) {
            mac = [mac stringByReplacingOccurrencesOfString:@":" withString:@""];// 如果找到去“:”
            NSString *model = peripheral.name;
            if (!model) continue;
            if (![self macDataIsHightLowFormatWithLocalName:model]) // 如果mac地址是小端格式，则需要反转一下，因为后面建model会再次反转，故作此动作
            {
                NSMutableString *str = [NSMutableString string];
                for (int i = (int)mac.length-2; i >= 0 ; i-=2) {
                    [str appendFormat:@"%@%@",[mac substringWithRange:NSMakeRange(i, 1)],[mac substringWithRange:NSMakeRange(i+1, 1)]];
                }
                mac = str;
            }
        }
        
        if (!mac) continue;
        NSData *macData = [mac convertBytesStringToData];
        if ([models containsObject:peripheral.name] && peripheral.state != CBPeripheralStateConnected)
        {
            NSDictionary *advertisementData = @{ CBAdvertisementDataManufacturerDataKey:macData };
            @synchronized (self.discoveredDevices) {
                [self generateBLEDevice:peripheral advertisementData:advertisementData RSSI:nil callbackNeeded:NO];
            }
        }
    }
}

- (void)stopScanDevListWithModel:(NSString *)model callback:(scanBlock)callback{
    NSMutableSet *set = nil;
    if(model.isEnable){
        set = [NSMutableSet setWithObject:model];
    }else if (self.realTimeCallbackEnabled){
       
    }
    [self callbackWithModels:set finished:YES callback:callback];
    [self stopScanBLEDevices];
}

- (void)callbackWithModel:(NSString *)model finished:(BOOL)finished callback:(scanBlock)callback{
    if (!callback) {
        return;
    }
    [self insertLocalBLEConnnectedDevicesIntoDiscoveredDevicesWithModel:model];
    callback(finished,[NSDictionary dictionaryWithDictionary:self.searchDevices]);
}

- (void)callbackWithModels:(NSSet *)models finished:(BOOL)finished callback:(scanBlock)callback{
    if (!callback) { return; }
    [self insertLocalBLEConnnectedDevicesIntoDiscoveredDevicesWithModels:models];
    callback(finished,[NSDictionary dictionaryWithDictionary:self.searchDevices]);
}

- (void)stopScanBLEDevices{
    //将搜索的block置空
    if(self.scanCallback){
        self.scanCallback = nil;
    }
    if (!self.isSearch || [BSDeviceManager shareInstance].numberOfDevices != 0) {
        return;
    }
    self.isSearch = NO;
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSBLEScanDeviceTimer];
    [_centralManager stopScan];
}

//停止扫描
- (void)stopMustScanBLEDevices{
    if(self.scanCallback){
        self.scanCallback = nil;
    }
    if (!self.isSearch ) {
        return;
    }
    self.isSearch = NO;
    [[BSGCDTimer shareInstance] cancelTimerWithName:kBSBLEScanDeviceTimer];
    [_centralManager stopScan];
}

- (void)connect:(BSDeviceBLE *)deviceBLE{
    if(!self.isBlePowerOn){
        return;
    }
    CBPeripheral *peripheral = deviceBLE.peripheral;
    //NSLog(@"待连接 peripheral: %p, state: %ld, delegate: %@, manager delegate: %@", peripheral, (long)peripheral.state, peripheral.delegate, _centralManager.delegate);
    if (!peripheral || peripheral.state == CBPeripheralStateConnected || peripheral.state == CBPeripheralStateConnecting ) {
        //如果不存在,或者已连接、正在连接中
        return;
    }
    NSLog(@"缓存设备～～开始连接  mac===%@  identifier===%@",deviceBLE.mac,peripheral.identifier);
    /** 特别说明一下连接的可选参数
       CBConnectPeripheralOptionNotifyOnConnectionKey
       填一个Bool值，指定后台连接外围设备时，是否告知系统，并弹窗提示
       CBConnectPeripheralOptionNotifyOnDisconnectionKey
       填一个Bool值，指定后台断开外围设备时，是否告知系统，并弹窗提示
       CBConnectPeripheralOptionNotifyOnNotificationKey
       填一个Bool值，指定系统是否对外围发过来的每一个通知都弹窗提示
       CBConnectPeripheralOptionEnabTransportBridgeingKey
       如果已经通过低功耗蓝牙连接，则可以桥接经典蓝牙的配置文件（GATT）
       CBConnectPeripheralOptionRequiresANCS
       填一个Bool值，设定连接设备时是否需要连接（ANCS）服务，接收推送服务
       CBConnectPeripheralOptionStarDelayKey
       填一个Bool，设置系统连接前是否要延迟
     */
    [_centralManager connectPeripheral:peripheral options:nil];
}

- (void)try2ConnectDevice:(BSCommonDevice *)device{
    NSLog(@"try2ConnectDevice");
    if (!device.bleDevice) {
        NSString *macAddress = device.identifier;
        NSString *uuidString = [BSBLEManager deviceUUIDWithMacAddress:macAddress];
        NSUUID *deviceUUID = [[NSUUID alloc] initWithUUIDString:uuidString];
        if (!deviceUUID) {
            return;
        }
        NSArray<CBPeripheral *> *peripherals = [_centralManager retrievePeripheralsWithIdentifiers:@[deviceUUID]];
        CBPeripheral *peripheral = peripherals.count > 0 ? peripherals.firstObject : nil;
        if (!peripheral || peripheral.state == CBPeripheralStateConnected) {
            return;
        }
        BSDeviceBLE *deviceBLE = [self bleWithLocalName:device.model];
        deviceBLE.peripheral = peripheral;
        deviceBLE.mac = macAddress;
        [self cacheDevice:deviceBLE mac:macAddress uuid:uuidString];
    }
    [self connect:device.bleDevice];
}

- (void)disconnect:(BSDeviceBLE *)deviceBLE{
    if (deviceBLE.peripheral) {
        NSLog(@"%@ 主动断开连接",deviceBLE.name);
        [_centralManager cancelPeripheralConnection:deviceBLE.peripheral];
    }
}

- (void)checkBluetoothStatusForVC:(UIViewController *)viewController{
    
        if ([BSCommonDevice isSimulator]) {
            //未登录、模拟器时不进行蓝牙权限检测
            return;
        }
//    if (![BSConfigManager sharedInstance].isLogin || [BSDeviceUtil isSimulator]) {
//        //未登录、模拟器时不进行蓝牙权限检测
//        return;
//    }
    //延时0.5s等待蓝牙权限获取回调
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self shouldShowBluetoothTipsForVC:viewController];
    });
}

- (BOOL)shouldShowBluetoothTipsForVC:(UIViewController *)viewController{
    if(TARGET_IPHONE_SIMULATOR == 1 && TARGET_OS_IPHONE == 1){
         //如果是模拟器
         return NO;
    }
    NSLog(@"//检测蓝牙的状态=======");
   
    if (!self.isAuthorized && self.isFirstAuthorized ) {
        
        
        /////  蓝牙弹框提示后面加上  2026-1-13
        
//        //弹框
//        NSString *title = [NSString stringWithFormat:NSLocalizedStringkey(@"allow_access_bluetooth_in_settings"),
//                           [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"]];
//        [BSCustomAlertView showWithTitle:title subTitle:nil leftBtnTit:NSLocalizedStringkey(@"str_cancel") rightBtnTit:NSLocalizedStringkey(@"my_setting") resultBlock:^(CustomAlertBtn alertBtn, id object) {
//            if (alertBtn == CustomAlertBtnRight) {
                [UIApplication OpenURLWithURLString:UIApplicationOpenSettingsURLString];
//            }
//        }];
        return YES;
    }
    
    //蓝牙打开
    if (!self.isBlePowerOn) {
        /////  tost 弹框提示后面加上  2026-1-13
//        [self showHint:NSLocalizedStringkey(@"please_open_ble") ];
        return YES;
    }
    return NO;
}

/// 根据 mac 查询 identifiers 或者 根据 identifiers 查询 mac
+ (NSString *)deviceUUIDWithMacAddress:(NSString *)macAddress{
    return [self deviceDataWithKey:macAddress];
}
/// 根据 identifiers 查询 mac
+ (NSString *)deviceMacWithIdentifiers:(NSString *)identifiers {
    if (!identifiers || identifiers.length == 0)  return nil;
    NSString *mac = [self deviceDataWithKey:identifiers];
    if (mac) return mac;
    //根据cAddress 地址获取 ud
    NSDictionary *cacheDict = [BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary];
    NSMutableDictionary *identityDic = [NSMutableDictionary dictionaryWithDictionary:cacheDict];
    NSArray *macs = [identityDic allKeysForObject:identifiers];
    if (macs.count > 0) mac = [macs firstObject];
    return mac;
}
/// 根据 mac 查询 identifiers 或者 根据 identifiers 查询 mac
+ (NSString *)deviceDataWithKey:(NSString *)key {
    if (!key || key.length == 0) return nil;
    NSDictionary *cacheDict = [BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary];
    NSMutableDictionary *identityDic = [NSMutableDictionary dictionaryWithDictionary:cacheDict];
    NSString *value = identityDic[key];
    return value;
}

+ (BSDeviceBLE *)bleDeviceWithMacAddress:(NSString *)macAddress{
    if(!macAddress || macAddress.length == 0) { return nil; }
    //根据cAddress 地址获取 ud
    NSDictionary *cacheDict = [BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary];
    NSMutableDictionary *identityDic = [NSMutableDictionary dictionaryWithDictionary:cacheDict];
    NSString *mac = macAddress.copy;
    NSString *deviceUUID = identityDic[mac];
    //根据ud 获取 外设
    BSDeviceBLE *device = [BSBLEManager shareInstance].discoveredDevices[deviceUUID];
    device.mac = mac;
    return device;
}

/// 更新设备mac地址
/// @param oldMac 原始的mac地址
/// @param newMac 新的mac地址
+ (void)updateBLEDeviceMacWithOldMac:(NSString *)oldMac mac:(NSString *)newMac {
    BSDeviceBLE *device = [self bleDeviceWithMacAddress:oldMac];
    NSDictionary *cacheDict = [BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary];
    NSMutableDictionary *identityDic = [NSMutableDictionary dictionaryWithDictionary:cacheDict];
    NSString *identifier = [identityDic objectForKey:oldMac] ?: device.peripheral.identifier;
    [identityDic removeObjectForKey:oldMac];
    identityDic[newMac] = device.identifier;
    if (identifier) identityDic[identifier] = newMac;
    device.mac = newMac;
    [BSUserDefaults setObject:identityDic forKey:kBSBLEDeviceIdentityDictionary];
}

+ (void)realTimeCallbackEnabled:(BOOL)enabled{
    NSLog(@"realTimeCallback : %@",enabled ? @"启用" : @"禁用");
    [BSBLEManager shareInstance].realTimeCallbackEnabled = enabled;
}

#pragma mark - Private methods

- (void)startScanWithTypes:(nullable NSArray<NSNumber *> *)types{
    if (!self.isSearch || !self.isBlePowerOn) {
        return;
    }
    NSMutableSet<NSString *> *uuidSet = nil;
    if (!types) {
        uuidSet = [NSMutableSet setWithArray:
                       @[kBSProductScanUUID
                       ]
        ];
    }else{
        //非共用的service uuid 集合
        uuidSet = [NSMutableSet setWithArray:@[kBSProductScanUUID]];
        NSString *serviceUUID = nil;
        for (NSNumber *type in types) {
            serviceUUID = self.typeServiceUUIDDict[type];
            if (serviceUUID && serviceUUID.length > 0)
            {
                [uuidSet addObject:serviceUUID];
            }
        }
    }
    NSArray<CBUUID *> *serviceUUIDs = [self serviceUUIDsWithUUIDs:uuidSet.allObjects];
    if (!serviceUUIDs) {
        return;
    }
    //在前台可以传nil扫描周围所有设备，后台时必须传Service UUIDs
    [_centralManager scanForPeripheralsWithServices:serviceUUIDs options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
    // [_centralManager scanForPeripheralsWithServices:nil options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @NO }];
}

- (nullable NSArray<CBUUID *> *)serviceUUIDsWithUUIDs:(NSArray<NSString *> *)uuids{
    if (!uuids || uuids.count == 0) {
        return nil;
    }
    NSMutableArray *serviceUUIDs = [NSMutableArray arrayWithCapacity:uuids.count];
    CBUUID *uuid = nil;
    for (NSString *uuidString in uuids) {
        uuid = [CBUUID UUIDWithString:uuidString];
        if (uuid) {
            [serviceUUIDs addObject:uuid];
        }
    }
    if (serviceUUIDs.count == 0) {
        return nil;
    }
    // NSLog(@"serviceUUIDsWithUUIDs - %@",uuids);
    return [NSArray arrayWithArray:serviceUUIDs];
}

- (void)stopScan{
    [_centralManager stopScan];
}

/// 生成设备BLE信息(不需要回调)
- (void)generateBLEDevice:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary *)advertisementData
                     RSSI:(NSNumber *)RSSI{
    [self generateBLEDevice:peripheral advertisementData:advertisementData RSSI:RSSI callbackNeeded:YES];
}

/// 生成设备BLE信息(扫描到设备时需要立即回调)
/// @param peripheral 外设
/// @param advertisementData 广播数据
/// @param RSSI rssi
/// @param callbackNeeded 是否回调
- (void)generateBLEDevice:(CBPeripheral *)peripheral
        advertisementData:(NSDictionary *)advertisementData
                     RSSI:(NSNumber *)RSSI
           callbackNeeded:(BOOL)callbackNeeded{
    NSString *identifier = peripheral.identifier.UUIDString;
    NSData *data = advertisementData[CBAdvertisementDataManufacturerDataKey];
    NSString *localName = advertisementData[CBAdvertisementDataLocalNameKey] ?: peripheral.name;
    
    NSMutableString *mac = [NSMutableString stringWithString:@""];
    NSMutableString *longMac = [NSMutableString stringWithString:@""];
    // if ([localName isEqualToString:kBSDeviceModelChargerStation]) {
         NSLog(@"identifier:%@,peripheral.name=%@,CBAdvertisementDataLocalNameKey=%@",peripheral.identifier,peripheral.name,advertisementData);
    // }
//     NSLog(@"identifier:%@,peripheral.name=%@,CBAdvertisementDataLocalNameKey=%@",peripheral.identifier,peripheral.name,advertisementData);
//     NSLog(@"dict %@",advertisementData) ;
    if (data.length >= 6) {
        UInt8 *command = (UInt8 *)[data bytes];
        /********************经典蓝牙双通道耳机设备*********************/
        /// 经典蓝牙  与 BLE名称转换
//        if ([localName isEqualToString:kBSDeviceModelBaseusBowieMA10sBLE]){
//            localName = kBSDeviceModelBaseusBowieMA10s;
//        }
//        else if ([localName isEqualToString:kBSDeviceModelBaseusBass1AddBLE]) {
//            localName = kBSDeviceModelBaseusBass1Add ;
//        }
        /********************经典蓝牙双通道耳机设备*********************/

        if ([self macDataIsHightLowFormatWithLocalName:localName]) {
            //大端模式
            for (NSInteger i = 0; i <= 5; i++) {
                [mac appendString:[[NSString stringWithFormat:@"%02x%@",command[i],(i == 5) ? @"" : @":"] uppercaseString]];
            }
        } else {
            //小端模式
            for (NSInteger i = 5; i >= 0; i--) {
                [mac appendString:[[NSString stringWithFormat:@"%02x%@",command[i],(i == 0) ? @"" : @":"] uppercaseString]];
            }
        }
        if (localName && localName.length > 0) {
            @autoreleasepool {
                /*
                 //以下方法遍历时
                 scanDeviceFinishedWithModel:filterOwned:devices:finished:callback:
                 Bugly上报崩溃信息 Collection <__NSSetM: 0x280b6c000> was mutated while being enumerated.
                 故此处重新创建 set
                 */
                NSMutableSet *macs = [NSMutableSet setWithSet:self.searchDevices[localName]];
                if (self.isSearch && identifier.length > 0 && mac.length > 0) {
                    [macs addObject:mac];
                }
                self.searchDevices[localName] = macs;
            }
        }
        
        BSDeviceBLE *device = self.discoveredDevices[identifier];
        if (device && (advertisementData.allKeys.count > 1)) {
            device.advertisementData = advertisementData;
            device.peripheral = peripheral;
            device.RSSI = RSSI;
        } else {
            //根据 ServiceUUIDs 进行
            NSArray * serviceUUIDs = advertisementData[CBAdvertisementDataServiceUUIDsKey];
            if (serviceUUIDs.count > 0 || localName.isEnable)
            {
                if (localName.isEnable) {
                    /* 后面的设备有 LocalName ，所以根据 LocalName 建模 */
                    device = [self bleWithLocalName:localName];
                } else if (serviceUUIDs.count > 0) {
                    /* 前面的某些防丢器和耳机没有 LocalName 所以需要用到 serviceUUID 建模 */
                    device = [self bleWithServiceUUID:[serviceUUIDs.firstObject UUIDString]];
                }
                if (!device) {
                    return;
                }
                device.mac = mac;
                device.longMac = longMac ;
                device.peripheral = peripheral;
                device.advertisementData = advertisementData;
                device.RSSI = RSSI;
                [self cacheDevice:device mac:mac uuid:identifier];
            }
        }
        //发送通知
        [[NSNotificationCenter defaultCenter] postNotificationName:kBSBluetoothDidDiscoverDevice object:nil];
        if(callbackNeeded && self.scanCallback && self.model && [self.model isEqualToString:localName]){
            [self callbackWithModel:localName finished:NO callback:self.scanCallback];
        }else if(self.realTimeCallbackEnabled && callbackNeeded && self.scanCallback){
            [self callbackWithModel:localName finished:NO callback:self.scanCallback];
        }
    }
    else {
        //NSLog(@"Name: %@, mac为空: %@",localName,data);
    }
//    NSLog(@"mac==== %@\n  dict %@",mac,advertisementData) ;
    if (longMac.length== 35) {
        [self autoConnectWithIdentifier:longMac mainIdentifier:mac];
    }
    else if (mac.length > 0) {
        [self autoConnectWithIdentifier:mac];
    }
}

- (void)cacheDevice:(BSDeviceBLE *)device mac:(NSString *)mac uuid:(NSString *)uuid{
    if ( !device || !mac.isEnable || !uuid.isEnable) {
        return;
    }
    NSDictionary *cacheDict = [BSUserDefaults objectForKey:kBSBLEDeviceIdentityDictionary];
    NSMutableDictionary *identityDic = [NSMutableDictionary dictionaryWithDictionary:cacheDict];
    identityDic[mac] = uuid;
    identityDic[uuid] = mac; // 一一对应
    [BSUserDefaults setObject:identityDic forKey:kBSBLEDeviceIdentityDictionary];
    // 加锁 防止数据错乱
    self.discoveredDevices[uuid] = device;
}

/// 自动连接
- (void)autoConnectWithIdentifier:(NSString *)identifier{
    [[BSDeviceManager shareInstance] autoConnectWithIdentifier:identifier];
}

- (void)autoConnectWithIdentifier:(NSString *)identifier mainIdentifier:(NSString*)mac{
    [[BSDeviceManager shareInstance] autoConnectWithIdentifier:identifier mainIdentifier:mac];
}

/// 后面的设备有 LocalName ，所以根据 LocalName 建模
- (BSDeviceBLE *)bleWithLocalName:(NSString *)localName
{
    BSDeviceType deviceType = [self bleIsDeviceTypeWithLocalName:localName];
    NSString *className = self.typeBLENameDict[@(deviceType)];
    if (!className && localName && localName.length > 0) {
        className = self.modelBLENameDict[localName];
    }
    if (!className || className.length == 0) {
        return nil;
    }
    BSDeviceBLE *device = nil;
    Class class = NSClassFromString(className);
    if ([class isSubclassOfClass:BSDeviceBLE.class]) {
        device = [BSDeviceBLE modelWithClass:class type:deviceType];
        device.name = localName;
    }
    return device;
}

/// 前面的某些防丢器和耳机没有 LocalName 所以需要用到 serviceUUID 建模
- (BSDeviceBLE *)bleWithServiceUUID:(NSString *)serviceUUID{
    BSDeviceBLE *device = nil;
    //耳机
//    if ([serviceUUID isEqualToString:kBSEarphoneServiceUUID]) {
//        device = [BSEarphoneBLE modelWithType:BSDeviceTypeEarphone];
//    } else if ([serviceUUID isEqualToString:kBSTagServiceUUID]) {
//        device = [BSTagBLE modelWithType:BSDeviceTypeOutdoorPower];
//    }
    return device;
}

- (BSDeviceType)bleIsDeviceTypeWithLocalName:(NSString *)localName{
    if (!localName.isEnable) {
        return BSDeviceTypeOutdoorPower;
    }
    NSNumber *typeNum = [self.modelTypeDict objectForKey:localName];
    return typeNum ? [typeNum integerValue] : BSDeviceTypeOutdoorPower;
}

- (nullable NSArray<NSNumber *> *)deviceTypesWithModel:(NSString *)model{
    if (!model || model.length == 0) {
        return nil;
    }
    return [self deviceTypesWithModels:@[model]];
}

- (nullable NSArray<NSNumber *> *)deviceTypesWithModels:(NSArray<NSString *> *)models{
    NSMutableArray<NSNumber *> *types = [NSMutableArray array];
    for (NSString *model in models) {
        [types addObject:@([self bleIsDeviceTypeWithLocalName:model])];
    }
    return types;
}

#pragma mark - CBCentralManagerDelegate

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI{
//    if ([peripheral.name isEqualToString:@"AirGo AS01"] || [peripheral.name isEqualToString:@"Bowie W04 Plus"] ) {
//        NSLog(@"didDiscoverPeripheral: %p, peripheral.identifier: %@, peripheral.name: %@, peripheral.state: %ld",peripheral, peripheral.identifier,peripheral.name,(long)peripheral.state);
//    }
    [self generateBLEDevice:peripheral advertisementData:advertisementData RSSI:RSSI];
}

//外设连接失败
- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSLog(@"外设连接失败～～～ peripheral.identifier: %@ , peripheral.name%@ , error: %@", peripheral.identifier, peripheral.name ?: @"", error);
    NSString *identifier = peripheral.identifier.UUIDString;
    BSDeviceBLE *device = self.discoveredDevices[identifier];
    //NSLog(@"device 记录的设备== %p  外设备 == %p",device.peripheral, peripheral) ;
    device.peripheral = peripheral;
    [device didDisconnected];
}

//外设连接成功
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral{
    NSString *identifier = peripheral.identifier.UUIDString;
    NSLog(@"外设连接成功～～～ peripheral.identifier: %@, peripheral.name%@", peripheral.identifier, peripheral.name ?: @"");
    BSDeviceBLE *device = self.discoveredDevices[identifier];
    //NSLog(@"device 记录的设备== %p  外设备 == %p",device.peripheral, peripheral) ;
    device.peripheral = peripheral;
    [device discoverServices];
}

//外设断开连接
- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error{
    NSString *identifier = peripheral.identifier.UUIDString;
    NSLog(@"peripheral didDisconnectPeripheral :peripheral.identifier: %@, peripheral.name: %@ , error: %@",peripheral.identifier, peripheral.name ?: @"",error);
    BSDeviceBLE *device  = self.discoveredDevices[identifier];
    //NSLog(@"device 记录的设备== %p  外设备 == %p",device.peripheral,peripheral) ;
    device.peripheral = peripheral;
    [device didDisconnected];
}

//此方法是什么用途 暂时搁置 这个还是有用处的
- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict{
    NSLog(@"centralManager willRestoreState : %@", dict);

}

//监听蓝牙的状态
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSLog(@"//监听蓝牙的状态=======") ;
    self.isFirstAuthorized = YES ;
    switch (central.state) {
        case CBManagerStatePoweredOff:
        case CBManagerStateUnauthorized:
        case CBManagerStateResetting:
        {
            [self stopScanBLEDevices];
            //未开启
            if (central.state == CBManagerStatePoweredOff||
                central.state == CBManagerStateUnauthorized) {
               [[NSNotificationCenter defaultCenter] postNotificationName:kBSBLEPoweredOffNotification object:nil userInfo:nil];
                if (central.state == CBManagerStatePoweredOff) {
                    self.isBlePowerOn = NO;
                    self.isAuthorized = YES;
                }
                if (central.state == CBManagerStateUnauthorized) {
                    self.isBlePowerOn = NO;
                    self.isAuthorized = NO;
                }
            }
            // TODO: -- disconnect Ble successfully notification
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSBLEDidDisconnectNotification object:nil userInfo:nil];
        }
            break;
        case CBManagerStatePoweredOn: {
            self.isBlePowerOn = YES;
            self.isAuthorized = YES;
            [self scanBLEDevices];
            [[NSNotificationCenter defaultCenter] postNotificationName:kBSBLEDidPowerONNotification object:nil userInfo:nil];
        }
            break;
        default:
            [self stopScanBLEDevices];
            break;
    }
}

////BLE 广播地址FF： 大端模式
- (BOOL)macDataIsHightLowFormatWithLocalName:(NSString *)localName {
    return  YES;
//    return ([localName isEqualToString:[BSCommonDevice modelWithDeviceSubType:BSDeviceSubTypeSmartWashingMachine]] ||
//            [localName isEqualToString:[BSCommonDevice modelWithDeviceSubType:BSDeviceSubTypeFridgeBSTS015]]
//            );
}

#pragma mark - Setters && Getters

- (NSMutableDictionary<NSString *,BSDeviceBLE *> *)discoveredDevices{
    if (!_discoveredDevices) {
        _discoveredDevices = @{}.mutableCopy;
    }
    return _discoveredDevices;
}

- (NSMutableDictionary<NSString *,NSMutableSet<NSString *> *> *)searchDevices{
    if (!_searchDevices) {
        _searchDevices = @{}.mutableCopy;
    }
    return _searchDevices;
}

- (NSDictionary<NSNumber *,NSString *> *)typeServiceUUIDDict{
    if(!_typeServiceUUIDDict){
        _typeServiceUUIDDict = @{
            @(BSDeviceTypeOutdoorPower)          : kBSProductScanUUID,
        };
    }
    return _typeServiceUUIDDict;
}

- (NSDictionary<NSString *,NSNumber *> *)modelTypeDict{
    if (!_modelTypeDict) {
        _modelTypeDict = @{
            /* 防丢器 */
            kBSDeviceModelTag          : @(BSDeviceTypeOutdoorPower),
        };
    }
    return _modelTypeDict;
}

/// 型号-BLE类名
- (NSDictionary<NSNumber *,NSString *> *)typeBLENameDict{
    if (!_typeBLENameDict) {
        _typeBLENameDict = @{
            /* 户外电源  */
            @(BSDeviceTypeOutdoorPower)          : NSStringFromClass(BSPowerBankBLE.class),
        };
    }
    return _typeBLENameDict;
}

- (NSDictionary<NSString *,NSString *> *)modelBLENameDict{
    if (!_modelBLENameDict) {
        _modelBLENameDict = @{
            /* 户外电源  */
            kBSDeviceModelTag : NSStringFromClass(BSPowerBankBLE.class),
        };
    }
    return _modelBLENameDict;
}

@end
