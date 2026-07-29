#import "PAPreferences.h"
#import "BSLoginModel.h"
///#import "BSStoreUserInfoModel.h"
/// 记录当前网络状态
typedef enum : NSUInteger {
    BSNetWorkStatusUnknown,
    BSNetWorkStatusNoNetwork,
    BSNetWorkStatusWiFi,
    BSNetWorkStatusCellularData,
} BSCurrentNetWorkStatus;

///当前使用模式
typedef NS_ENUM(NSInteger,BSUsageMode) {
    BSUsageModeDefault,//默认是第一次启动 
    BSUsageModeLogout,//未登录/登出/退出访客模式
    BSUsageModeLoggedIn,//已登录
    BSUsageModeGuest,//访客
};

/// 缓存用户信息的管理类
@interface BSConfigManager : PAPreferences

#pragma mark- 需要持久化的属性均需使用assign修饰,否则会造成崩溃(NSArray、NSDictionary)
/// 手机号码
@property (nonatomic, assign) NSString  *mobile;
/// token
@property (nonatomic, assign) NSString  *auth;
/// 账号
@property (nonatomic, assign) NSString  *account;
/// 昵称
@property (nonatomic, assign) NSString  *nickname;
/// appleID 姓氏
@property (nonatomic, assign) NSString  *appleIDfamilyName;
/// appleID 名字
@property (nonatomic, assign) NSString  *appleIDgivenName;
/// 图像
@property (nonatomic, assign) NSString  *avatar;
/// 邮箱
@property (nonatomic, assign) NSString  *mail;
/// 自动登录
@property (nonatomic, assign) BOOL isLogin;
/// 自动登录 是否已设置密码: 0已设置，1未设置
@property (nonatomic, assign) BOOL hasPassword;
/// 绑定设备数量
@property (nonatomic, assign) NSInteger bindDeviceCount;
/// 总设备数量<绑定的 + 被分享的>
@property (nonatomic, assign) NSInteger totalDeviceCount;
/// 小倍分，用于计算会员等级
@property (nonatomic, assign) NSInteger levelPoints;
/// 会员等级
@property (nonatomic, assign) NSString* level;
/// 会员V值
@property (nonatomic, assign) NSInteger points;
/// 账号ID
@property (nonatomic, assign) NSInteger accountId;
/// 默认头像、无论是否登录
@property (nonatomic, copy)   NSString  *defaultNetAvatar;
/// 默认通知
@property (nonatomic, assign) BOOL  defaultNotification;
/// 重要警告通知
@property (nonatomic, assign) BOOL  criticalAlertNotification;

#pragma mark- 不需要持久化的属性修饰符不做特别要求

/// 倍思券总额
@property (nonatomic, assign) NSInteger baseusCouponAmount;
@property (nonatomic, assign) BSCurrentNetWorkStatus netWorkSatus;
//@property (nonatomic, strong) BSStoreUserInfoModel *storeUserInfoModel;
@property (nonatomic,   copy) NSString *x3MiniHelp;//值存在时需要显示小程序入口
@property (nonatomic,   copy) NSString *x3H5Help;  //值存在时优先显示H5，才显示小程序
@property (nonatomic,   copy) NSString *x3H5HelpURl;

///访客账户
@property (nonatomic, copy,readonly) NSString *guestAccount;
/// 根据访客账户生成的匿名账户
@property (nonatomic, copy,readonly) NSString *anonymousAccount;
/// 记录添加耳机成功 首页需要弹框
@property (nonatomic, assign) BOOL earphoneNeedConnectClassicBLE;
/// 更新登录信息
/// @param loginModel 登录信息
- (void)updateModel:(BSLoginModel*)loginModel;
/// 清除登录信息
- (void)clearCacheData;
/// 更新商城用户信息
//- (void)updateStoreUserInfoModel:(BSStoreUserInfoModel*)UserInfoModel;
- (void)updateNickName:(NSString *)userNickName;
+ (BOOL)should2RequestUserInfo;
/// 判断耳机是否已经连接上经典蓝牙
- (void)earphoneConnectedClassicBluetooth;
/// 判断耳机是否已经连接上经典蓝牙的mac地址
- (NSString *)earphoneConnectedClassicBluetoothMac;
/// 获取默认头像链接
- (void)getDefaultAvatar:(void (^)(NSString *avatar))handle;


#pragma mark- 访客模式
/// 切换使用模式
/// @param mode 使用模式
/// @param callback 回调
+ (void)switchUsageMode:(BSUsageMode)mode callback:(void(^)(void))callback;
/// 当前所处的模式
+ (BSUsageMode)usageMode;
/// 是否是访客模式
+ (BOOL)isGuestMode;

@end
