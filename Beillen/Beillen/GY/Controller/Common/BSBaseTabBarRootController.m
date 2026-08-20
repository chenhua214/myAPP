//
//  BSBaseTabBarRootController.m
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import "BSBaseTabBarRootController.h"

@interface BSBaseTabBarRootController ()

@end

@implementation BSBaseTabBarRootController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.contentTextView];
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.isTabBarRootVC?0:0);
    }];
    if (self.notLoadTableView == NO) {
        [self.contentTextView addSubview:self.tableView];
    }
    
    
//    // 关键代码
//    [NSLayoutConstraint activateConstraints:@[
//        [self.contentTextView.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor],
//         [self.contentTextView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor constant:-20]
//    ]];
//    
//    
//    // 假设 scrollView 占满全屏
//    self.contentTextView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
//    // 但内部内容的底部约束应指向 safeAreaLayoutGuide
//    contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true

    
    
    
}

- (void)setTabBarItemTitle:(NSString *)title; {
    self.tabBarItem.title = title;
}

- (UIView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UIView alloc] init];
    }
    return _contentTextView;
}


@end
