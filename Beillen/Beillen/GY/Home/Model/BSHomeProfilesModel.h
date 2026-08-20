//
//  BSHomeProfilesModel.h
//  Beillen
//
//  Created by chenyi on 2026/8/16.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, BSHomePageEventsType) {
    BSHomePageEventsTypeGoLogin,     ///< 去登录
    BSHomePageEventsTypeGoUser,      ///< 去个人中心
    BSHomePageEventsTypeToMessage,   ///< 去消息中心
    BSHomePageEventsTypeAddDevice,   ///< 去添加设备
    BSHomePageEventsTypeBanner,      ///< Banner 图被点击
    BSHomePageEventsTypeCellSwitch,  ///< Cell 中的按钮点击
    BSHomePageEventsTypeCellTouch,   ///< Cell 被点击
};


@interface BSHomeProfilesModel : NSObject

@end

NS_ASSUME_NONNULL_END
