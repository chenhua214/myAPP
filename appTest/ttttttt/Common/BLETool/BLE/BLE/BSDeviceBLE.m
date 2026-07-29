//
//  BSDeviceBLE.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#import "BSDeviceBLE.h"
#import "BSBLEManager.h"
#import "BSBLECommandModel.h"
#import "CBPeripheral+BSAdditions.h"


NSString *const kBSBLEDidConnectNotification        = @"BSBLEDidConnectNotification";
NSString *const kBSBLEDidDisconnectNotification     = @"BSBLEDidDisconnectNotification";
NSString *const kBSBLEDidIdentifyAuthNotification   = @"BSBLEDidIdentifyAuthNotification";
NSString *const kBSBLEDidPowerONNotification        = @"BSBLEDidPowerONNotification";
NSString *const kBSBLEPoweredOffNotification        = @"BSBLEPoweredOffNotification";

NSString *const kBSBluetoothDidDiscoverDevice       = @"BluetoothDidDiscoverDevice";

@interface BSDeviceBLE ()
/// 总共的服务个数
@property(nonatomic,assign) NSInteger totalServicesCount;
/// 总共发现的服务个数
@property(nonatomic,assign) NSInteger totalDiscoveredServiceCount;
/// 写指令控制器
@property(nonatomic,strong)BSBLECommandControl *commandControl;
@end


@implementation BSDeviceBLE

#pragma mark- Public methods

- (BOOL)writeCommand:(NSData *)data{
    BOOL inQueue = [BSBLECommandModel isExecuteCommandInQueue:data model:self.name type:self.type];
    if (inQueue) {
        return [self executeCommand:data inQueue:YES];
    }
    return NO;
}

- (BOOL)executeCommand:(NSData *)data inQueue:(BOOL)inQueue{
    //默认返回NO,如有需要,请在子类中重写
    return NO;
}

- (BOOL)executeCommandInQueue:(NSData *)data{
    [self.commandControl executeCommandWithData:data];
    return YES;
}

- (void)clearAllCommand{
    if(_commandControl && [_commandControl respondsToSelector:@selector(clearAllCommand)]){
        [_commandControl clearAllCommand];
        //释放
        _commandControl = nil;
    }
}

- (void)didConnected{
    // 发送通知
    CBCharacteristic *characteristic = [self characteristicWithUUID:kBSProductNotifyCharacteristicUUID serviceUUID:kBSProductServiceUUID];
    
    if (characteristic && (characteristic.properties & CBCharacteristicPropertyNotify) ) {
        NSLog(@"setNotifyValue: %@", characteristic);
        [self.peripheral setNotifyValue:YES forCharacteristic: characteristic];
    }else {
        NSLog(@"unavailable notify characteristic");
    }
    // 重新获取 write 服务 特征
    _characteristic = [self characteristicWithUUID:kBSProductWriteCharacteristicUUID serviceUUID:kBSProductServiceUUID];
    NSUInteger maximumWriteValueWithResponse = [self.peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithResponse];
       NSUInteger maximumWriteValueWithoutResponse = [self.peripheral maximumWriteValueLengthForType:CBCharacteristicWriteWithoutResponse];
       _maximumWriteValue = MIN(maximumWriteValueWithResponse, maximumWriteValueWithoutResponse);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnected)]) {
        [self.delegate didConnected];
    }
}

- (void)didDisconnected{
    NSLog(@"%@:%@,断开连接!!!  mac==%@",self.name, self.identifier,self.mac);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didDisconnected)]) {
        [self.delegate didDisconnected];
    }
}

- (void)setNeedUpdateRSSI{
    [self.peripheral readRSSI];
}

- (void)discoverServices{
    [self.peripheral discoverServices:nil];
}

- (void)cancelPeripheralConnection{
    [[BSBLEManager shareInstance] disconnect:self];
}

- (CBCharacteristic *)characteristicWithUUID:(NSString *)uuid serviceUUID:(NSString *)serviceUUID{
    return self.peripheral ? [self.peripheral characteristicWithUUID:uuid serviceUUID:serviceUUID] : nil;
}

+ (BSDeviceBLE *)deviceFromMac:(NSString *)macAddress{
    return [BSBLEManager bleDeviceWithMacAddress:macAddress];
}

#pragma mark- Public methods

- (void)executeCommand:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic {
    if (!data || !characteristic || !self.peripheral) return;
    if (characteristic.properties & CBCharacteristicPropertyWrite) {
        [self executeCommand:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
    } else if (characteristic.properties & CBCharacteristicPropertyWriteWithoutResponse) {
        [self executeCommand:data forCharacteristic:characteristic type:CBCharacteristicWriteWithoutResponse];
    } else {
        NSLog(@"该设备的characteristic不支持写入");
    }
}

- (void)executeCommand:(NSData *)data forCharacteristic:(CBCharacteristic *)characteristic type:(CBCharacteristicWriteType)type{
    if (!self.peripheral || !characteristic) {
        NSLog(@"executeCommand for peripheral: %@ : characteristic: %@", self.peripheral, characteristic);
        return;
    }
    NSLog(@"self write mac === %@ : %@",self.mac,data);
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        [self.peripheral writeValue:data forCharacteristic:characteristic type:type];
    });
}

#pragma mark- Util

- (BOOL)isMatchWithData:(NSData *)data{
    if(!_commandControl || !data || data.length < 2){
        return NO;
    }
    BOOL isMatch = NO;
    @try {
        //代表成功回调
        isMatch = [_commandControl isMatchWithData:[data subdataWithRange:NSMakeRange(0, 2)]];
    } @catch (NSException *exception) {}
    return isMatch;
}

#pragma mark - CBPeripheralDelegate

//服务
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error{
    NSInteger count = peripheral.services.count;
    for (CBService *service in peripheral.services) {
        //NSLog(@"peripheral %@ characteristic.UUID is %@",peripheral.name, service.UUID.UUIDString);
        [peripheral discoverCharacteristics:nil forService:service];
    }
    _totalServicesCount = count ;
    _totalDiscoveredServiceCount = 0;
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error{
    _totalDiscoveredServiceCount += 1;
    if (_totalDiscoveredServiceCount == _totalServicesCount) {
        [self didConnected];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    NSLog(@"didWriteValueForCharacteristic: name: %@ , value:%@",peripheral.name,characteristic.value);
    if (self.delegate && [self.delegate respondsToSelector:@selector(didWriteValueWithError:)]) {
        [self.delegate didWriteValueWithError:error];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didWriteValueWithError:characteristic:)]) {
        [self.delegate didWriteValueWithError:error characteristic:characteristic];
    }
}

//发现更新设备
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error{
    
    
    NSLog(@"didUpdateValueForCharacteristic: name: %@ , value:%@",peripheral.name,characteristic.value);
    
    if (!characteristic || !characteristic.value) {
        return;
    }
    if (self.didResponseCommandCallback && [self isMatchWithData:characteristic.value.copy]) {
        self.didResponseCommandCallback();
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateValue:)]) {
        [self.delegate didUpdateValue:characteristic.value];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(didUpdateValue:characteristic:)]) {
        [self.delegate didUpdateValue:characteristic.value characteristic:characteristic];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(NSError *)error{
    if (error) {
        return;
    }
    self.RSSI = RSSI;
    if (self.delegate && [self.delegate respondsToSelector:@selector(didReadRSSI:)]) {
        [self.delegate didReadRSSI:RSSI];
    }
}

#pragma mark - Setters && Getters

- (NSString *)identifier{
    return self.peripheral.identifier.UUIDString;
}

- (void)setPeripheral:(CBPeripheral *)peripheral{
    if (_peripheral == peripheral) {
        return;
    };
    //NSLog(@"device 赋值BLE name == %@  identifier== %@\n 记录的设备== %p  外设备 == %p  name == %@  identifier== %@",_peripheral, _peripheral.name,_peripheral.identifier, peripheral, peripheral.name, peripheral.identifier);
    _peripheral = peripheral;
    if (!_peripheral.delegate || _peripheral.delegate != self) {
        _peripheral.delegate = self;
    }
}

- (NSString *)name{
    NSString *bleName = self.advertisementData[CBAdvertisementDataLocalNameKey] ? : self.peripheral.name;
    
    /********************经典蓝牙双通道耳机设备*********************/
    ///  需要把 bLE的名称强制转换为 经典蓝牙的名称
    /********************经典蓝牙双通道耳机设备*********************/
    return bleName;
}

- (BOOL)isConnected{
    return self.peripheral && (self.peripheral.state ==  CBPeripheralStateConnected);
}

- (BSBLECommandControl *)commandControl{
    if (!_commandControl) {
        _commandControl = [[BSBLECommandControl alloc] initWithBLEDevice:self];
    }
    return _commandControl;
}

- (CBCharacteristic *)characteristic{
    if (!_characteristic) {
        _characteristic = [self characteristicWithUUID:kBSProductWriteCharacteristicUUID serviceUUID:kBSProductServiceUUID];
    }
    return _characteristic;
}


@end
