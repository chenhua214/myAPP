//
//  YGAddDeviceModel.h
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class DeviceTypeModel;
@interface YGAddDeviceModel : NSObject
/// 产品名称
@property(nonatomic,  copy) NSString *name;
/// 设备类型
@property(nonatomic,assign) BSDeviceType type;
@property(nonatomic,strong) NSArray <DeviceTypeModel*>*products;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) NSInteger isSelectNumber;
@property(nonatomic,assign) NSInteger categoryId;
/// 图标
@property(nonatomic,  copy) NSString *icon;
@end


@interface DeviceTypeModel : NSObject
/// 产品名称
@property(nonatomic,  copy) NSString *prodName;
/// 型号
@property(nonatomic,  copy) NSString *model;
/// 图标
@property(nonatomic,  copy) NSString *icon;
/// 图标  大图
@property(nonatomic,  copy) NSString *iconLarge;
/// 设备类型
@property(nonatomic,assign) BSDeviceType type;

/// 是否支持访客模式 0-是 1-否
@property(nonatomic,assign) NSInteger visitor;

/// 视频预览图
@property(nonatomic,  copy) NSString *videoPic;
/// 视频URLs
@property(nonatomic,  copy) NSArray<NSString *> *videoUrl;
@property(nonatomic,assign) BOOL isSelect;
/// 是否是自动绑定流程
@property(nonatomic,assign) BOOL isAutoBindProcess;
-(void)initModelwithString:(NSString*)name;

@end


NS_ASSUME_NONNULL_END
