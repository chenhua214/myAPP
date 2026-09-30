//
//  PowerBankCredentialViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "PowerBankCredentialViewController.h"

@interface PowerBankCredentialViewController ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *imageTestView;
@end

@implementation PowerBankCredentialViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_showNavigationBarWithAnimated:animated];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.notLoadTableView = YES;
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.view.backgroundColor  = self.bs_backgroundColor  = [UIColor bs_colorFromARGB:@"F6F8FA"];
    self.title = @"认证资质";
    [self updateBackImgAndTitleFonts];
    
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    self.imageTestView = [[UIImageView alloc]init];
    self.imageTestView.image = [UIImage imageNamed:@"pank_modelView_cell_test"];
    [self.scrollView addSubview:self.imageTestView];
    [self.imageTestView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-30);
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

@end
