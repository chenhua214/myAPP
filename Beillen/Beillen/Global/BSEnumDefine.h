//
//  BSEnumDefine.h
//  Beillen
//
//  Created by skychi on 2022/5/12.
//

#ifndef BSEnumDefine_h
#define BSEnumDefine_h

typedef NS_ENUM(NSInteger,BSCellRectCorner) {
    BSCellRectCornerNone,
    BSCellRectCornerTopLeft,
    BSCellRectCornerTopRight,
    BSCellRectCornerBottomLeft,
    BSCellRectCornerBottomRight,
    BSCellRectCornerTopBottomLeft,
    BSCellRectCornerTopBottomRight,
    BSCellRectCornerTopLeftRight,
    BSCellRectCornerBottomLeftRight,
    BSCellRectCornerAllCorners,
};

typedef NS_ENUM(NSInteger, BSHomeUserInfoAction) {
    BSHomeUserInfoActionUserInfo = 1,//用户信息
    BSHomeUserInfoActionMessage,//消息按钮
    BSHomeUserInfoActionAdd,//添加设备
    BSHomeUserInfoAction2Login,//去登录
};

typedef NS_ENUM(NSInteger,BSUserInfoCellType) {
    BSUserInfoCellTypeAccount,
    BSUserInfoCellTypeAvatar,
    BSUserInfoCellTypeNickName,
};

/// 耳机类型
typedef NS_ENUM(NSUInteger, BSEarphoneViewEarType) {
    BSEarphoneViewEarTypeLeft,  // 左耳
    BSEarphoneViewEarTypeRight, // 右耳
    BSEarphoneViewEarTypeDual, // 双耳
};

/// 空间音效模式
typedef NS_ENUM(NSInteger, BSPanoramicSoundMode) {
    BSPanoramicSoundModeNormal = 0, // 正常模式
    BSPanoramicSoundModeMusic, // 音乐模式
    BSPanoramicSoundModeCinema, // 影院模式
    BSPanoramicSoundModeGame, // 游戏模式
    BSPanoramicSoundModeFixation, // 固定模式
    BSPanoramicSoundModeHead, // 头部追踪模式
    BSPanoramicSoundModeIgnore = 255,//忽略,不做处理,
};

/// 氛围灯模式
typedef NS_ENUM(NSUInteger, BSAtmosphereLampMode) {
    BSAtmosphereLampModeDefault = 0, // 默认/关闭模式
    BSAtmosphereLampModeCustom  = 1, // 自定义
    BSAtmosphereLampModetype_Close   = 2,  //关闭模式
    BSAtmosphereLampModetype_AI      = 3,  //智能模式
    BSAtmosphereLampModetype_Unknown = 200,  //没有定义、
};

typedef NS_ENUM(NSUInteger, BSAtmosphereLampColor) {
    BSAtmosphereLampColorDefault = 255,//默认
    BSAtmosphereLampColor1 = 0,
    BSAtmosphereLampColor2,
    BSAtmosphereLampColor3,
    BSAtmosphereLampColor4,
    BSAtmosphereLampColor5,
    BSAtmosphereLampColor6,
    BSAtmosphereLampColor7,
    BSAtmosphereLampColor8,// 七彩色
};

typedef NS_ENUM(NSUInteger, BSAtmosphereLightMode) {
    BSAtmosphereLightModeDefault = 255,//默认
    BSAtmosphereLightModeBright = 0,//常亮
    BSAtmosphereLightModeFlash,//快闪
};

typedef NS_ENUM(NSUInteger, BSSeckillState) {
    BSSeckillStateUnknown,//未知
    BSSeckillStateAvailable,//立即抢购
    BSSeckillStatePurchased,//已购买(查看订单)
    BSSeckillStateUnavailable,//已售罄
    BSSeckillStateWaiting,//即将开始
    BSSeckillStateEnded//活动已结束
};

#endif /* BSEnumDefine_h */
