//
//  YGHomeViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGHomeViewController.h"
#import "YGSearchDeviceViewController.h"
#import "BSDeviceDBHelper.h"
#import "BSHomeModel.h"
#import "BSHomeContentView.h"
#import <YYCategories/YYCategories.h>
#import <YYCategories/YYCategoriesMacro.h>
#import "BSBLEManager.h"
#import "BSDeviceManager.h"
#import "BSHomeProfilesModel.h"

/// to View
#import "PowerBankHomeViewController.h"

@interface YGHomeViewController ()
@property (nonatomic, strong) BSHomeContentView *contentView;
/// Device 数据
@property (nonatomic, strong) BSHomeDataModel *dataModel;
@end

@implementation YGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
   

//    self.title =@"11111";
    
//    self.tabBarItem.title = @"22222";;
//    UIButton *addLab = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:addLab];
//    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.bottom.mas_equalTo(-120);
//        make.left.mas_equalTo(60);
//        make.height.mas_equalTo(50);
//        make.width.mas_equalTo(120);
//    }];
////    addLab set = @"添加设备";
//    [addLab  setTitle:@"添加设备" forState:UIControlStateNormal];
//    
//    addLab.titleLabel.font = [UIFont bs_regularFontWithFontSize:16];
//    [addLab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
//    [addLab addTarget:self action:@selector(addDevice_pushVC) forControlEvents:UIControlEventTouchUpInside];
//  
    
    
    // Do any additional setup after loading the view.
    [self updateBackImgAndTitleFonts];
    [self executePhoneJudgeManager];
    [self enterIntoGeustMode];
    [self initRACSubjects];
    [self initSubview];
    [self addNotifications];
    [self requestHomeData];
//    [BSBindDeviceManager manager];
//    if (self.dataModel.devices.count == 0) return;
    [[BSBLEManager shareInstance] scanBLEDevices];
    
    UIButton *addLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addLab];
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-120);
        make.left.mas_equalTo(60);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(120);
    }];
//    addLab set = @"添加设备";
    [addLab  setTitle:@"添加设备" forState:UIControlStateNormal];
    
    addLab.titleLabel.font = [UIFont bs_regularFontWithFontSize:16];
    [addLab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addLab addTarget:self action:@selector(addDevice_pushVC) forControlEvents:UIControlEventTouchUpInside];
  
 
//    self
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_hideNavigationBarWithAnimated:animated];
}


- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (!self.presentedViewController) [self bs_showNavigationBarWithAnimated:animated]; //如果是present时,不显示导航栏
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
  
}
/// 配置导航栏高度参数
- (void)executePhoneJudgeManager {
    [[BSPhoneJudgeManager shareManager] executeNavigationBarWithNavigationController:self.navigationController];
}

/// 获取首页数据
-(void)requestHomeData {
    if (IS_GUEST_MODE) {
        __weak typeof(self) weakSelf = self;
        [BSDeviceDBHelper allDevicesWithCallback:^(BOOL result, id responseData) {
            if (result && responseData) {
                BSHomeDataModel* homeDataModel = [BSHomeDataModel new];
                homeDataModel.devices = [(NSArray *)responseData copy];
                if (homeDataModel && [homeDataModel isKindOfClass:[BSHomeDataModel class]]) {
                    weakSelf.dataModel = homeDataModel;
                  }
                [weakSelf loadedHomeData:weakSelf.dataModel];
            }
            //            if (self.allInfoSubject) [self.allInfoSubject sendNext:homeDataModel];
        }];
    }
//        return;
}

-(void)addDevice_pushVC{
    NSLog(@"添加设备");
    YGSearchDeviceViewController *vc = [[YGSearchDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterIntoGeustMode{
    [BSGuestModeHelper switchUsageMode:BSUsageModeGuest callback:^{
        [self dismissAndEnterInfoGuestMode];
    }];
}


#pragma mark - 数据 Data

- (void)initRACSubjects {
    __weak typeof(self) weakSelf = self;
    // 所有的点击事件
    // Banner 、 个人中心 、 消息中心 、 添加设备 、 登录 、 Cell 等等
    [self.contentView.eventsSubject subscribeNext:^(RACTuple *tuple) {
        

        NSLog(@"点击数据0000000");
        BSHomePageEventsType type = [[tuple first] integerValue];
        id data;
        if (tuple.count >= 2) data = [tuple second];
        [weakSelf cellAndBannerAndHeaderTouchEventsType:type data:data];
        
    }];
}




/// 先从本地获取缓存数据后
- (void)loadHomeDataFromCache
{
    /////88888
//    BSHomeDataModel *dataModel = [BSCacheHelper valueForKey:kDefaultDataModelKey];
//    if (dataModel && [dataModel isKindOfClass:[BSHomeDataModel class]]) {
//        self.dataModel = dataModel;
//    }
//    BSHomeWeatherModel *weatherModel = [BSCacheHelper valueForKey:kDefaultWeatherDataKey];
//    if (weatherModel && [weatherModel isKindOfClass:[BSHomeWeatherModel class]]) {
//        self.weatherModel = weatherModel;
//    }
    [self reloadCollectionViewData];
//    [self loadedHomeData:self.dataModel];
}

#pragma mark - UI

- (void)initSubview
{
    self.bs_barAlpha = 0;
    [self.view addSubview:self.contentView];
    BOOL translucent = self.tabBarController && self.tabBarController.tabBar.translucent;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(translucent ? -self.topPadding : 0);
    }];
}

#pragma mark - ** NSNotificationCenter Start **

- (void)addNotificationWithName:(NSString *)name sel:(SEL)sel {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:sel name:name object:nil];
}

- (void)addNotifications
{
  
    [self addNotificationWithName:kBSDeviceSettingChangedNotification sel:@selector(notice_refreshIfNeeded)];
   
    [self addNotificationWithName:kBSUpdateHomeDataNotification sel:@selector(notice_updateHomeDataNotice:)];
    [self addNotificationWithName:kBSDeviceNotification sel:@selector(notice_deviceNotification:)];
  
    [self addNotificationWithName:kBChangeLanguageSuccessNotification sel:@selector(chengeLanguage:)];
}

/// 切换App语言通知
- (void)chengeLanguage:(NSNotification *)notice
{
    [self reloadCollectionViewData];
    [self.contentView updateOnChangeLanguages];
}

- (void)notice_refreshIfNeeded
{
    // 更新设备、个人信息、
//    [self updateUserMainInfomations];
}

- (void)notice_updateHomeDataNotice:(NSNotification *)notice
{
    // 刷新UI
    if (self.isViewLoaded && self.view.window) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self reloadCollectionViewData];
        });
    }
}

// 更新首页UI
- (void)reloadCollectionViewData
{
   
    [self.contentView updateDataModel:self.dataModel];
}

- (void)notice_deviceNotification:(NSNotification *)notification
{
    // 设备连接状态通知-更新
    
    BSDeviceNotificationModel *model = notification.object;
    [self connectStateChangedWithData:model];
}

/// 设备连接状态通知-更新
- (void)connectStateChangedWithData:(BSDeviceNotificationModel *)data {
    NSLog(@"设备连接状态变化，更新变化状态 %ld 之后的Home UI",(long)data.type );
    if (data.type == BSDeviceNotificationTypeConnected) {
        [self didConnectWithDevice:data.device];
    }
    else if (data.type == BSDeviceNotificationTypeDisconnected) {
        [self didDisConnectWithDevice:data.device];
    }
}

/// 设备连接成功
- (void)didConnectWithDevice:(BSCommonDevice *)device {
//    [self.updateUISubject sendNext:nil]; // 更新UI
    [self reloadCollectionViewData];
}

/// 设备断开连接
- (void)didDisConnectWithDevice:(BSCommonDevice *)device
{
    [self reloadCollectionViewData];
}

/// 从 本地 / 服务器 获取到设备数据后
- (void)loadedHomeData:(BSHomeDataModel *)data
{
    NSArray *devices = data.devices.copy;
    if (devices.count > 0) {
        [[BSBLEManager shareInstance] stopScanBLEDevices];
    }
    [[BSDeviceManager shareInstance] configDevicesWithDevices:devices callback:^{
//        [[BSWMCommandManager manager] startService];
        if (devices.count > 0) {
            [[BSBLEManager shareInstance] scanBLEDevices];
        }
    
        dispatch_async(dispatch_get_main_queue(), ^{
            // 加这个是解决 App无网络启动时 导致Mqtt设备无法及时查询上线状态
//            [[NSNotificationCenter defaultCenter] postNotificationName:kBSUserInfoRefreshNotification object:nil];

            [self reloadCollectionViewData];
//            [self aotuatomicReadDeviceCommand];
        });
    }];

}


#pragma mark  首页所有点击事件合集
- (void)cellAndBannerAndHeaderTouchEventsType:(BSHomePageEventsType)eventsType data:(id)data
{
    switch (eventsType) {
        case BSHomePageEventsTypeGoLogin:     ///< 去登录
        {
//            [self goLogin_pushVC];
        }
            break;
        case BSHomePageEventsTypeGoUser:      ///< 去个人中心
        {
//            [self userInfo_pushVC];
        }
            break;
        case BSHomePageEventsTypeToMessage:   ///< 去消息中心
        {
//            [self messageCentre_pushVC];
        }
            break;
        case BSHomePageEventsTypeAddDevice:   ///< 去添加设备
        {
            [self addDevice_pushVC];
        }
            break;
        case BSHomePageEventsTypeBanner:      ///< Banner 图被点击
        {
//            BSHomeBannerModel *banner = data;
//            [self bannerDidSelected:banner.urlData];
        }
            break;
        case BSHomePageEventsTypeCellSwitch:  ///< Cell 中的按钮点击
        {
//            if (![self supportDeviceType:data]) return;
//            [self cell_switchEventsWithModel:data];
        }
            break;
        case BSHomePageEventsTypeCellTouch:   ///< Cell 被点击
        {
            if (![self supportDeviceType:data]) return;
            [self cell_didSelectedWithModel:data];
        }
            break;
    }
}

#pragma mark - Cell 点击事件

- (void)cell_didSelectedWithModel:(BSHomeDeviceModel *)deviceModel{
//    BSDeviceSubType deviceSubType = deviceModel.deviceSubType;
    switch (deviceModel.deviceType) {
        case BSDeviceTypeOutdoorPower:
        {
            [self cell_toPowerBankVCWithModel:deviceModel];
        }
           
      
            break;

     
      
        default:
           
            [self showHint:NSLocalizedStringkey(@"device_not_support")];
            break;
    }
}

/// 是否支持此类型的功能
- (BOOL)supportDeviceType:(BSHomeDeviceModel *)deviceModel
{
    if (!deviceModel ||
        ![deviceModel respondsToSelector:@selector(model)] ||
        ![BSCommonDevice isSupportedDevice:deviceModel.model]) {
        [self showHint:NSLocalizedStringkey(@"device_not_support")];
        return NO;
    }
    return YES;
}


#pragma mark   to controller View
// MARK: 移动电源
-(void)cell_toPowerBankVCWithModel:(BSHomeDeviceModel *)model {

    PowerBankHomeViewController *vc = [[PowerBankHomeViewController alloc] init];
    vc.model = model;
    [self.navigationController pushViewController:vc animated:YES];
}

- (BSHomeContentView *)contentView {
    if (!_contentView) {
        _contentView = [BSHomeContentView new];
        if (isIpad) {
//            [self setupIpadScreenViewParameter];
        }else {
            CGFloat bannerWidth = kScreenWidth-20*2;
            CGFloat cellWidth   = isIpad ? 156 : (kScreenWidth-30*2-20)/2.0;
            _contentView.bannerSize = CGSizeMake(bannerWidth, bannerWidth * 190/390.0 + 10*2);
            _contentView.collectionSize = CGSizeMake(cellWidth, cellWidth * 176 / 156.0);
            _contentView.addDeviceSize = CGSizeMake(kScreenWidth*220/390.0, kScreenWidth*220/390.0);
        }
//        if (@available(iOS 11.0, *)) {}
//        else self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return _contentView;
}

- (void)dismissAndEnterInfoGuestMode {
    [BSUserDefaults setBool:YES forKey:kBSDidUsedGuestMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginStateChangedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
