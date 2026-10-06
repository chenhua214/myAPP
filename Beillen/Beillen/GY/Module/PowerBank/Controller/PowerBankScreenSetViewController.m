//
//  PowerBankScreenSetViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "PowerBankScreenSetViewController.h"
#import "BSPowerBankDevice.h"
#import "BSDeviceManager.h"
#import "PowerBankScreenSetView.h"
#import "PowerBankSetTimeViewController.h"

@interface PowerBankScreenSetViewController ()<PowerBankScreenSetViewDelegate>
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageTestView;
@property (nonatomic, strong) PowerBankScreenSetView *selectTimeView;
@property (nonatomic, strong) PowerBankScreenSetTextView *textView ;
@end

@implementation PowerBankScreenSetViewController


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
    self.title = @"屏幕设置";
    [self updateBackImgAndTitleFonts];

    
    CGFloat sp_left = 25;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(-30);
    }];
    
    [self.scrollView addSubview:self.imageTestView];
    [self.imageTestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.height.mas_equalTo(250);
    }];
    
    [self.scrollView addSubview:self.selectTimeView];
    [self.selectTimeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageTestView.mas_bottom).offset(sp_left);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.height.mas_equalTo(261);
    }];
    
    [self.scrollView addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.selectTimeView.mas_bottom).offset(sp_left);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.bottom.mas_equalTo(-40);
    }];
    [self updataForSetView];
    [self readDeviceCmd];
}

/// 代理  PowerBankScreenSetViewDelegate
///
-(void)eventsDidTouched:(NSInteger)eventsType value:(NSInteger)value{
    
    NSInteger LcdNumber = 0;
    NSInteger LcdTimeType = self.device.LcdTimeType;
    NSInteger LcdInteractType = self.device.LcdInteractType;
    NSInteger LcdTextColorType = self.device.LcdTextColorType;
    
    if (eventsType ==1) {
        NSLog(@"跳转到计时提醒界面");
        PowerBankSetTimeViewController *VC = [[PowerBankSetTimeViewController alloc]init];
        VC.model = self.model;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (eventsType == 2) {
        NSLog(@"显示时间开关===%ld",value);
        LcdTimeType = value;
    } else if (eventsType == 3) {
        NSLog(@"成就互动开关===%ld",value);
        LcdInteractType = value;
    } else if (eventsType == 4) {
        NSLog(@"文本颜色===%ld",value);
        LcdTextColorType = value;
    }
    LcdNumber = LcdTimeType + LcdInteractType * 2 + LcdTextColorType * 4 ;
    
    __weak typeof(self) weakSelf = self;
    if (self.device.isConnected) {
        [self.device writeWithSingleCommand:BSPowerBankCmdLcdSetting_RW_state cmdValue:LcdNumber block:^(BOOL result, id  _Nullable responseDic) {
            NSLog(@" 屏幕开关设置成功");
            [weakSelf readDeviceCmd];
        }];
    }
}

-(void)readDeviceCmd {
    
    __weak typeof(self) weakSelf = self;
    [self.device readSingleValueWithCommand:BSPowerBankCmdLcdSetting_RW_state block:^(BOOL result, id  _Nullable responseDic) {
        [weakSelf updataForSetView];
    }];
}

-(void)updataForSetView {
    [self.selectTimeView upDataWithLcdTimeType:self.device.LcdTimeType LcdInteractType:self.device.LcdInteractType];
    [self.textView upDataForViewWithType:self.device.LcdTextColorType];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (UIImageView *)imageTestView {
    if (!_imageTestView) {
        _imageTestView = [UIImageView new];
        _imageTestView.contentMode = UIViewContentModeScaleAspectFit;
        _imageTestView.image = [UIImage imageNamed:@"pank_screen_set_top_icon"];
    }
    return _imageTestView;
}

- (PowerBankScreenSetView *)selectTimeView {
    if (!_selectTimeView) {
        _selectTimeView = [PowerBankScreenSetView new];
        [_selectTimeView initAddViewWithType:1];
        _selectTimeView.delegate = self;
       
    }
    return _selectTimeView;
}

-(PowerBankScreenSetTextView*)textView {
    if (!_textView ){
        _textView = [PowerBankScreenSetTextView new];
        [_textView initAddViewWithType:self.device.LcdTextColorType];
        _textView.delegate = self;
    }
    return _textView;
}

@end
