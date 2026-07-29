//
//  YGAddDeviceModel.m
//  JDKJAPP
//
//  Created by chenyi on 2026/7/13.
//

#import "YGAddDeviceModel.h"
@class DeviceTypeModel;
@implementation YGAddDeviceModel

@end


@implementation DeviceTypeModel
-(void)initModelwithString:(NSString*)name;
{
//    self.prodName = name;
    self.model = name;
    self.prodName = [NSString stringWithFormat:@"1_%@",name];
    self.type = BSDeviceTypeOutdoorPower;
}


@end
