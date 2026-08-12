//
//  YGSearchDeviceModel.h
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BSDeviceBLE;
@class DeviceTypeModel;

@interface YGSearchDeviceModel : NSObject
@property(nonatomic,strong)BSDeviceBLE *bleDevice;
@property(nonatomic,strong)DeviceTypeModel *typeModel;
@property(nonatomic,assign)BOOL checked;
@end

NS_ASSUME_NONNULL_END
