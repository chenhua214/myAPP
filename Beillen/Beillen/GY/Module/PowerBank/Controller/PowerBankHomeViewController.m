//
//  PowerBankHomeViewController.m
//  Beillen
//
//  Created by chenyi on 2026/8/20.
//

#import "PowerBankHomeViewController.h"
#import "BSPowerBankHomeViewModel.h"


@interface PowerBankHomeViewController ()
@property (nonatomic, strong) UIScrollView *scrollView ;
@property (nonatomic, strong) BSPowerBankHomeViewModel *viewModel ;
@end

@implementation PowerBankHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    __weak typeof(self) weakSelf = self;
    self.viewModel.PowerBankValueChange = ^(BOOL isChangeValue) {
        
//        weakSelf.homeView.deviceModel = self.viewModel.device ;
    };
}



-(BSPowerBankHomeViewModel*)viewModel {
    if (!_viewModel) {
        _viewModel = [[BSPowerBankHomeViewModel alloc]initWithModel:self.model];
        [_viewModel initData ];
        
    }
    return _viewModel;
}

@end
