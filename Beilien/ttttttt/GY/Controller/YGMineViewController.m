//
//  YGMineViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGMineViewController.h"
#import "BSMineListCell.h"
#import "BSMineModel.h"

#define kDefaultHeaderHeight  isIpad ? 279 : bsValue(269.0)
@interface YGMineViewController ()<UIScrollViewDelegate>
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) UIView *tableSuperView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, strong) NSMutableArray<BSMineSectionModel *> *datas;

@end

@implementation YGMineViewController

- (void)viewDidLoad {
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
    // if (!self.presentedViewController) {
    //     //如果是present时,不显示导航栏
    //     [self bs_showNavigationBarWithAnimated:animated];
    // }
    [[self class] cancelPreviousPerformRequestsWithTarget:self];
}

- (void)setup{
    self.view.backgroundColor = self.tableView.backgroundColor = [UIColor bs_colorFromARGB:@"#F2F4F8"];
    [self configTableView];
    [self createUI];
    [self setupConstraints];
    [self configUserInfo];
    [self addNotifications];
}

- (void)createUI{
    [self.view addSubview:self.scrollView];
    [self.scrollView addSubview:self.contentView];
    [self.contentView addSubview:self.headerView];
    [self.contentView addSubview:self.tableSuperView];
    [self.tableSuperView addSubview:self.tableView];
}

- (void)setupConstraints{
    
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.scrollView);
        make.centerX.equalTo(self.scrollView.mas_centerX);
    }];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.right.mas_equalTo(0);
        make.height.mas_equalTo(kDefaultHeaderHeight);
    }];
    
    [self.tableSuperView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.headerView.mas_bottom).offset(-Height812(23));
        make.left.mas_equalTo(23);
        make.right.mas_equalTo(-23);
        make.height.mas_greaterThanOrEqualTo(0);
        make.bottom.mas_equalTo(-20);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.tableSuperView);
        make.height.mas_greaterThanOrEqualTo(0);
    }];
}

- (void)configUserInfo {
//    self.headerView.nickeName = [BSConfigManager sharedInstance].nickname;
//    self.headerView.avter = [BSConfigManager sharedInstance].avatar;
//    self.headerView.numberOfDevices = [BSConfigManager sharedInstance].totalDeviceCount;
    [self.tableView reloadData];
    CGFloat tableViewHeight = 0.0;
    for (BSMineSectionModel * section in self.datas) {
        for (BSMineCellModel * model in section.models) {
            tableViewHeight += model.rowHeight;
        }
    }
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(tableViewHeight);
    }];
}

- (void)configTableView {
    self.tableView.scrollEnabled = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.layer.masksToBounds = TRUE;
    self.tableView.layer.cornerRadius = 20;
    [self.tableView registerClass:BSMineListCell.class forCellReuseIdentifier:NSStringFromClass(BSMineListCell.class)];
}

#pragma mark 切换App语言通知
- (void)chengeLanguage:(NSNotification *)notice
{
    self.datas = [NSMutableArray arrayWithArray:[BSMineModel datas]];
    [self.tableView reloadData];
//    [self.headerView updateOnChangeLanguages];
}

- (void)addNotifications {
    
    /// 根据需求添加通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configUserInfo) name:kBSLoginStateChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configUserInfo) name:kBSUserInfoChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(configUserInfo) name:kBSUserInfoRefreshNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chengeLanguage:) name:kBChangeLanguageSuccessNotification object:nil];
}





#pragma mark - Private methods 点击方法

- (void)tableView:(UITableView *)tableView actionForModel:(BSMineCellModel *)model{
    if([BSMineModel disabledWithType:model.type]){
        return;
    }
    if([BSMineModel shouldShowLoginWithType:model.type]){
//        [BSLoginThirdController loginWithVC:self];
        return;
    }
    switch (model.type) {
        case BSMineCellTypeShare:
        {
//            BSDeviceShareViewController *vc = [BSDeviceShareViewController new];
//            vc.navigationItem.title = model.title;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeMessages:
        {
//            BSMessageCentreViewController *vc = [[BSMessageCentreViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeServiceCenter:
        {
//            BSServiceCenterViewController *vc = [[BSServiceCenterViewController alloc]init];
//            vc.embeddedTabBar = NO;
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeFeedback:
        {
//            BSFeedbackListViewController *vc = [[BSFeedbackListViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeSetting:
        {
//            BSMineSettingViewController *vc = [[BSMineSettingViewController alloc]init];
//            vc.userAccountLogoutSuccess = ^(NSInteger Type) {
//                [BSLoginThirdController loginAnimatedForNOWithVC:self];
//            };
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeAboutBaseus:
        {
//            BSAboutViewController *vc = [[BSAboutViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        case BSMineCellTypeBuyGoods:
        {
//            BSStoreAppToGoodsViewController *vc = [[BSStoreAppToGoodsViewController alloc]init];
//            [self.navigationController pushViewController:vc animated:YES];
        }
            break;
        default:
            break;
    }
}

//#pragma mark - BSMineHeaderViewDelegate
//   暂时不需要
//- (void)headerView:(BSMineHeaderView *)headerView actionWithType:(BSMineHeaderActionType)type{
//    if (![BSConfigManager sharedInstance].isLogin) {
//        [BSLoginThirdController loginWithVC:self];
//        return;
//    }
//    BSUserInfoViewController *vc = [[BSUserInfoViewController alloc]init];
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.datas[indexPath.section].models[indexPath.row].rowHeight;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas[section].models.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSMineListCell *cell = [BSMineListCell cellForTableView:tableView indexPath:indexPath];
    NSArray *models = self.datas[indexPath.section].models;
    BSMineCellModel *model = models[indexPath.row];
    [cell setIconNamed:model.iconName title:model.title corner:model.corner disabled:[BSMineModel disabledWithType:model.type] top:model.top bottom:model.bottom];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSMineCellModel *model = self.datas[indexPath.section].models[indexPath.row];
    [self tableView:tableView actionForModel:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - set and get

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.backgroundColor = [UIColor clearColor];
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

- (UIView *)tableSuperView {
    if(!_tableSuperView) {
        _tableSuperView = [[UIView alloc]init];
        _tableSuperView.layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.05].CGColor;
        _tableSuperView.layer.shadowOffset = CGSizeMake(0, 10);
        _tableSuperView.layer.shadowOpacity = 1;
        _tableSuperView.layer.shadowRadius = 23;
    }
    return _tableSuperView;
}

- (NSMutableArray<BSMineSectionModel *> *)datas{
    if (!_datas) {
        _datas = [NSMutableArray arrayWithArray:[BSMineModel datas]];
    }
    return _datas;
}

@end
