//
//  CBPeripheral+BSAdditions.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import "CBPeripheral+BSAdditions.h"

@implementation CBPeripheral (BSAdditions)


- (nullable CBCharacteristic *)characteristicWithUUID:(NSString *)uuid serviceUUID:(NSString *)serviceUUID{
    for (CBService *service  in self.services) {
        if ([service.UUID.UUIDString isEqualToString:serviceUUID]) {
            for (CBCharacteristic *characteristic in service.characteristics) {
                if ([characteristic.UUID.UUIDString isEqualToString:uuid]) {
                    return characteristic;
                }
            }
        }
    }
    return nil;
}

@end
