//
//  PowerBankHomeViewController.m
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import "PowerBankHomeViewController.h"
#import "BSPowerBankHomeViewModel.h"
#import "PowerBankHomeView.h"
#import "PowerBankTypeView.h"
#import "SegmentedView.h"
#import "BSDeviceManager.h"
///  to View
#import "PowerBankSettingViewController.h"
#import "PowerBankMessageViewController.h"
@interface PowerBankHomeViewController ()
@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) BSPowerBankHomeViewModel *viewModel ;
@property (nonatomic, strong) PowerBankHomeView *headView;
@property (nonatomic, strong) PowerBankTypeView *typeC1View;
@property (nonatomic, strong) PowerBankTypeView *typeC2View;
@property (nonatomic, strong) PowerBankTypeView *typeUSBA1View;
@property (nonatomic, strong) SegmentedView *selectTitelView;

@end

@implementation PowerBankHomeViewController

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"Beillen";
    [self updateBackImgAndTitleFonts];
   
    [self configRightItem];
    __weak typeof(self) weakSelf = self;
    self.viewModel.PowerBankValueChange = ^(BOOL isChangeValue) {
        if (isChangeValue) {
            [weakSelf updateForDevice];
        }
    };

    CGFloat heightView =  self.navigationController.navigationBar.frame.size.height ;
    heightView = [self getStatusBarHeight];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    [self.scrollView addSubview:self.headView];
    [self.scrollView addSubview:self.typeC1View];
    [self.scrollView addSubview:self.typeC2View];
    [self.scrollView addSubview:self.typeUSBA1View];
    
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.centerX.mas_equalTo(0);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
    }];
    
    [self.typeC1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headView.mas_bottom).offset(20);
        make.left.mas_equalTo(24);
        make.right.equalTo(self.scrollView.mas_centerX).offset(-8);
        make.height.mas_equalTo(125);
    }];
    
    [self.typeC2View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeC1View.mas_top).offset(0);
        make.right.mas_equalTo(-24);
        make.left.equalTo(self.scrollView.mas_centerX).offset(8);
        make.height.mas_equalTo(125);
    }];
    
    [self.typeUSBA1View mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeC1View.mas_bottom).offset(16);
        make.left.mas_equalTo(24);
        make.right.equalTo(self.scrollView.mas_centerX).offset(-8);
        make.height.mas_equalTo(125);
    }];
    [self updateForDevice];
    [self.scrollView addSubview:self.selectTitelView];
    [self.selectTitelView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeUSBA1View.mas_bottom).offset(16);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(-20);
    }];
    [self.selectTitelView initAddView];
    [self.selectTitelView.batteryView.rightBtn addTarget:self action:@selector(clickSwith:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
}

- (void)configRightItem {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"powerBank_home_set"] forState: UIControlStateNormal];
    btn.bs_touchInset = UIEdgeInsetsMake(-20, -25, -20, -20);
    [btn addTarget:self action:@selector(onCancleAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:btn];
}

- (void)addNotifications
{
    __weak typeof(self) weakSelf = self;
    [RACObserve(self.viewModel.device, smallAMPType) subscribeNext:^(id  _Nullable x) {
        [weakSelf updateForDevice];
    }];
}

-(void)updateForDevice {
    self.headView.deviceModel = self.viewModel.device;
    BOOL isConneted = self.viewModel.device.isConnected;
    [self.typeC1View upTypeModel:self.viewModel.device.typeC1 isConnet:isConneted];
    [self.typeC2View upTypeModel:self.viewModel.device.typeC2 isConnet:isConneted];
    [self.typeUSBA1View upTypeModel:self.viewModel.device.USBA1 isConnet:isConneted];
    self.selectTitelView.deviceModel =self.viewModel.device;
}

- (void)onCancleAction:(id)sender {
    NSLog(@"设备设置页面");
    PowerBankSettingViewController *VC  = [[PowerBankSettingViewController alloc]init];
    VC.model = self.model;
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)clickSwith:(UIButton*)button {
    NSLog(@"点击电池信息");
    PowerBankMessageViewController *VC  = [[PowerBankMessageViewController alloc]init];
    VC.model = self.model;
    [self.navigationController pushViewController:VC animated:YES];
}

- (CGFloat)getStatusBarHeight {
    CGFloat statusBarHeight = 0;
    if (@available(iOS 13.0, *)) {
        // iOS 13 及以上：通过 UIWindowScene 获取
        UIWindowScene *windowScene = nil;
        for (UIWindowScene *scene in [UIApplication sharedApplication].connectedScenes) {
            if (scene.activationState == UISceneActivationStateForegroundActive) {
                windowScene = scene;
                break;
            }
        }
        if (windowScene) {
            statusBarHeight = windowScene.statusBarManager.statusBarFrame.size.height;
        } else {
            // 兜底：如果没有激活的 scene，尝试取第一个
        }
    }
    return statusBarHeight;
}

-(BSPowerBankHomeViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[BSPowerBankHomeViewModel alloc]initWithModel:self.model];
        [_viewModel initData ];
        
    }
    return _viewModel;
}

-(UIScrollView*)scrollView {
    if (!_scrollView) {
        UIScrollView *mainScrollView = [UIScrollView new];
        mainScrollView.showsHorizontalScrollIndicator = NO;
        mainScrollView.showsVerticalScrollIndicator   = NO;
        _scrollView = mainScrollView;
    }
    return _scrollView;
}

-(PowerBankHomeView*)headView
{
    if (!_headView) {
        _headView = [PowerBankHomeView new];
        [_headView initAddView];
    }
    return _headView;
}

-(PowerBankTypeView*)typeC1View
{
    if (!_typeC1View) {
        _typeC1View = [PowerBankTypeView new];
        [_typeC1View initAddView];
    }
    return _typeC1View;
}

-(PowerBankTypeView*)typeC2View
{
    if (!_typeC2View) {
        _typeC2View = [PowerBankTypeView new];
        [_typeC2View initAddView];
    }
    return _typeC2View;
}

-(PowerBankTypeView*)typeUSBA1View
{
    if (!_typeUSBA1View) {
        _typeUSBA1View = [PowerBankTypeView new];
        [_typeUSBA1View initAddView];
    }
    return _typeUSBA1View;
}

-(SegmentedView*)selectTitelView
{
    if (!_selectTitelView) {
        _selectTitelView = [SegmentedView new];
    }
    return _selectTitelView;
}

@end
