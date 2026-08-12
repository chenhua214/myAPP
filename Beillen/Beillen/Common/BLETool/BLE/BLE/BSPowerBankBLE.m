//
//  BSPowerBankBLE.m
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSPowerBankBLE.h"

@implementation BSPowerBankBLE

- (void)didConnected {
    //连接后设置读取信息通知
    CBCharacteristic *characteristic = [self characteristicWithUUID:kBSProductNotifyCharacteristicUUID serviceUUID:kBSProductServiceUUID];
    if (!characteristic) {
        return;
    }
    [self.peripheral setNotifyValue:YES forCharacteristic:characteristic];
    NSLog(@"setNotifyValue : YES");
    if (self.delegate && [self.delegate respondsToSelector:@selector(didConnected)]) {
        [self.delegate didConnected];
    }
    self.isConnected = YES;
}

- (void)didDisconnected {
    [super didDisconnected];
    self.isConnected = NO;
}

- (BOOL)writeCommand:(NSData *)data{
    if(![super writeCommand:data]){
        [self executeCommand:data forCharacteristic:self.characteristic type:CBCharacteristicWriteWithoutResponse];
    }
    return YES;
}

#pragma mark- Setters && Getters

- (CBCharacteristic *)characteristic{
    CBCharacteristic *characteristic = [super characteristic];
    if (!characteristic) {
        characteristic = [self characteristicWithUUID:kBSProductWriteCharacteristicUUID serviceUUID:kBSProductServiceUUID];
    }
    return characteristic;
}

@end
