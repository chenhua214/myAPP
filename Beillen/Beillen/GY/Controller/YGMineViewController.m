//
//  YGMineViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGMineViewController.h"
#import "BSMineListCell.h"
#import "BSMineModel.h"
#import "SettingCellView.h"
#import "LanguageViewController.h"
#import "AboutAPPViewController.h"
#define kDefaultHeaderHeight  isIpad ? 230 : 235

@interface YGMineViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIImageView *userIconView;
@property (nonatomic, strong) UILabel *userNameLab;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) SettingCellView *languageCellView;
@property (nonatomic, strong) SettingCellView *aboutAPPCellView;
@property (nonatomic, strong) UILabel *appLogLab;
@property (nonatomic, assign) CGFloat viewTop;
@property (nonatomic, strong) NSString *languageStr;
@property (nonatomic, assign) NSInteger languageType;
//© 2026 Beillen 嘉德科技

@property (nonatomic, strong) NSMutableArray<BSMineSectionModel *> *datas;

@end

@implementation YGMineViewController

- (void)viewDidLoad {
    self.notLoadTableView = YES;
    [super viewDidLoad];
    [self setup];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self bs_hideNavigationBarWithAnimated:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        self.headerView.numberOfDevices = [BSConfigManager sharedInstance].totalDeviceCount;
    });
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     if (!self.presentedViewController) {
         //如果是present时,不显示导航栏
         [self bs_showNavigationBarWithAnimated:animated];
     }
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setup{
    self.view.backgroundColor = self.bs_backgroundColor = [UIColor bs_colorFromARGB:@"#F7F9FB"];
   
    [self createUI];
    [self setupConstraints];
    [self configUserInfo];
    [self addNotifications];
}

- (void)createUI{
    [self.view addSubview:self.contentView];
    self.contentView.backgroundColor = self.view.backgroundColor;
    [self.contentView addSubview:self.headerView];
    [self.headerView addSubview:self.userIconView];
    [self.headerView addSubview:self.userNameLab];
    
    [self.contentView addSubview:self.scrollView];
    [self.scrollView addSubview:self.bgView];
    [self.scrollView addSubview:self.appLogLab];
    
//    [self.bgView addSubview:self.languageCellView];
//    [self.bgView addSubview:self.aboutAPPCellView];
    
}

- (void)setupConstraints{
    CGFloat sp_left = 24;
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
        make.top.mas_equalTo(StatusBar_HEIGHT);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kDefaultHeaderHeight);
    }];
    
    [self.userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(20);
        make.size.mas_equalTo(CGSizeMake(120, 120));
        make.centerX.mas_equalTo(0);
    }];
    [self.userNameLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.userIconView.mas_bottom).offset(24);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(0);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
//        make.height.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(-110);
    }];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
//        make.top.mas_equalTo(45);
//        make.height.mas_equalTo(2365);
        make.width.mas_equalTo(self.scrollView).offset(0);
    }];
    
    self.languageStr = @"简体中文";
    self.languageCellView =  [self addSettingCellViewIcon:@"my_cell_language" name:@"切换语言" message:self.languageStr cellType:BSMineCellTypeRegion showLine:YES];
    self.aboutAPPCellView = [self addSettingCellViewIcon:@"my_cell_aboutApp" name:@"关于 APP" message:@"V.2.4.0" cellType:BSMineCellTypeAboutBaseus showLine:NO];
    
    [self.appLogLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bgView.mas_bottom).offset(38);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
        make.bottom.mas_equalTo(-20);
    }];
    self.userIconView.image = [UIImage imageNamed:@"home_banner3"];
    
    self.userNameLab.text = [BSConfigManager sharedInstance].nickname;
    self.appLogLab.text = @"© 2026 Beillen 嘉德科技 ";
}

- (void)configUserInfo {

}


/////  clickBtn
-(void)clickBtnForType:(UIButton*)btn {
 
    NSInteger tag = btn.tag;    if (tag == BSMineCellTypeRegion) {
        NSLog(@"点击按钮2222 语言");
        LanguageViewController *VC = [[LanguageViewController alloc]init];
        VC.viewType = self.languageType;
        [self.navigationController pushViewController:VC animated:YES];
    } else if (tag == BSMineCellTypeAboutBaseus) {
        NSLog(@"点击按钮2222 关于APP");
        
        AboutAPPViewController *VC = [[AboutAPPViewController alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}


#pragma mark 切换App语言通知
- (void)chengeLanguage:(NSNotification *)notice
{
    NSString *objectStr = notice.object;
    if ([objectStr isEqualToString:@"English"]) {
        self.languageType = 2;
    } else {
        self.languageType = 1;
    }
    self.languageCellView.messageLab.text = objectStr;
}
#pragma mark 修改name通知

- (void)chengeNikeName:(NSNotification *)notice
{
    self.userNameLab.text = [BSConfigManager sharedInstance].nickname;
}

- (void)addNotifications {
    
    /// 根据需求添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chengeLanguage:) name:kBChangeLanguageSuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chengeNikeName:) name:kBChangeNicknameSuccessNotification object:nil];
}


#pragma mark - set and get

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
    }
    return _scrollView;
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

-(UILabel*)userNameLab {
    if (!_userNameLab) {
        _userNameLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:24] textAlignment:NSTextAlignmentCenter textColor:[UIColor bs_colorFromARGB:@"#004098"]];
        
    }
    return _userNameLab;
}

-(UIImageView*)userIconView{
    if (!_userIconView) {
        _userIconView = [UIImageView new];
        _userIconView.layer.cornerRadius = 60.0;
        _userIconView.layer.masksToBounds = YES;
    }
    return _userIconView;
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
