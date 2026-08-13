//
//  BSBLEDefine.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/12.
//

#ifndef BSBLEDefine_h
#define BSBLEDefine_h

//Baseus 产品统一标识 UUID
//#define kBSProductScanUUID                      @"53527AA4-29F7-AE11-4E74-997334782568"
//#define kBSProductServiceUUID                   @"53527AA4-29F7-AE11-4E74-997334782568"
//#define kBSProductWriteCharacteristicUUID       @"EE684B1A-1E9B-ED3E-EE55-F894667E92AC"
//#define kBSProductNotifyCharacteristicUUID      @"654B749C-E37F-AE1F-EBAB-40CA133E3690"

#define kBSProductScanUUID                      @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define kBSProductServiceUUID                   @"6E400001-B5A3-F393-E0A9-E50E24DCCA9E"
#define kBSProductWriteCharacteristicUUID       @"6E400002-B5A3-F393-E0A9-E50E24DCCA9E"
#define kBSProductNotifyCharacteristicUUID      @"6E400003-B5A3-F393-E0A9-E50E24DCCA9E"
/********************设备型号********************/
static NSString *const kBSDeviceModelTag     = @"Baseus T1";
/********************备型号********************/
static NSString *const kBSDeviceModelAirNora       = @"Baseus AirNora";
///设备类型,对应后台返回数据,顺序不可更改
typedef NS_ENUM(NSInteger, BSDeviceType) {
    BSDeviceTypeOutdoorPower          = 1, ///<  类型
};

///设备子类型,与model一一对应，便于标识
typedef NS_ENUM(NSInteger, BSDeviceSubType) {
    BSDeviceSubTypeTag,   //设备子型号
};

typedef NS_ENUM(NSInteger, BSDeviceCommunicationType) {
    BSDeviceCommunicationTypeBluetooth,//蓝牙类型
};

#endif /* BSBLEDefine_h */
