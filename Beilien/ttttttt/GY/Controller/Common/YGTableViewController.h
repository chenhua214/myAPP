//
//  YGTableViewController.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/29.
//

#import "YGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface YGTableViewController : YGViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) BOOL notLoadTableView; // 不需要加载TableView
- (instancetype)initWithStyle:(UITableViewStyle)style;
@end

NS_ASSUME_NONNULL_END
