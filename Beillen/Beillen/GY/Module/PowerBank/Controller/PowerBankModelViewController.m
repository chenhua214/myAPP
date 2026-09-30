//
//  PowerBankModelViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "PowerBankModelViewController.h"
#import "BSPowerBankDevice.h"
#import "BSDeviceManager.h"
#import "PowerBankModelCellView.h"
@interface PowerBankModelViewController ()
@property (nonatomic, strong) BSPowerBankDevice *device;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) PowerBankModelCellView *modelView1;
@property (nonatomic, strong) PowerBankModelCellView *modelView2;
@property (nonatomic, strong) PowerBankModelCellView *modelView3;

@property (nonatomic, strong) UIButton *selectModelBtn;

@end

@implementation PowerBankModelViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.device = (BSPowerBankDevice *)[[BSDeviceManager shareInstance] findDeviceWithIdentifier:self.model.sn];
    self.view.backgroundColor  = self.bs_backgroundColor  = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"充电模式";
    [self updateBackImgAndTitleFonts];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.modelView1];
    [self.scrollView addSubview:self.modelView2];
    [self.scrollView addSubview:self.modelView3];
    
    [self.modelView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.height.mas_equalTo(246);
    }];
    [self.modelView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelView1.mas_bottom).offset(24);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.height.mas_equalTo(246);
    }];
    [self.modelView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.modelView2.mas_bottom).offset(24);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
        make.height.mas_equalTo(246);
        make.bottom.mas_equalTo(-20);
    }];
    [self readCommand];
}

- (void)createUI{
    
}

-(void)updataForView {
    self.selectModelBtn.selected = NO;
    if (self.device.typeC1.inputModelSet == 1) {
        self.selectModelBtn = self.modelView2.selectBtn;
    } else if (self.device.typeC1.inputModelSet == 2) {
        self.selectModelBtn = self.modelView3.selectBtn;
    } else {
        self.selectModelBtn = self.modelView1.selectBtn;
    }
    self.selectModelBtn.selected = YES;
}

-(void)readCommand {
    __weak typeof(self) weakSelf = self;
    [self.device readValueWithStartCommand:BSPowerBankCmdInputType_RW_state_C1 endCommand:BSPowerBankCmdInputType_RW_state_C2 block:^(BOOL result, id  _Nullable responseDic) {
        [weakSelf updataForView];
    }];
}


-(void)selectModelforBtn:(UIButton*)button {
    NSInteger tag = button.tag ;
    if (self.selectModelBtn == button) {
        return;
    }
    self.selectModelBtn.selected = NO;
    button.selected = YES;
    self.selectModelBtn = button;
    
    __weak typeof(self) weakSelf = self;
    [self.device writeWithSingleCommand:BSPowerBankCmdInputType_RW_state_C1 cmdValue:tag block:^(BOOL result, id  _Nullable responseDic) {
//        [weakSelf updataForView];
        [weakSelf readCommand];
    }];
    [self.device writeWithSingleCommand:BSPowerBankCmdInputType_RW_state_C2 cmdValue:tag block:^(BOOL result, id  _Nullable responseDic) {
//        weakSelf.selectModelBtn.selected = YES;
    }];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

- (PowerBankModelCellView *)modelView1 {
    if (!_modelView1) {
        PowerBankModelCellView *view = [PowerBankModelCellView new];
        [view initAddViewWithType:1];
        [view.selectBtn addTarget:self action:@selector(selectModelforBtn:) forControlEvents:UIControlEventTouchUpInside];
        _modelView1 = view;
    }
    return _modelView1;
}

- (PowerBankModelCellView *)modelView2 {
    if (!_modelView2) {
        PowerBankModelCellView *view = [PowerBankModelCellView new];
        [view initAddViewWithType:2];
        [view.selectBtn addTarget:self action:@selector(selectModelforBtn:) forControlEvents:UIControlEventTouchUpInside];
        _modelView2 = view;
    }
    return _modelView2;
}

- (PowerBankModelCellView *)modelView3 {
    if (!_modelView3) {
        PowerBankModelCellView *view = [PowerBankModelCellView new];
        [view initAddViewWithType:3];
        [view.selectBtn addTarget:self action:@selector(selectModelforBtn:) forControlEvents:UIControlEventTouchUpInside];
        _modelView3 = view;
    }
    return _modelView3;
}

@end
