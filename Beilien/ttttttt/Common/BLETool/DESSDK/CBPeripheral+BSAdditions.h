//
//  CBPeripheral+BSAdditions.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/13.
//

#import <CoreBluetooth/CoreBluetooth.h>

NS_ASSUME_NONNULL_BEGIN

@interface CBPeripheral (BSAdditions)
- (nullable CBCharacteristic *)characteristicWithUUID:(NSString *)uuid serviceUUID:(NSString *)serviceUUID;
@end

NS_ASSUME_NONNULL_END
