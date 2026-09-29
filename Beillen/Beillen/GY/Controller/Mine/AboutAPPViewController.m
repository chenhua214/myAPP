//
//  AboutAPPViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/28.
//

#import "AboutAPPViewController.h"
#import "SettingCellView.h"
#import "BSMineModel.h"
@interface AboutAPPViewController ()
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *logIconView;
@property (nonatomic, strong) UILabel *appNameLab;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *appLogLab;
@property (nonatomic, assign) CGFloat viewTop;

@end

@implementation AboutAPPViewController

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    self.edgesForExtendedLayout =  UIRectEdgeNone;
    [super viewDidLoad];
    self.title = @"关于Beillen";
    [self setup];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setup{
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"#F7F9FB"];
    [self createUI];
    [self setupConstraints];
}

- (void)createUI{
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = self.view.backgroundColor;
    [self.contentView addSubview:self.headerView];
    [self.headerView addSubview:self.logIconView];
    [self.headerView addSubview:self.appNameLab];
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    [self.scrollView addSubview:self.appLogLab];
}

- (void)setupConstraints{
    CGFloat sp_left = 24;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(240);
    }];
    
    [self.logIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(160, 160));
        make.centerX.mas_equalTo(0);
    }];
    [self.appNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logIconView.mas_bottom).offset(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(0);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.scrollView).offset(0);
    }];
    
    [self addSettingCellViewIcon:@"my_cell_aboutApp" name:@"APP版本" message:@"V.2.4.0" cellType:1 showLine:YES];
    [self addSettingCellViewIcon:@"my_cell_language" name:@"官网" message:@"www.beillen.com" cellType:2 showLine:YES];
    [self addSettingCellViewIcon:@"my_cell_phone" name:@"电话" message:@"400-888-8888" cellType:3 showLine:YES];
    [self addSettingCellViewIcon:@"my_cell_email" name:@"邮箱" message:@"support@beillen.com" cellType:4 showLine:YES];
    [self addSettingCellViewIcon:@"my_cell_app_number" name:@"APP备案号" message:@"粤ICP备xxxxxxxx号" cellType:5 showLine:NO];
    
    [self.appLogLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(38);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(-20);
    }];
    
    self.appNameLab.text =@"Beillen";
    self.appLogLab.text = @"© 2026 Beillen 嘉德科技 ";
    self.logIconView.image = [UIImage imageNamed:@"my_aboubAPP_appLog"];
}

/////  clickBtn
-(void)clickBtnForType:(UIButton*)btn {
    
}

- (UIView *)contentView{
    if (!_contentView) {
        _contentView = [UIView new];
    }
    return _contentView;
}

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
    }
    return _headerView;
}

-(UILabel*)appNameLab {
    if (!_appNameLab) {
        _appNameLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:24] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#004098"]];
    }
    return _appNameLab;
}

-(UIImageView*)logIconView{
    if (!_logIconView) {
        _logIconView = [UIImageView new];
        _logIconView.layer.masksToBounds = YES;
    }
    return _logIconView;
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

-(UILabel*)appLogLab {
    if (!_appLogLab) {
        _appLogLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:14] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#757589"]];
        
    }
    return _appLogLab;
}

-(SettingCellView *)addSettingCellViewIcon:(NSString*)icon
                         name:(NSString*)name
                      message:(NSString*)message
                     cellType:(BSMineCellType)cellType
                     showLine:(BOOL)showLine {
    SettingCellView *view = [SettingCellView new];
    [view.rightBtn addTarget:self action:@selector(clickBtnForType:) forControlEvents:UIControlEventTouchUpInside];
    view.rightBtn.tag = cellType;
    [view initAddViewWithType:4 type:name message:message icon:icon showLine:showLine];
    
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
