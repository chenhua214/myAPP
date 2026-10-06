//
//  PowerBankSetTimeViewController.m
//  Beillen
//
//  Created by chenyi on 2026/10/6.
//

#import "PowerBankSetTimeViewController.h"
#import "BSPowerBankDevice.h"
#import "BSDeviceManager.h"
#import "PowerBankTimeSetCellView.h"
@interface PowerBankSetTimeViewController ()<PowerBankTimeSetCellViewDelegate>
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *messageLab;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeViewSelect;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeView1;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeView2;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeView3;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeView4;
@property (nonatomic, strong) PowerBankTimeSetCellView *timeView5;
@property (nonatomic, assign) NSInteger selectTimeNumber;
@property (nonatomic, strong) UIButton *okBtn;
@end

@implementation PowerBankSetTimeViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
}

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.device = (BSPowerBankDevice *)[[BSDeviceManager shareInstance] findDeviceWithIdentifier:self.model.sn];
    self.view.backgroundColor  = self.bs_backgroundColor  = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"计时提醒";
    [self updateBackImgAndTitleFonts];

    CGFloat sp_left = 24;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(-30);
    }];
    
//    self.scrollView.backgroundColor = [UIColor redColor];
    
    CGFloat view_widht = (kSCREEN_WIDTH - sp_left*2);
    [self.scrollView addSubview:self.typeLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(view_widht);
        make.height.mas_equalTo(40);
    }];
    
    [self.scrollView addSubview:self.messageLab];
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.typeLab.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    CGFloat view_widht1 = (kSCREEN_WIDTH - sp_left*2 -16)/2.0;
    CGFloat view_height1 = 130;
    [self.scrollView addSubview:self.timeView1];
    [self.timeView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLab.mas_bottom).offset(32);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(view_widht1);
        make.height.mas_equalTo(view_height1);
    }];
   
    [self.scrollView addSubview:self.timeView2];
    [self.timeView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.messageLab.mas_bottom).offset(32);
        make.width.mas_equalTo(view_widht1);
        make.height.mas_equalTo(view_height1);
        make.right.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.timeView3];
    [self.timeView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView1.mas_bottom).offset(16);
        make.width.mas_equalTo(view_widht1);
        make.height.mas_equalTo(view_height1);
        make.left.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.timeView4];
    [self.timeView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView2.mas_bottom).offset(16);
        make.width.mas_equalTo(view_widht1);
        make.height.mas_equalTo(view_height1);
        make.right.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.timeView5];
    [self.timeView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView3.mas_bottom).offset(16);
        make.width.mas_equalTo(view_widht1);
        make.height.mas_equalTo(view_height1);
        make.left.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.okBtn];
    [self.okBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.timeView5.mas_bottom).offset(52);
        make.width.mas_equalTo(view_widht);
        make.height.mas_equalTo(64);
        make.left.mas_equalTo(0);
        make.bottom.mas_equalTo(-32);
    }];
    
    self.selectTimeNumber = 30;
    self.timeViewSelect = self.timeView1;
    [self.timeViewSelect selectForView:YES];
      
}

-(void)clickBtn:(UIButton*)button {
    NSLog(@"点击确认按钮");
    NSLog(@"选择的时间==== %ld",self.selectTimeNumber);
  
    if (self.device.isConnected) {
        __weak typeof(self) weakSelf = self;
        [self.device writeWithEventTwoByteCommand:BSPowerBankCmdClock_E_Time cmdValue:self.selectTimeNumber block:^(BOOL result, id  _Nullable responseDic) {
            NSLog(@"设置事件时间成功");
            [weakSelf setTimeWithSucceed];
        }];
    }
}

-(void)setTimeWithSucceed {
    __weak typeof(self) weakSelf = self;
    [YGAlertMessageTool alertMessage:@"时间设置成功" subMessage:@"" cancelTxt:@"" actionTxt:@"确定" handle:^(BSAlertMessageAction action, id object) {
        if (action == BSAlertMessageActionEvents ) {
            [weakSelf SettingDeviceSucceed];
        }
    }];
    [YGAlertMessageTool updateBgGestureEnable:NO];
}

-(void)SettingDeviceSucceed{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)eventsDidTouchedForView:(PowerBankTimeSetCellView *)view Type:(NSInteger)eventsType value:(NSInteger)value {
    
    if (self.timeViewSelect == view) {
        return;
    }
    [self.timeViewSelect selectForView:NO];
    self.timeViewSelect = view;
    if (eventsType == 1) {
        self.selectTimeNumber = value;
    } else if (eventsType == 2) {
        self.selectTimeNumber = value*60;
    }
    NSLog(@"选择的时间==== %ld",self.selectTimeNumber);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:32] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
        _typeLab.text = @"选择时间";
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558"]] ;
        _messageLab.text = @"设置计时结束时的提醒，避免错过重要时刻。,醒，避免错过重要时刻。";
        _messageLab.numberOfLines = 2;
    }
    return _messageLab;
}

-(PowerBankTimeSetCellView*)timeView1 {
    if (!_timeView1) {
        _timeView1 = [self addTimeViewWithType:1 time:30];
    }
    return _timeView1;
}

-(PowerBankTimeSetCellView*)timeView2 {
    if (!_timeView2) {
        _timeView2 = [self addTimeViewWithType:1 time:60];
    }
    return _timeView2;
}

-(PowerBankTimeSetCellView*)timeView3 {
    if (!_timeView3) {
        _timeView3 = [self addTimeViewWithType:1 time:90];
    }
    return _timeView3;
}

-(PowerBankTimeSetCellView*)timeView4 {
    if (!_timeView4) {
        _timeView4 = [self addTimeViewWithType:2 time:2];
    }
    return _timeView4;
}

-(PowerBankTimeSetCellView*)timeView5 {
    if (!_timeView5) {
        _timeView5 = [self addTimeViewWithType:2 time:3];
    }
    return _timeView5;
}

-(UIButton*)okBtn {
    if (!_okBtn) {
        UIButton* btnView = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnView setTitle:@"确定" forState:UIControlStateNormal];
        btnView.tag = 1;
        btnView.layer.cornerRadius = 32.0;
        btnView.backgroundColor = [UIColor bs_colorFromARGB:@"#004098"];
        btnView.layer.masksToBounds = YES ;
        [btnView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btnView addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
        _okBtn = btnView;
    }
    return _okBtn;
}

-(PowerBankTimeSetCellView*)addTimeViewWithType:(NSInteger)type time:(NSInteger)time {

    PowerBankTimeSetCellView *view = [PowerBankTimeSetCellView new];
    NSString *timeTypeStr = @"分钟";
    if (type == 2) {
        timeTypeStr = @"小时";
    }
    view.delegate = self;
    [view initAddViewWithType:type time:time timeType:@"小时"];
    return view;
}

@end
