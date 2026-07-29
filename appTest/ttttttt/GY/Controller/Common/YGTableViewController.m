//
//  YGTableViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/29.
//

#import "YGTableViewController.h"

@interface YGTableViewController ()
@property (nonatomic, assign) UITableViewStyle tableStyle;

@end

@implementation YGTableViewController

- (instancetype)initWithStyle:(UITableViewStyle)style {
    if (self = [super init]) {
        self.tableStyle = style;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.notLoadTableView == NO) {
        [self.view addSubview:self.tableView];
    }
}


//代理方法
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //  NSAssert(tableView.rowHeight > 0, @"子类必须重写此方法");
    return tableView.rowHeight;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [UIView new];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - Set Get
//Set Get方法
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:self.tableStyle];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [UIView new];
        _tableView.tableFooterView = [UIView new];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [_tableView.separatorColor colorWithAlphaComponent:.5];
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            
        }
    }
    return _tableView;
}



@end
