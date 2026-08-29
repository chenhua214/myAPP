//
//  BSHomeNetWorkTool.h
//  Beillen
//
//  Created by chenyi on 2026/8/24.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
//@class BSDeviceParamsModel;


@interface BSHomeNetWorkTool : NSObject
+ (void)unbindDeviceWithParam:(NSDictionary *)param
                      success:(Completion)success
                         fail:(Completion)fail;
@end

NS_ASSUME_NONNULL_END
