//
//  FirstLoginViewController.m
//  Beillen
//
//  Created by chenyi on 2026/9/29.
//

#import "FirstLoginViewController.h"
#import "YGNavigationController.h"
#import "YGHomeViewController.h"
#import "YGMineViewController.h"


@interface FirstLoginViewController ()
@property (nonatomic, strong) UIImageView *logView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIImageView *loginImageView;
//@property (nonatomic, strong) UIButton *loginBth;
@end

@implementation FirstLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.logView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_iamge1"]];
    self.logView.contentMode = UIViewContentModeScaleAspectFit ;
    self.loginImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_iamge2"]];
    self.loginImageView.contentMode = UIViewContentModeScaleAspectFit ;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn.frame = CGRectMake(0, 0, 20, 20);
    [btn setImage:[UIImage imageNamed:@"login_iamge3"] forState: UIControlStateNormal];
    self.loginBth = btn;
    CGFloat sp_left = 24;
    [self.view addSubview:self.logView];
    self.loginView = [UIView new];
    [self.view addSubview:self.loginView];
    [self.loginView addSubview:self.loginImageView];
    [self.view addSubview:self.loginBth];
//    [self.loginBth addTarget:self action:@selector(clickBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105);
//        make.top.equalTo(self.nameLab.mas_bottom).offset(20);
        make.height.mas_equalTo(144);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(105);
        make.top.equalTo(self.logView.mas_bottom).offset(10);
        make.height.mas_equalTo(310);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.loginImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(105);
//        make.top.equalTo(self.logView.mas_bottom).offset(10);
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.loginBth mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(105);
        make.top.equalTo(self.loginView.mas_bottom).offset(60);
      
        make.width.mas_equalTo(252);
        make.height.mas_equalTo(56);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.loginBth addTarget:self action:@selector(clickBnt) forControlEvents:UIControlEventTouchUpInside];
}

-(void)clickBnt{
    [self dismissViewControllerAnimated:YES completion:nil];
}



+ (void)loginAnimatedForNOWithVC:(YGViewController *)vc {
   
    dispatch_async(dispatch_get_main_queue(), ^{
        FirstLoginViewController *loginVC = [[FirstLoginViewController alloc]init];
        loginVC.superVC = vc;
        YGNavigationController *naVC = [[YGNavigationController alloc]initWithRootViewController:loginVC];
        naVC.modalPresentationStyle = UIModalPresentationFullScreen;
        [vc presentViewController:naVC animated:NO completion:^{
            
        }];
    });
}

@end
