//
//  BSBindDeviceViewModel.h
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class BSCommonDevice;
@class DeviceTypeModel;
@class BSDeviceBLE;

typedef void(^connectBlock)(BOOL result, DeviceTypeModel *_Nullable typeModel, BSCommonDevice *_Nullable device);

@interface BSBindDeviceViewModel : NSObject
- (void)bindDevice:(BSDeviceBLE *)bleDevice type:(DeviceTypeModel *)typeModel callback:(nullable connectBlock)callback;
@end

NS_ASSUME_NONNULL_END
