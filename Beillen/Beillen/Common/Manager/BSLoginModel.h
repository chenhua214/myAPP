//
//  BSLoginModel.h
//  Beillen
//
//  Created by  wang on 2021/1/31.
//

#import "BSBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,BSLoginThirdBusinessCode) {
    BSLoginThirdCodePhoneUnbind       = 100203,//手机号未绑定
    BSLoginThirdCodePhoneBind         = 100204,//手机号已和其他微信绑定 /其他IPPID
    BSLoginThirdCodeWechatBind        = 100205,//微信已经和其他手机号绑定  / 其他IPPID
};

@interface BSAccountInfoPointsDtoModel : NSObject

/// 会员V值
@property (nonatomic, assign) NSInteger points;
/// 小倍分，用于计算会员等级
@property (nonatomic, assign) NSInteger levelPoints;
/// 会员等级
@property (nonatomic, copy)   NSString* level;
/// 会员等级  新的积分等级
@property (nonatomic, assign)   NSInteger grade;
@end

@interface BSAccountInfoModel : NSObject
/// 账户
@property (nonatomic, copy  ) NSString  *account;
/// 会员ID
@property (nonatomic, assign) NSInteger accountId;
/// 帐户状态：0-启用，1-禁用
@property (nonatomic, assign) NSInteger accountState;
/// APP版本
@property (nonatomic, copy  ) NSString  *appVersion;
/// 用户头像
@property (nonatomic, copy  ) NSString  *avatar;
/// 用户头像 微信
@property (nonatomic, copy  ) NSString  *avatarWx;
/// 倍思券总额
@property (nonatomic, assign) NSInteger baseusCouponAmount;
/// 绑定设备数量
@property (nonatomic, assign) NSInteger bindDeviceCount;
///未读消息数
@property (nonatomic, assign) NSInteger unreadMessageCount;
/// 国家
@property (nonatomic, copy  ) NSString  *country;
/// 注册时间戳
@property (nonatomic, assign) NSInteger createTimestamp;
/// 是否已设置密码: 0已设置，1未设置
@property (nonatomic, assign) NSInteger hasPassword;
/// 登录来源：0-中国，1-美国，2-日本，-1-未知
@property (nonatomic, assign) NSInteger loginFrom;
/// 第三方登录来源：1-facebook，2-google
@property (nonatomic, assign) NSInteger loginThirdType;
/// 邮箱
@property (nonatomic, copy  ) NSString  *mail;
///
@property (nonatomic, strong) BSAccountInfoPointsDtoModel *memberPointsDto;
/// 积分等级
@property (nonatomic, strong) BSAccountInfoPointsDtoModel *memberEquityDto;
/// string
@property (nonatomic, copy  ) NSString  *mobile;
/// 手机品牌
@property (nonatomic, copy  ) NSString  *mobileBrand;
/// 手机型号    =
@property (nonatomic, copy  ) NSString  *mobileModel;
/// 昵称    string
@property (nonatomic, copy  ) NSString  *nickname;
/// 微信昵称    string
@property (nonatomic, copy  ) NSString  *nicknameWx;
/// 系统版本
@property (nonatomic, copy  ) NSString  *osVersion;
/// 注册平台：0-ios，1-android，2-web
@property (nonatomic, assign) NSInteger regPlatform;
/// 购物车数量
@property (nonatomic, assign) NSInteger shoppingCartNum;
/// 注册时间戳
@property (nonatomic, assign) NSInteger updateTimestamp;

@end

@interface BSLoginModel : BSBaseModel
@property (nonatomic, strong) BSAccountInfoModel *accountInfo;
@property (nonatomic, copy)   NSString *auth;
///  第三方登录 状态码
///  100203  手机号未绑定
///  100204  手机号已和其他微信绑定
///  100205  微信已经和其他手机号绑定
@property (nonatomic, assign) NSInteger businessCode;
@property (nonatomic, copy)   NSString *wxKey;
/// 3--微信   6--苹果
@property (nonatomic, assign) NSInteger thirdLoginType;
@end

@interface BSRegisterMessageModel : BSBaseModel
@property (nonatomic, copy) NSString *messageT;
@property (nonatomic, copy) NSString *highlight;
@end


NS_ASSUME_NONNULL_END
