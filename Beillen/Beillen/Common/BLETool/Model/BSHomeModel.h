//
//  BSHomeModel.h
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import <Foundation/Foundation.h>
#import "BSCommonDevice.h"
NS_ASSUME_NONNULL_BEGIN

@interface BSHomeModel : NSObject

@end


@interface BSHomeDeviceModel : BSCommonDevice
@property (nonatomic,   copy) NSString *sn;// 设备号(大写)
@property (nonatomic, assign) double bindTime;//设备绑定时间
@property (nonatomic, assign) BOOL hasReport;// 是否有断连记录

@property (nonatomic, assign) BOOL isBLEConnected;// 是否设备连接
@property (nonatomic, assign) BOOL isLowBttery;//是否低电量
@property (nonatomic, assign,readonly) BOOL isNoDisturb;//是否免打扰
//@property (nonatomic, assign) BOOL mqConnected;// 设备是否连接mq
//@property (nonatomic, assign) BOOL isBleAndMqConnected;// 设备通过BLE或者MQtt连接上
//@property (nonatomic, assign) BOOL deviceWorkState;// 设备是否处于开机工作状态

@property (nonatomic, assign) NSInteger upgrade;// 是否需要升级，0=不需要  1=需要
@property (nonatomic, assign) CGFloat cellHeight;
- (void)syncData2Device:(BSCommonDevice *)device;

@end

@interface BSHomeDataModel : BSBaseModel
//@property (nonatomic, strong) NSArray<BSHomeTitlesModel *> *homes;
@property (nonatomic, strong) NSArray<BSHomeDeviceModel *> *devices;
//@property (nonatomic, strong) NSArray<BSHomeBannerModel *> *banners;
@property (nonatomic,   copy) NSString *greetings; //欢迎语
@end

@interface BSHomeDeviceModelList : NSObject
@property (nonatomic,   copy) NSString *categoryName;
@property (nonatomic, strong) NSArray<BSHomeDeviceModel *> *devices;
@end

NS_ASSUME_NONNULL_END
