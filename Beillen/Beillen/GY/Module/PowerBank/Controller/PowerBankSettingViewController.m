//
//  PowerBankSettingViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/23.
//

#import "PowerBankSettingViewController.h"
#import "BSHomeNetWorkTool.h"
#import "BSDeviceManager.h"
#import "SettingCellView.h"
#import "BSPowerBankDevice.h"

@interface PowerBankSettingViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SettingCellView *inputCellView;
@property (nonatomic, strong) SettingCellView *deviceNameCellView;
@property (nonatomic, strong) SettingCellView *deviceModelCellView;
@property (nonatomic, strong) SettingCellView *attestCellView;
@property (nonatomic, strong) SettingCellView *numberCellView;
@property (nonatomic, strong) SettingCellView *settingCellView;
@property (nonatomic, strong) BSPowerBankDevice *device;
@end

@implementation PowerBankSettingViewController

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.device = (BSPowerBankDevice *)[[BSDeviceManager shareInstance] findDeviceWithIdentifier:self.model.sn];
   
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"设备设置";
    [self updateBackImgAndTitleFonts];
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
        
    }];
    CGFloat sp_left = 24;
    [self.inputCellView initAddViewWithType:1 type:@"充电模式" message:@"智能模式" icon:@"" showLine:NO];
    [self.scrollView addSubview:self.inputCellView];
    [self.inputCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.top.mas_equalTo(45);
        make.height.mas_equalTo(65);
        make.width.mas_equalTo(self.scrollView).offset(-sp_left*2);
    }];
    
    [self.scrollView addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputCellView.mas_bottom).offset(26);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.width.mas_equalTo(self.scrollView).offset(-sp_left*2);
    }];
    
    [self.bgView addSubview:self.deviceNameCellView];
    [self.bgView addSubview:self.deviceModelCellView];
    [self.bgView addSubview:self.attestCellView];
    [self.bgView addSubview:self.numberCellView];
    
    [self.bgView addSubview:self.settingCellView];

    [self.deviceNameCellView initAddViewWithType:2 type:@"设备名称" message:@"ELAU PD888" icon:@"" showLine:YES];
    [self.deviceModelCellView initAddViewWithType:3 type:@"设备型号" message:@"ELAU PD888" icon:@""  showLine:YES];
    [self.attestCellView initAddViewWithType:2 type:@"认证资质" message:@"六项认证" icon:@"" showLine:YES];
    [self.numberCellView initAddViewWithType:3 type:@"生产序列号" message:@"ASHUXB1E51301932" icon:@"" showLine:YES ];
    [self.settingCellView initAddViewWithType:2 type:@"恢复出厂设置" message:@"" icon:@"" showLine:NO];
    
    [self.deviceNameCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.height.mas_equalTo(65);
    }];
    [self.deviceModelCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.deviceNameCellView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
    }];
    [self.attestCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.deviceModelCellView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
    }];
    [self.numberCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.attestCellView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
    }];
    [self.settingCellView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(self.numberCellView.mas_bottom).offset(0);
        make.height.mas_equalTo(65);
        make.bottom.mas_equalTo(0);
    }];
    
    UIButton *addLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.scrollView  addSubview:addLab];
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(24);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.height.mas_equalTo(54);
        make.bottom.mas_equalTo(-20);
    }];
    [addLab  setTitle:@"删除设备" forState:UIControlStateNormal];
    addLab.titleLabel.font = [UIFont bs_regularFontWithFontSize:16];
    [addLab setTitleColor:[UIColor bs_colorFromARGB:@"#BA1A1A"] forState:UIControlStateNormal];
    [addLab addTarget:self action:@selector(showBSAlertMessage) forControlEvents:UIControlEventTouchUpInside];
    addLab.layer.cornerRadius = 27;
    addLab.layer.borderWidth = 1;
    addLab.layer.borderColor = [UIColor bs_colorFromARGB:@"#BA1A1A" alpha:0.1].CGColor;
    addLab.backgroundColor = [UIColor bs_colorFromARGB:@"#BA1A1A" alpha:0.05];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
}

-(void)showBSAlertMessage {
    __weak typeof(self) weakSelf = self;
    [YGAlertMessageTool alertMessage:@"删除设备" subMessage:@"确认将设备从手机中删除" cancelTxt:@"取消" actionTxtRed:@"确定" handle:^(BSAlertMessageAction action, id object) {
        if (action == BSAlertMessageActionEvents ) {
            [weakSelf delectDevice_pushVC];
        }
    }];
}

-(void)delectDevice_pushVC{
    
    NSLog(@"删除设备");
    //解绑设备
    if (self.model.sn) {
        __weak typeof(self) weakSelf = self;
        NSDictionary *dicparam = @{@"model":self.model.model?:@"",@"sn":self.model.sn};
        [BSHomeNetWorkTool unbindDeviceWithParam:dicparam success:^(id data) {
            BSBaseModel *model = [BSBaseModel yy_modelWithDictionary:data];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (model && model.code == 0) {
                    [self unboundDeviceSuccess];
                }else{
                    [weakSelf showHint:model.message];
                }
            });
        } fail:^(id data) {}];
    }
}

- (void)unboundDeviceSuccess{
    [[BSDeviceManager shareInstance] removeDeviceWithIdentifier:self.model.sn];
  
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSHomeRefreshNotification object:nil];
    [self popToMineDeviceViewControllerIfNeeded];
   
}

///  clickBtn
-(void)clickBtnForSetting:(UIButton*)btn {
    NSLog(@"点击按钮2222 出厂设置");
    [self.device writeWithSingleCommand:BSPowerBankCmdSttingDevice_W_state cmdValue:255 block:^(BOOL result, id  _Nullable responseDic) {
        NSLog(@"写入回复出厂设置响应");
    }];
}

-(void)clickBtnForInputModel:(UIButton*)btn {
    NSLog(@"点击按钮2222 充电模式");
}

-(void)clickBtnForSetName:(UIButton*)btn {
    NSLog(@"点击按钮2222  设置名字");
}

-(void)clickBtnToAttest:(UIButton*)btn {
    NSLog(@"点击按钮2222 认证");
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

-(SettingCellView*)inputCellView{
    if (!_inputCellView) {
        _inputCellView = [SettingCellView new];
        [_inputCellView.rightBtn addTarget:self action:@selector(clickBtnForSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _inputCellView;
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        view.layer.cornerRadius = 30;
        _bgView = view;
    }
    return _bgView;
}

-(SettingCellView*)deviceNameCellView{
    if (!_deviceNameCellView) {
        _deviceNameCellView = [SettingCellView new];
        [_deviceNameCellView.rightBtn addTarget:self action:@selector(clickBtnForSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _deviceNameCellView;
}

-(SettingCellView*)deviceModelCellView{
    if (!_deviceModelCellView) {
        _deviceModelCellView = [SettingCellView new];
    }
    return _deviceModelCellView;
}

-(SettingCellView*)attestCellView{
    if (!_attestCellView) {
        _attestCellView = [SettingCellView new];
        [_attestCellView.rightBtn addTarget:self action:@selector(clickBtnForSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _attestCellView;
}

-(SettingCellView*)numberCellView{
    if (!_numberCellView) {
        _numberCellView = [SettingCellView new];
    }
    return _numberCellView;
}

-(SettingCellView*)settingCellView{
    if (!_settingCellView) {
        _settingCellView = [SettingCellView new];
        [_settingCellView.rightBtn addTarget:self action:@selector(clickBtnForSetting:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _settingCellView;
}

@end
