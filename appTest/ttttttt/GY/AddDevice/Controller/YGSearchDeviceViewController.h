//
//  YGSearchDeviceViewController.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/29.
//

#import "YGTableViewController.h"
#import "YGAddDeviceModel.h"
NS_ASSUME_NONNULL_BEGIN

/// 自动搜索  

@interface YGSearchDeviceViewController : YGTableViewController
@property(nonatomic,strong) NSDictionary<NSString *,DeviceTypeModel *> *deviceTypeDict;
@end

NS_ASSUME_NONNULL_END
