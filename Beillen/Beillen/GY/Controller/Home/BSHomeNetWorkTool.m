//
//  BSHomeNetWorkTool.m
//  Beillen
//
//  Created by chenyi on 2026/8/24.
//

#import "BSHomeNetWorkTool.h"
#import "BSDeviceDBHelper.h"
@implementation BSHomeNetWorkTool


+ (void)unbindDeviceWithParam:(NSDictionary *)param
                      success:(Completion)success
                         fail:(Completion)fail{
    if (IS_GUEST_MODE) {
        //访客模式,删除设备,从本地数据库中移除
        [BSDeviceDBHelper deleteDeviceWithModel:param[@"model"] sn:param[@"sn"] callback:^(BOOL result, id  _Nullable responseData) {
            if (result) {
                if (success) {
                    NSDictionary *responseDict = @{@"code":@(0),@"status":@(0)};
                    success(responseDict);
                }
            }else{
                if (fail) { fail(nil); }
            }
        }];
        return;
    }

}



@end
