//
//  CommonMacro.h
//
//  Created by mac on 2017/5/22.
//  Copyright © 2017年 Qfang. All rights reserved.
//
//  PS:常用的宏定义<任何项目都可以拿来用的>，请不要在这里面宏定义和自己项目有关的参数宏

#ifndef CommonMacro_h
#define CommonMacro_h

typedef void (^Complete)(void);
typedef void (^Completion)(id data);
typedef void (^Completions)(id responseObject,id status);

///------ 访客模式 ------

#define IS_GUEST_MODE       ([BSGuestModeHelper isGuestMode])
#define kBSDidUsedGuestMode @"kBSDidUsedGuestMode"

///------ 应用程序版本号version ------
#define kAppVersion     ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"])
#define kAppVersionCode ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])

///------ iOS系统版本号 ------
#define IOS_VERSION_STRING [UIDevice currentDevice].systemVersion
#define IOS_VERSION ([[[UIDevice currentDevice] systemVersion] floatValue])
// #define  IsIOS11 ([[[UIDevice currentDevice] systemVersion] intValue]==11)
// x 系列
// #define  IS_iPhoneX ([UIScreen mainScreen].bounds.size.width == 375 && [UIScreen mainScreen].bounds.size.height == 812)
//

#define weakSelf(type) __weak __typeof__(type) weakSelf = type;
#define strongSelf(type) __strong __typeof__(type) strongSelf = type; if (nil == strongSelf) return;

///------ 尺寸 ------
#define kSCREEN_WIDTH       [UIScreen mainScreen].bounds.size.width
#define kSCREEN_HEIGHT      [UIScreen mainScreen].bounds.size.height
#define kScreenRect         [UIScreen mainScreen].bounds
#define NAVIGATION_HEIGHT   (CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]) + CGRectGetHeight(self.navigationController.navigationBar.frame))
/**
 状态栏高度-根据系统不同-动态获取的高度，是准确的，固定20 或者 44 写死的不准确了，目前有20 44 47 48 50 几种高度了
 如：iPhoneXR,iPhone11 状态栏高度为48，
    iPhone X，iPhone 11 Pro，iPhone 11 Pro Max，iPhone 12 mini，状态栏高度44，
    iPhone 12，iPhone 12 Pro，iPhone 12 Pro Max，状态栏高度为47.
    iPhone 13 mini状态栏高度为50，iPhone 13，
    iPhone 13 Pro，iPhone 13 Pro Max，状态栏高度为47.
 */
#define StatusBar_HEIGHT    [[BSPhoneJudgeManager shareManager] getStatusBarHight]
#define TabBar_HEIGHT       ([[UIApplication sharedApplication] statusBarFrame].size.height>20?83:49)
#define Bottom_HEIGHT       (kDevice_Is_iPhoneXSeries?34:0)

#define autoSizeScaleX [UIScreen mainScreen].bounds.size.width/375
#define autoSizeScaleY [UIScreen mainScreen].bounds.size.height/667

/// 1像素的线
#define kBSOnePixelHeight   (1 / [UIScreen mainScreen].scale)
//奇数行时需要设置偏移
#define kBSOnePixelOffset   (kBSOnePixelHeight / 2)

//  正常的行高  51   右边距离24
#define kSpaceHeight51 bsValue(51)
#define kSpaceWidth24  bsValue(24)



/// 用于UI 设计图是按刘海屏做, 要减去的上下间距 liangrc
#define kLoseTop_Height ((kDevice_Is_iPhoneXSeries) ? 0.0 : 24.0)
#define kLoseBottom_Height ((kDevice_Is_iPhoneXSeries) ? 0.0 : 34.0)

///------ 沙盒路径 ------
#define PATH_OF_TEMP        NSTemporaryDirectory()
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]

///------ iOS Device Type ------
#define kDevice_Is_iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhone6P ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneX ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneXs ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneXR ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define kDevice_Is_iPhoneXM ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
// x 系列
#define kDevice_Is_iPhoneXSeries ([BSPhoneJudgeManager shareManager].iPhoneXSeries)
// 底部安全区域
#define kDeviceSafeAreaBottom ([BSPhoneJudgeManager shareManager].safeInset.bottom)
// 状态栏高度
#define kDeviceStatuBarHeight (CGRectGetHeight([BSPhoneJudgeManager shareManager].statusBarFrame))
// 导航栏高度
#define kDeviceNavigationBarHeight (CGRectGetHeight([BSPhoneJudgeManager shareManager].navigationBarFrame))
// 导航栏+状态栏
#define kDeviceNaviAndStatusHeight (kDeviceStatuBarHeight + kDeviceNavigationBarHeight)
/// Ipad
#define isIpad  [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad
#define kAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
#define kPrintSelf NSLog(@"%@-%s",NSStringFromClass(self.class),__func__);
// 定义宏
#define  adjustsScrollViewInsets(scrollView)\
do {\
_Pragma("clang diagnostic push")\
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
NSInteger argument = 2;\
invocation.target = scrollView;\
invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
[invocation setArgument:&argument atIndex:2];\
[invocation retainArguments];\
[invocation invoke];\
}\
_Pragma("clang diagnostic pop")\
} while (0)

///------ RGB颜色 ------
#define RGBA(r, g, b, a) ([UIColor colorWithRed:(r)/255. green:(g)/255. blue:(b)/255. alpha:a])

///当前日期字符串
#define DATE_STRING \
({NSDateFormatter *fmt = [[NSDateFormatter alloc] init];\
fmt.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];\
[fmt setDateFormat:@"yyyy-MM-dd HH:mm:ss"];\
[fmt stringFromDate:[NSDate date]];})


///------ 有效性验证<字符串、数组、字典等> ------
#define VALID_STRING(str)      ((str) && ([(str) isKindOfClass:[NSString class]]) && ([(str) length] > 0))
#define VALID_ARRAY(arr)       ((arr) && ([(arr) isKindOfClass:[NSArray class]]) && ([(arr) count] > 0))
#define VALID_DICTIONARY(dict) ((dict) && ([(dict) isKindOfClass:[NSDictionary class]]) && ([(dict) count] > 0))
#define VALID_NUMBER(number)   ((number) && ([(number) isKindOfClass:NSNumber.class]))

///  ----- 增加字符串绝对值 和 对象绝对值 防止为空
#define AbsoluteStr(str) (str.length > 0 ? str : @"")
#define AbsoluteObj(obj, defaultObj) (obj == nil ? defaultObj : obj )


#define kUnAnimationReloadData(...)\
[CATransaction begin];\
[CATransaction setDisableActions:YES];\
__VA_ARGS__; \
[CATransaction commit];

#define BSDBName  @"BaseusLocalDB"//数据库名

#define BaseHost        [BSApiServer sharedInstance].hostURL
#define BaseHostStore   [BSApiServer sharedInstance].hostStoreURL
#define AppStoreUrl     @"https://itunes.apple.com/us/app/xiao-qi-dian/id1552808896?ls=1&mt=8"
#define AppStoreLookUrl @"http://itunes.apple.com/lookup?id=1552808896"
/// MQTT 服务器地址
#define kMqtt_BaseHost  [BSApiServer sharedInstance].mqttHostURL
/// Alexa 服务器地址
#define kAlexa_BaseHost [BSApiServer sharedInstance].alexaHostURL

#define RSAPublicKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDACE9CZ0ZLsrlF0/QRxnhqufcbAR2Y8CJXKVgGBHL8XyPuSPcUhqJGCO9UE7FlDsq1BFyuqx9iLs786SEAg5BskkAm6BttV5uXQSIFOxFjuz6PRueq++TiP9KCuPOspvWhVuZFJrajeyTVJ65sViiwmnjOUTt/60qJr8Gk4ZqCPwIDAQAB"

#define kBSLoginStateChangedNotification    @"kBSLoginStateChangedNotification"

#define ShoppingGoodsNeedUpdateNotification @"ShoppingGoodsNeedUpdateNotification"
#define kBSHomeRefreshNotification          @"kBSHomeRefreshNotification"
#define kBSHomeDevicesRefreshNotification   @"kBSHomeDevicesRefreshNotification"
#define kBSUserInfoChangedNotification      @"kBSUserInfoChangedNotification"
#define kBSUserInfoRefreshNotification      @"kBSUserInfoRefreshNotification"
#define kBSDeviceSettingChangedNotification @"kBSDeviceSettingChangedNotification"
#define kBSDeviceSettingWiFiUpdateNotification @"kBSDeviceSettingWiFiUpdateNotification"
#define kBSHomeDeviceParamsUpdateNotification  @"kBSHomeDeviceParamsUpdateNotification"
#define kBSDeviceLocationUpdateNotification @"kBSDeviceLocationUpdateNotification"
#define kBSAroModelDetailChangeNotice       @"kBSAroModelDetailChangeNotice"
#define kBSDeviceAddressChangedNotification @"kBSDeviceAddressChangedNotification"
#define kBSNetworkNotification    @"kBSNetworkNotification"
/// 剪切板文本内容
#define kBSClipBoardTextNotification    @"kBSClipBoardTextNotification"
/// 界面重绘
#define kBSRefreshScreenSizeNotification    @"kBSRefreshScreenSizeNotification"
/// AI电容笔连接状态
#define kBSPenConnectNotification    @"kBSPenConnectNotification"
#define kBSPenDidReadSNUUIDNotification    @"kBSPenDidReadSNUUIDNotification"
#define kBSPenConnectDeviceNotification    @"kBSPenConnectDeviceNotification"
#define kBSPenStartConnectDeviceNotification    @"kBSPenStartConnectDeviceNotification"
/// 恢复出厂设置成功
#define kBSDeviceFactorySettingSuccessfulNotification @"kBSDeviceFactorySettingSuccessfulNotification"
/// 是否显示有升级属性
#define kBSDeviceSettingOTANotification @"kBSDeviceSettingOTANotification"

#define kBSEarphoneSoundModeChangeNotification @"kBSEarphoneSoundModeChangeNotification"
#define kBSEarphoneWearStateChangeNotification @"kBSEarphoneWearStateChangeNotification"

#define kBSiPadPenDblClickModelChangedNotice @"kBSiPadPenDblClickModelChangedNotice"
#define kBSiPadPenCustomClickModelChangedNotice @"kBSiPadPenCustomClickModelChangedNotice"

#define kBSUpdateEnergyModelChangeNotification @"kBUpdateEnergyModelChangeNotification"
#define kBSGetDateEnergyModelChangeNotification @"kBSGetDateEnergyModelChangeNotification"
#define kBSUpdateHomeDataNotification @"kBSUpdateHomeDataNotification"
/// 鼠标
#define kBSMouseCustomClickModelChangedNotice @"kBSMouseCustomClickModelChangedNotice"

#define kBSHostServerType        @"selectHostServerType"
#define kBSSelectedHostTypeUrl   @"kBSelectedHostTypeUrl"
#define kBSTurnOnYourBluetooth   @"kBSTurnOnYourBluetooth"
#define kBSLastLoginAcount       @"BSAccounLoginviewAccount"
#define kBSLastLoginPhone        @"BSAccounLoginviewPhone"

#define kBSOTAUpgradeSuccessNotification   @"kBSOTAUpgradeSuccessNotification"
//  AC 输出接口变化
#define kBSEnergyCmdACOutputStateNotification          @"kBSEnergyCmdACOutputStateNotification"
//  更新储能Home页数据
#define kBSEnergyCmdUpDataForHomeViewWithChangeNotification @"kBSEnergyCmdUpDataForHomeViewWithChangeNotification"
//  更新储能设置页数据
#define kBSEnergyCmdUpDataForSettingViewWithChangeNotification @"kBSEnergyCmdUpDataForSettingViewWithChangeNotification"
//  更新储能设置页数据 是否又返回值
#define kBSEnergyCmdReturnDataForSettingViewWithChangeNotification @"kBSEnergyCmdReturnDataForSettingViewWithChangeNotification"

//  并机添加设备成功
#define kBSEnergyMoreViewUpdataSuccessNotification    @"kBSEnergyMoreViewUpdataSuccessNotification"
//  并机成功
#define kBSEnergyMoreViewMergeSuccessNotification     @"kBSEnergyMoreViewMergeSuccessNotification"
// 退出并机
#define kBSEnergyMoreViewReturnMergeNotification      @"kBSEnergyMoreViewReturnMergeNotification"
// 退出并机成功
#define kBSEnergyMoreViewReturnMergeSuccessNotification @"kBSEnergyMoreViewReturnMergeSuccessNotification"
//  异常需要退出并机
#define kBSEnergyCmdErrorReturnMergeStateNotification  @"kBSEnergyCmdErrorReturnMergeStateNotification"
//  更新并机首页状态
#define kBSEnergyCmdUpDataForHomeStateNotification     @"kBSEnergyCmdUpDataForHomeStateNotification"

static NSString *const kBSDeviceShareUpdateNotification = @"kBSDeviceShareUpdateNotification";
static NSString * const ChargebackStateChangeNotice = @"ChargebackStateChangeNotice";
static NSString * const SubmitLogisticsSuccessNotice = @"SubmitLogisticsSuccessNotice";

#define kAroWear_switch @"wear_switch"
#define kSetting_subtitle @"kSetting_subtitle"
/// 清洁水枪使用说明是否被阅：0 默认 1 待阅读  2 已阅读
#define kWashingGunDescWillRead @"kWashingGunDescWillRead"
#define kWashingGunLogUploadFinishNotice @"kWashingGunLogUploadFinishNotice"


/// model name 设备model 通知名称
#define kBSEnergySettingViewModelUpdateModelMessage @"kBSEnergySettingViewModelUpdateModelMessage"
/// model name 商城购物车数字小圆点
#define kBSUpdateShoppingCartBadgeNotification @"kBSUpdateShoppingCartBadgeNotification"
/// 储能AC输出接口变化 通知
#define kBSEnergyCmdACOutputStateNotification @"kBSEnergyCmdACOutputStateNotification"

/// 240w桌面充恢复出厂设置
#define kBSCharger240wResetInitNotification @"kBSCharger240wResetInitNotification"
#define kBUnbindDeviceNotification @"kBUnbindDeviceNotification"

/// 星云二代充电桩添加取电卡
#define kBChargerStationAddCardsNotification @"kBChargerStationAddCardsNotification"
#define kBChargerStationAddedCardsNotification @"kBChargerStationAddedCardsNotification"
#define kBChargerStationChargerRecordNotification @"kBChargerStationChargerRecordNotification"

/// 切换语言成功通知
#define kBChangeLanguageSuccessNotification @"kBChangeLanguageSuccessNotification"

#endif /* CommonMacro_h */
