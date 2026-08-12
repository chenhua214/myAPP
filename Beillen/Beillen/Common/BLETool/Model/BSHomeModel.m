//
//  BSHomeModel.m
//  JDKJAPP
//
//  Created by chen on 2026/1/13.
//

#import "BSHomeModel.h"
#import "BSDeviceManager.h"
#import "NSObject+LKModel.h"    /// 后面加上
#import "LKDBHelper.h"
@implementation BSHomeModel

@end

@implementation BSHomeDeviceModel

#pragma mark- LKDB Helper

/// LKDBHelper 重写,实现父类属性的存储
+ (BOOL)isContainParent{
    return YES;
}

/// 存入数据库的字段(白名单)
+ (NSDictionary *)getTableMapping{
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithDictionary:[super getTableMapping]];
    
    
    /// 后面处理
    [dict addEntriesFromDictionary:@{
        @"sn":  LKSQL_Mapping_Inherit,
        @"bindTime": LKSQL_Mapping_Inherit,
    }];
    return dict;
}




- (BOOL)isBLEConnected{
    return [[BSDeviceManager shareInstance] isConnectedWithIdentifier:self.sn];
}

//- (BOOL)mqConnected {
//    return [[BSDeviceManager shareInstance] isMqConnectedWithIdentifier:self.sn];
//}


//- (BOOL)deviceWorkState {
//    return [[BSDeviceManager shareInstance] isWorkStateWithIdentifier:self.sn];
//}

- (NSString *)identifier{
    NSString *identifier = [super identifier];
    if (!identifier || identifier.length == 0) {
        identifier = self.sn;
    }
    return identifier;
}


- (void)syncData2Device:(BSCommonDevice *)device{
    if(!self || !device){
        return;
    }
    device.model        = self.model;
    device.started      = self.started;
    device.deviceImgUrl = self.deviceImgUrl;
//    device.mobileAlarm  = self.params.mobileAlarm.integerValue;
//    device.latitude  = self.latitude;
//    device.longitude = self.longitude;
//    device.position  = self.position;
    device.shared    = self.shared;
    device.accounts  = self.accounts;
    device.shareId   = self.shareId;
    device.accountId = self.accountId;
    device.name = self.name;
    device.prodName = self.prodName;
    device.categoryId = self.categoryId;
    device.versionCode = self.versionCode;
    device.softVersion = self.softVersion;
}

@end

@implementation BSHomeDataModel

+ (NSString *)getPrimaryKey{
    return @"greetings";
}

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"devices" : [BSHomeDeviceModel class],
        //        @"banners" : [BSHomeBannerModel class],
        //        @"homes"   : [BSHomeTitlesModel class]
    };
}
@end


@implementation BSHomeDeviceModelList

@end
