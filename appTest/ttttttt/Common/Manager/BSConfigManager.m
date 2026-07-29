#import "BSConfigManager.h"
//#import "AppDelegate+BSThirdConfig.h"
#import "BSLoginModel.h"
#import "BSDeviceUtil.h"
#import "NSString+BSCommon.h"
//#import "BSCommonQueryParam.h"

#define kBSGuestNickNameKey @"guest_nick_name"

@interface BSConfigManager()

#pragma mark- 需要持久化的属性均需使用assign修饰,否则会造成崩溃(NSArray、NSDictionary)
/// 用户真实昵称
@property (nonatomic,assign) NSString *userNickName;
/// 使用模式
@property (nonatomic,assign) BSUsageMode mode;
/// 访客账号信息
@property (nonatomic,assign) NSDictionary *guestInfoDict;
/// 访客账户后缀
@property (nonatomic, copy) NSString *guestAccountSuffix;

#pragma mark- 不需要持久化的属性修饰符不做特别要求
@property (nonatomic,strong) BSAccountInfoModel *guestInfo;
@property (nonatomic,  copy) NSString *anonymousAccount;
@property (nonatomic,  copy) NSString *guestAccount;

@end

@implementation BSConfigManager
@dynamic mobile;
@dynamic auth;
@dynamic account;
@dynamic nickname;
@dynamic avatar;
@dynamic mail;
@dynamic isLogin;
@dynamic hasPassword;
@dynamic bindDeviceCount;
@dynamic totalDeviceCount;
@dynamic userNickName;
@dynamic levelPoints;
@dynamic level;
@dynamic points;
@dynamic accountId;
@dynamic mode;
@dynamic guestInfoDict;
@dynamic guestAccountSuffix;
@dynamic appleIDfamilyName;
@dynamic appleIDgivenName;

- (void)updateModel:(BSLoginModel*)loginModel{
    self.mobile = loginModel.accountInfo.mobile;
    self.account = loginModel.accountInfo.account;
    self.accountId = loginModel.accountInfo.accountId;
    self.mail = loginModel.accountInfo.mail;
    self.userNickName = loginModel.accountInfo.nickname;
    self.avatar = loginModel.accountInfo.avatar;
    self.bindDeviceCount = loginModel.accountInfo.bindDeviceCount;
    self.isLogin = YES;
    self.mode = BSUsageModeLoggedIn;
    self.hasPassword = (loginModel && loginModel.accountInfo && loginModel.accountInfo.hasPassword == 0);
    self.baseusCouponAmount = loginModel.accountInfo.baseusCouponAmount;
//    [BSCrashProtectionManager setUserIdentifierWithAccountId:self.accountId];
}

- (void)clearCacheData{
    self.mobile = nil;
    self.account = nil;
    self.auth = nil;
    self.mail = nil;
    self.nickname = NSLocalizedStringkey(@"un_login");
    self.avatar = nil;
    self.isLogin = NO;
    self.mode = BSUsageModeLogout;
    self.hasPassword = NO;
    self.bindDeviceCount  = 0;
    self.totalDeviceCount = 0;
    self.points = 0;
    self.baseusCouponAmount = 0;
    self.earphoneNeedConnectClassicBLE = NO;
}

//- (void)updateStoreUserInfoModel:(BSStoreUserInfoModel*)userInfoModel{
//    self.levelPoints = userInfoModel.memberPointsDto.levelPoints;
//    self.points = userInfoModel.memberPointsDto.points ;
//    self.levelPoints = userInfoModel.memberEquityDto.grade;
//    self.points = userInfoModel.memberEquityDto.points ;
//    self.level = userInfoModel.memberPointsDto.level ;
//    self.baseusCouponAmount = userInfoModel.baseusCouponAmount;
//    self.storeUserInfoModel = userInfoModel;
//}

- (void)updateNickName:(NSString *)userNickName{
    self.userNickName = userNickName;
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserInfoChangedNotification object:nil];
}

+ (BOOL)should2RequestUserInfo{
    return [[BSConfigManager sharedInstance] should2RequestUserInfo];
}

+ (void)switchUsageMode:(BSUsageMode)mode callback:(void(^)(void))callback{
    [[BSConfigManager sharedInstance] switchUsageMode:mode];
    if(callback){
        callback();
    }
}

/// 判断耳机是否已经连接上经典蓝牙
- (void)earphoneConnectedClassicBluetooth
{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    if (@available(iOS 10.0, *)) {
//        [session setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionAllowBluetooth error:nil];
//    } else {
//        // Fallback on earlier versions
//    }
//    NSArray *arr = [session availableInputs];
//    BOOL connected = NO;
//    for (AVAudioSessionPortDescription *description  in arr) {
//        if ([description.portType isEqualToString:AVAudioSessionPortBluetoothHFP]) {
//            connected = YES;
//            break;
//        }
//    }
//    self.earphoneNeedConnectClassicBLE = !connected;
}

- (NSString *)earphoneConnectedClassicBluetoothMac{
//    AVAudioSession *session = [AVAudioSession sharedInstance];
//    /// 当前音频输出输入的 Route
//    AVAudioSessionRouteDescription*currentRoute = session.currentRoute ;
//    /// 音频输出
//    NSArray *outputs = [currentRoute outputs];
    
    NSString *macStr = @"" ;
//    BOOL connected = NO;
//    for (AVAudioSessionPortDescription *description  in outputs) {
//        if ([description.portType isEqualToString:AVAudioSessionPortBluetoothHFP] || [description.portType isEqualToString:AVAudioSessionPortBluetoothA2DP]) {
//            connected = YES;
//            macStr = description.UID ;
//            break;
//        }
//    }
    NSLog(@"mac======%@",macStr);
    return macStr;
}

// 获取默认头像链接
- (void)getDefaultAvatar:(void (^)(NSString *avatar))handle
{
    if (!handle) return;
    if (self.isLogin && self.avatar.isEnable) {
        handle(self.avatar);
        return;
    }
    if (self.defaultNetAvatar.isEnable) {
        handle(self.defaultNetAvatar);
        return;
    }
//    [BSCommonQueryParam appDictByName:@"default_account_info" detailNames:@"avatar" completion:^(id result, BSBaseError *error) {
//        NSArray *eq_sound_mode = [result objectForKey:@"eq_sound_mode"];
//        if (eq_sound_mode.count != 1) return;
//        NSDictionary *dict = [eq_sound_mode firstObject];
//        if (!dict) return;
//        NSString *value = [dict objectForKey:@"value"];
//        if (!value) return;
//        self.defaultNetAvatar = value;
//        handle(value);
//    }];
}


+ (BSUsageMode)usageMode{
    BSConfigManager *instance = [BSConfigManager sharedInstance];
    BSUsageMode usageMode = instance.mode;
    if (instance.isLogin && usageMode == BSUsageModeLogout) {
        //之前已经是登录状态(已登录且未退出),但mode未进行初始化,需要更新
        usageMode = BSUsageModeLoggedIn;
    } else if (usageMode == BSUsageModeDefault) {
      //  统一到新登录界面，不在默认为访客模式  2.4.8 版本
//        //之前已经是登录状态(已登录且未退出),但mode未进行初始化,需要更新
//        BOOL isOtherHost =  [BSApiServer sharedInstance].isOtherEnvironment ;
//        // 如果是海外服务器   默认第一次启动就是 访客模式。 国内不变
//        if(isOtherHost) usageMode = BSUsageModeGuest;
    }
    instance.mode = usageMode;
    return usageMode;
}

+ (BOOL)isGuestMode{
    return [BSConfigManager usageMode] == BSUsageModeGuest;
}

#pragma mark- Private methods

- (BOOL)should2RequestUserInfo{
    return self.isLogin && [self.nickname isEqualToString:NSLocalizedStringkey(@"baseus_home")];
}

- (void)switchUsageMode:(BSUsageMode)mode{
    if(self.mode == mode){
        return;
    }
    self.mode = mode;
    if(mode != BSUsageModeGuest || self.guestAccount){
        return;
    }
    self.guestInfoDict = [BSConfigManager guestModel2Json];
}

/// 生成一个访客用户信息
+ (NSDictionary *)guestModel2Json{
    BSAccountInfoModel *info = [BSAccountInfoModel new];
    NSTimeInterval timeinterval = [[NSDate date] timeIntervalSince1970];
    int64_t msTimeinterval = ceil(timeinterval * 1000);
    //以毫秒时间戳作为访客账号
    info.account = [NSString stringWithFormat:@"%lld",msTimeinterval];
    info.createTimestamp = info.updateTimestamp = msTimeinterval;
    info.appVersion = kAppVersion;
    info.nickname = kBSGuestNickNameKey;
    info.regPlatform = 0;
    info.mobileModel = [BSDeviceUtil iphoneType];
    info.mobileBrand = @"APPLE";
    info.osVersion = [NSString stringWithFormat:@"ios%@",IOS_VERSION_STRING];
    return [info yy_modelToJSONObject];
}

#pragma mark- Setters && Getters

- (NSString *)nickname{
    if([BSConfigManager isGuestMode]){
        NSString *nickNameKey = self.guestInfo.nickname ? : kBSGuestNickNameKey;
        return NSLocalizedStringkey(nickNameKey);
    }
    if (!self.isLogin) {
        return NSLocalizedStringkey(@"un_login");
    }
    return self.userNickName ? : NSLocalizedStringkey(@"baseus_home");
}

- (BSAccountInfoModel *)guestInfo{
    if(!_guestInfo){
        _guestInfo = [BSAccountInfoModel yy_modelWithJSON:self.guestInfoDict];
    }
    return _guestInfo;
}

- (NSString *)guestAccount{
    if(!_guestAccount){
        if (!self.guestInfoDict || self.guestInfoDict.count == 0) {
            return nil;
        }
        _guestAccount = self.guestInfo ? self.guestInfo.account : nil;
    }
    return _guestAccount;
}

- (NSString *)anonymousAccount{
    if(!_anonymousAccount){
        if(!self.guestAccountSuffix.isEnable){//生成5位随机字符串
            self.guestAccountSuffix = [NSString randomStringWithLength:5];
        }
        NSString *guestAccount = self.guestAccount;
        if(guestAccount.isEnable){
            //访客账号追加5位随机字符串作为匿名账户
            _anonymousAccount = [guestAccount stringByAppendingString:self.guestAccountSuffix];
        }
    }
    return _anonymousAccount;
}

- (NSString *)description {
    // 初始化一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    // 得到当前classs的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++) {
        // 循环并用kvc得到每个属性的值
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        if (![BSStringUtil isBlankWithString:name] && [name isKindOfClass:[NSString class]] ) {
                id value = [self valueForKey:name] ? : @"";  // 默认值为nil字符串
                [dictionary setObject:value forKey:name];
        }
    }
    // 释放
    free(properties);
    // return
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class], self, dictionary];
}

@end
