//
//  BSLoginModel.m
//  BaseusAPP
//
//  Created by  wang on 2021/1/31.
//

#import "BSLoginModel.h"

@implementation BSAccountInfoPointsDtoModel

@end

@implementation BSAccountInfoModel

+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"memberPointsDto" : [BSAccountInfoPointsDtoModel class],
        @"memberEquityDto" : [BSAccountInfoPointsDtoModel class],
    };
}
//
//+ (NSDictionary *)modelCustomPropertyMapper {
//    return @{
//        @"showGuess"            : @"show_guess",
//        @"upReload"             : @"up_reload",
//        @"hasMorePage"          : @"has_more_page",
//        @"productInfo"          : @"product_list_head",
//    };
//}

@end

@implementation BSLoginModel
+ (NSDictionary *)modelContainerPropertyGenericClass{
    return @{
        @"accountInfo" : [BSAccountInfoModel class],
    };
}
@end

@implementation BSRegisterMessageModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{
        @"messageT"            : @"message",
    };
}


@end

