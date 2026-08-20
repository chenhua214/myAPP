//
//  YGSearchDeviceViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/29.
//

#import "YGSearchDeviceViewController.h"
#import "BSSearchDevicesViewModel.h"
#import "BSSearchDeviceListView.h"
#import "BSDeviceUtil.h"
#import "BSBLEManager.h"
#import "CommonMacro.h"
@interface YGSearchDeviceViewController ()<BSSearchDeviceListViewDelegate>
@property(nonatomic,strong) UIButton *addBtn;
@property(nonatomic,strong) UIButton *scanButton;
@property(nonatomic,strong) BSSearchDeviceListView *deviceListView;
@property(nonatomic,strong) BSSearchDevicesViewModel *viewModel;
@end

@implementation YGSearchDeviceViewController

- (void)viewDidLoad {
    [self updateBackImgAndTitleFonts];
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.title = @"添加设备";
    [self initView ];
    [self loadData ];
//    [[BSBLEManager shareInstance] checkBluetoothStatusForVC:self];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
    [self resumeAnimationIfNeeded];
}

- (void)dealloc{
    [_viewModel stopIfNeeded];
}

#pragma mark- setup

- (void)setup{

    [self createUI];
    [self setupConstraints];
    [self searchDevices:YES];
}

- (void)initView {
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"F2F4F8"];
    self.navigationItem.title = NSLocalizedStringkey(@"add_devices_tit");
//    [self updateBackImgAndTitleFonts];
//    UIImage *image = [[UIImage imageNamed:@"auto_search_help"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [button setImage:image forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(helpButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
//    button.frame = CGRectMake(0, 0, 26, 26);
////    [button setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
//    button.bs_touchInset = UIEdgeInsetsMake(-20, -3, -20, -20);
//    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
//    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:self.scanButton];
//    if (rightItem && item) {
//        self.navigationItem.rightBarButtonItems =  @[rightItem,item];
//    }

//    [self.view addSubview:self.autoSearchPromptView];
//    [self.autoSearchPromptView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(NAVIGATION_HEIGHT);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(44);
//    }];
}

- (void)createUI{
//    [self.view addSubview:self.loadingView];
//    [self.view addSubview:self.retryView];
    [self.view addSubview:self.deviceListView];
    self.deviceListView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.addBtn];
    self.addBtn.backgroundColor = [UIColor greenColor];
}

- (void)setupConstraints{
    CGFloat width = isIpad ? [self screenMaxWidth:0 max:360 margin:0] : kScreenWidth;
//    [self.loadingView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self.view);
//        make.size.mas_equalTo(CGSizeMake(width, width));
//    }];
//    [self.retryView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.loadingView.mas_top);
//        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(Height812(322));
//    }];
    [self.addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-90-26);
        make.left.mas_equalTo(45);
        make.right.mas_equalTo(-45);
        make.height.equalTo(@(60));
    }];
    [self.deviceListView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.autoSearchPromptView.mas_bottom);
        make.top.mas_equalTo(160);
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.addBtn.mas_top).offset(-20);
    }];
}

- (void)loadData{
//    if(self.deviceTypeDict) {
////        [self setup];
//        return;
//    }
    [self setup];
//    __weak typeof(self) weakSelf = self;
    //添加设备时不进行筛选,服务中心跳转需要进行过滤
//    BOOL filtered = NO;
//    [BSHomeNetWorkTool deviceCategoryInfo:filtered callback:^(BOOL result, id responseData) {
//
//        [weakSelf hideHud];
//        if ([responseData[@"code"] integerValue] == 0) {
//            [weakSelf refreshViewWithData:responseData];
//        }else{
//            NSString *message = responseData[@"message"];
//            if (!message.isEnable) {
//                return;
//            }
//            [weakSelf showHint:message];
//        }
//    }];
}

- (void)refreshViewWithData:(NSDictionary *)responseData{
//    NSArray *devices = [NSArray yy_modelArrayWithClass:[BSAddDeviceDataModel class] json:responseData[@"data"]];
//    self.deviceTypeDict = [NSMutableDictionary dictionary];
//    for (BSAddDeviceDataModel * model in devices) {
//        for (BSAddDeviceModel *device in model.child) {
//            for (DeviceTypeModel *type in device.products) {
//                if (type && type.model.isEnable) {
//                    [self.deviceTypeDict setValue:type forKey:type.model];
//                }
//            }
//        }
//    }
    [self setup];
}

- (void)showNoDeviceView:(BOOL)show{
//    if(show){
//        __weak typeof(self) weakSelf = self;
//        [BSAutoSearchNoDeviceView showInView:self.view offsetY: NAVIGATION_HEIGHT + bsValue(162) isInternalMargin: NO retryBlock:^{
//            [weakSelf searchDevices:YES];
//        } addByManualBlock:^{

//            [weakSelf toAddDevices];
//        }];
//        return;
//    }
//    [BSAutoSearchNoDeviceView dismissFromView:self.view];
}

- (void)showLoginAlertView{
//    [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"no_find_lost_function_title")
//                          subMessage:nil
//                           cancelTxt:NSLocalizedStringkey(@"str_cancel")
//                           actionTxt:NSLocalizedStringkey(@"login_btn")
//                              handle:^(BSAlertMessageAction action, id object) {
//        if (action == BSAlertMessageActionEvents) {
//            [BSLoginThirdController loginWithVC:self];
//        }
//    }];
//    [BSAlertMessageTool updateBgGestureEnable: NO];
}

#pragma mark- Action

-(void) toAddDevices {
//    BSAddDeviceNewController *vc = [[BSAddDeviceNewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void) scanDeviceEvents {
    self.scanButton.hidden = YES ;
    [self  searchDevices:YES];
}

- (void)searchDevices:(BOOL)search{
    if(!search){
        [self.viewModel stopIfNeeded];
        return;
    }
    if ([[BSBLEManager shareInstance] isFirstAuthorized] == NO ) {
        /// 启动没有 初始化 BSBLEManager ，延迟0.5 启动扫描数据
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if ([BSGuestModeHelper showBluetoothAlertViewForVC:self]) {

            }
//            [self.loadingView startAnimation];
            [self.viewModel resume];
        });
        return;
    }
    if ([BSGuestModeHelper showBluetoothAlertViewForVC:self]) {

    }
//    [self.loadingView startAnimation];
    [self.viewModel resume];
}

- (void)helpButtonPressed:(UIBarButtonItem *)sender{
//    NSString *lang = [BSDeviceUtil getCurrentLanguageStr];
//    BSBaseWebViewController *vc = [BSBaseWebViewController new];
//    [vc loadWithUrlString:[NSString stringWithFormat:@"%@/doc/services/doc.html?lang=%@",BaseHost,lang]];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addDeviceButtonPressed:(UIButton *)sender{
    __weak typeof(self) weakSelf = self;
    [self.viewModel addDeviceWithCallback:^(BSOperationState state, DeviceTypeModel * _Nullable typeModel, BSCommonDevice * _Nullable device) {
     
        [weakSelf handleResultWithState:state device:device typeModel:typeModel];
    }];
}

#pragma mark- Private methods

- (void)handleResultWithState:(BSOperationState)state device:(BSCommonDevice *)device typeModel:(DeviceTypeModel *)typeModel{
    if(state == BSOperationStateError){
        return;
    }
    if(state == BSOperationStateBounded){
        //如果是耳机类型,设置状态
//        if (typeModel.type == BSDeviceTypeEarphone) {
//            /// 是否需要判断 蓝牙连接状态
//            if ([device isRequestConnectedClassicBluetoothState]) {
//                [[BSConfigManager sharedInstance] earphoneConnectedClassicBluetooth];
//            }
//        }
        [self showDeviceGuideWithDeviceTypeModel:typeModel Device:device];
    }else if(state == BSOperationStateNeedLogin){
        [self showLoginAlertView];
    }else if(state == BSOperationStateConfigNetwork){
//        [self configNetWorkWithDevice:device typeModel:typeModel];
    }else if(state == BSOperationStateUnSupport){
        [self showHint:NSLocalizedStringkey(@"device_not_support")];
    }
}

- (void)reloadDataFinished:(BOOL)finished{
    BOOL noData = ![self.viewModel hasData];
    self.deviceListView.hidden = self.addBtn.hidden = noData;
    if(noData){
//        self.retryView.hidden = YES;
        if(finished){
//            [self.loadingView stopAnimation];
            [self showNoDeviceView:YES];
            return;
        }
        return;
    }
    if(noData == NO){
//        self.retryView.hidden = YES;
//        [self.loadingView stopAnimation];
    }
    if(finished){//扫描完成且有数据时,停止扫描动画
        self.scanButton.hidden = NO ;
    }
    [self.deviceListView reloadData];
    [self.addBtn configUIWithGradientColors:@[[UIColor bs_colorFromARGB:@"#353741"], [UIColor bs_colorFromARGB:@"#181A20"]]
                                    enabled:[self.viewModel checked]];
}


- (void) showDeviceGuideWithDeviceTypeModel:(DeviceTypeModel*)typeModel  Device:(BSCommonDevice *)device  {
//    if (typeModel.type == BSDeviceTypeEarphone || device.deviceSubType == BSDeviceSubTypeEarphoneBaseusF02Mouse) {
//        [self getDeviceGuideModel:typeModel Device:device];
//    } else {
        [self showDeviceBindSuccessAlertViewWithDevice:device];
//    }
}


- (void)getDeviceGuideModel:(DeviceTypeModel*)typeModel  Device:(BSCommonDevice *)device {
//    __weak typeof(self) weakSelf = self;
//    [BSHomeNetWorkTool requestDeviceGuideWithModel:typeModel.model Callback:^(BOOL result, BSAddDeviceGuideArrModel * _Nullable model) {
//        
//        BOOL isEnglish = [BSDeviceUtil isEnglishLanguage];
//        BOOL ishowGuideView = NO ;
//        if (isEnglish && model.operate_guidepage_us.count>0){
//            ishowGuideView = YES ;
//            model.selelct_operate_guidepage = model.operate_guidepage_us ;
//        } else if (isEnglish == NO && model.operate_guidepage_cn.count>0){
//            ishowGuideView = YES ;
//            model.selelct_operate_guidepage = model.operate_guidepage_cn ;
//        }
//        if (ishowGuideView) {
//            [weakSelf toVCAddDeviceGuideeModel:typeModel addDeviceGuideData:model];
//        } else {
//            [weakSelf showDeviceBindSuccessAlertViewWithDevice: device];
//        }
//    }];
}


//-(void)toVCAddDeviceGuideeModel:(DeviceTypeModel*)typeModel addDeviceGuideData:(BSAddDeviceGuideArrModel*)dateModel {
//    BSAddDeviceGuideController *vc = [[BSAddDeviceGuideController alloc]init];
//    vc.addDeviceModel = dateModel ;
//    vc.typeModel = typeModel ;
//    [self.navigationController pushViewController:vc animated:YES];
//}

- (void)showDeviceBindSuccessAlertViewWithDevice:(BSCommonDevice *)device {
    //添加成功
    weakSelf(self);
    [BSAlertMessageTool alertMessage:NSLocalizedStringkey(@"device_add_success") subMessage:nil actionTxt:NSLocalizedStringkey(@"str_confirm") handle:^(BSAlertMessageAction action, id object) {
        //回到首页
        [weakSelf addDeviceSuccessWithDevice:device];
    }];
    [BSAlertMessageTool updateBgGestureEnable: NO];
}

-(void)addDeviceSuccessWithDevice:(BSCommonDevice *)device {
//    if ([device isChargerStationDevices]) {
//        [self chargerStationAddressVCWithDevice:device];
//    } else {
        [self.navigationController popToRootViewControllerAnimated:YES];
//    }
}


/// 如有必要,重启加载动画
- (void)resumeAnimationIfNeeded{
    if (self.deviceTypeDict == nil) return ;
//    if(![self.viewModel isSearching]){ return; }
    //如果此时还在扫描,则需要开启动画
//    [self.loadingView startAnimation];
}

#pragma mark- BSSearchDeviceListViewDelegate

- (NSInteger)numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel numberOfRowsInSection:section];
}

- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel heightForRowAtIndexPath:indexPath];
}

- (nullable YGSearchDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath{
    return [self.viewModel modelAtIndexPath:indexPath];
}

- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.viewModel didSelectItemAtIndexPath:indexPath];
}

#pragma mark- Setters && Getters

- (BSSearchDevicesViewModel *)viewModel{
    if (!_viewModel) {
        __weak typeof(self) weakSelf = self;
        _viewModel = [BSSearchDevicesViewModel initWithTypeDeviceDict:self.deviceTypeDict
                                                          reloadBlock:^(BOOL finished) {
            [weakSelf reloadDataFinished:finished];
        }];
    }
    return _viewModel;
}

- (BSSearchDeviceListView *)deviceListView{
    if (!_deviceListView) {
        _deviceListView = [[BSSearchDeviceListView alloc] init];
        [_deviceListView initTypezWithTop:40];
        _deviceListView.cellBGColorHexString = @"#F2F4F8";
        _deviceListView.delegate = self;
        _deviceListView.hidden = YES;
    }
    return _deviceListView;
}

- (UIButton *)addBtn{
    if (!_addBtn) {
        _addBtn = ({
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//            [button setTitle:NSLocalizedStringkey(@"add_devices_tit") forState:UIControlStateNormal];
            
            [button setTitle:NSLocalizedStringkey(@"添加设备") forState:UIControlStateNormal];

            [button configUIWithNormalBGColor:[UIColor clearColor]
                              disabledBGColor:[UIColor bs_colorFromARGB:@"#E6E8EE"]
                             normalTitleColor:[UIColor whiteColor]
                           disabledTitleColor:[UIColor bs_colorFromARGB:@"#C8C8C8"]
                                  borderColor:[UIColor clearColor]
                                  borderWidth:0
                                 cornerRadius:16.0
                                masksToBounds:YES
                                      enabled:NO];
            [button addTarget:self action:@selector(addDeviceButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
            button.hidden = YES;
            button;
        });
    }
    return _addBtn;
}

- (UIButton *)scanButton {
    if (!_scanButton) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setImage:[UIImage imageNamed:@"auto_search_scan_icon"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(scanDeviceEvents) forControlEvents:UIControlEventTouchUpInside];
        button.frame = CGRectMake(0, 0, 26, 26);
        [button setImageEdgeInsets:UIEdgeInsetsMake(3, 3, 3, 3)];
        button.bs_touchInset = UIEdgeInsetsMake(-20, -20, -20, -3);
        _scanButton = button;
        _scanButton.hidden = YES ;
    }
    return _scanButton;
}

#pragma mark - ipad
-(void)refreshIpadScreenSizeAction:(CGSize)size{
    CGFloat width = [self screenMaxWidth:0 max:360 margin:0];
//    [self.loadingView mas_updateConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(width, width));
//    }];
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (isIpad) {
        BOOL checked = self.deviceTypeDict == nil ? false : [self.viewModel checked];
        [self.addBtn configUIWithGradientColors:@[[UIColor bs_colorFromARGB:@"#353741"], [UIColor bs_colorFromARGB:@"#181A20"]]
                                        enabled:checked];
    }
}

@end
