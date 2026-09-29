//
//  LanguageViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/28.
//

#import "LanguageViewController.h"
#import "SettingCellView.h"
#import "BSMineModel.h"
@interface LanguageViewController ()
@property (nonatomic, strong) UILabel *nameLab;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SettingCellView *language1CellView;
@property (nonatomic, strong) SettingCellView *language2CellView;
@property (nonatomic, assign) CGFloat viewTop;
@end

@implementation LanguageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    self.title = @"切换语言";
    [self updateBackImgAndTitleFonts];
    [self setup];
    if (self.viewType == 2) {
        self.language2CellView.rightBtn.selected = YES;
        self.language2CellView.iconSpotView.hidden = NO;
    } else {
        self.language1CellView.rightBtn.selected = YES;
        self.language1CellView.iconSpotView.hidden = NO;
    }
}

- (void)setup{
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"#F7F9FB"];
    [self.view addSubview:self.nameLab];
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];

    CGFloat sp_left = 24;
    [self.nameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(32);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLab.mas_bottom).offset(20);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
    }];
    
    self.language1CellView =  [self addSettingCellViewIcon:@"" name:@"简体中文" message:@"" cellType:1 showLine:YES];
    self.language2CellView = [self addSettingCellViewIcon:@"" name:@"English" message:@"" cellType:2 showLine:NO];
}


/////  clickBtn
-(void)clickBtnForType:(UIButton*)btn {
 
    NSInteger tag = btn.tag;
    NSString *languageStr = @"简体中文";
    if (tag == 1) {
        NSLog(@"点击按钮111 ");
        self.language1CellView.rightBtn.selected = YES;
        self.language1CellView.iconSpotView.hidden = NO;
        self.language2CellView.rightBtn.selected = NO;
        self.language2CellView.iconSpotView.hidden = YES;
        languageStr = self.language1CellView.typeLab.text;
    } else if (tag == 2) {
        NSLog(@"点击按钮2222 ");
        self.language2CellView.rightBtn.selected = YES;
        self.language2CellView.iconSpotView.hidden = NO;
        self.language1CellView.rightBtn.selected = NO;
        self.language1CellView.iconSpotView.hidden = YES;
        languageStr = self.language2CellView.typeLab.text;
    }
    
    [self showHudInWindow];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self hideHud];
        [[NSNotificationCenter defaultCenter] postNotificationName:kBChangeLanguageSuccessNotification object:languageStr];
        [self.navigationController popToRootViewControllerAnimated:YES];
    });
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        view.layer.cornerRadius = 30;
        view.layer.borderColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.3].CGColor;
        view.layer.borderWidth = 1;

        _bgView = view;
    }
    return _bgView;
}

-(UILabel*)nameLab {
    if (!_nameLab) {
        _nameLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#454558"]];
        _nameLab.text = @"请选择您偏好的显示语言";
    }
    return _nameLab;
}

-(SettingCellView *)addSettingCellViewIcon:(NSString*)icon
                         name:(NSString*)name
                      message:(NSString*)message
                     cellType:(BSMineCellType)cellType
                     showLine:(BOOL)showLine {
    
    SettingCellView *view = [SettingCellView new];
    [view.rightBtn addTarget:self action:@selector(clickBtnForType:) forControlEvents:UIControlEventTouchUpInside];
    view.rightBtn.tag = cellType;
    [view initAddViewWithType:5 type:name message:message icon:icon showLine:showLine];
    
    [self.bgView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.viewTop);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(80);
        if (showLine==NO) {
            make.bottom.mas_equalTo(0);
        }
    }];
    self.viewTop = self.viewTop + 80;
    return view;
}

@end
