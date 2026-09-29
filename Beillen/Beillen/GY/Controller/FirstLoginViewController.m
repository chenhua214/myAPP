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


@interface FirstLoginViewController ()<UITextFieldDelegate>
@property (nonatomic, strong) UIImageView *logView;
@property (nonatomic, strong) UIView *loginView;
@property (nonatomic, strong) UIImageView *loginBgView;
//@property (nonatomic, strong) UIImageView *loginBgView;
@property (nonatomic, strong) UIButton *headBth;
@property (nonatomic, strong) UIImageView *textFieldBgView;
@property (nonatomic, strong) UITextField *loginTextView;
@property (nonatomic, strong) UIButton *loginBth;
@end

@implementation FirstLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    CGFloat sp_left = 24;
    [self.view addSubview:self.logView];
    [self.view addSubview:self.loginView];
    [self.loginView addSubview:self.loginBgView];
    [self.loginView addSubview:self.headBth];
    [self.loginView addSubview:self.textFieldBgView];
    [self.loginView addSubview:self.loginTextView];
    [self.view addSubview:self.loginBth];
    [self.view addSubview:self.loginTextView];
    [self.logView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(105);
        make.height.mas_equalTo(144);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.loginView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.logView.mas_bottom).offset(10);
        make.height.mas_equalTo(310);
        make.left.mas_equalTo(sp_left);
        make.right.mas_equalTo(-sp_left);
    }];
    
    [self.loginBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    [self.headBth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(33);
        make.width.height.mas_equalTo(96);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.textFieldBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(33);
        make.right.mas_equalTo(-33);
        make.height.mas_equalTo(56);
        make.bottom.equalTo(self.loginView.mas_bottom).offset(-33);
    }];
    
    [self.loginTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textFieldBgView.mas_left).offset(52);
        make.right.mas_equalTo(-33);
        make.height.mas_equalTo(56);
        make.bottom.equalTo(self.loginView.mas_bottom).offset(-33);

    }];
    
    [self.loginBth mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.loginView.mas_bottom).offset(60);
      
        make.width.mas_equalTo(252);
        make.height.mas_equalTo(56);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.loginBth addTarget:self action:@selector(clickBnt) forControlEvents:UIControlEventTouchUpInside];
    [BSGuestModeHelper switchUsageMode:BSUsageModeGuest callback:^{
//        [self dismissAndEnterInfoGuestMode];
    }];
}

-(void)clickBnt{

    if ( self.loginTextView.text.isEnable) {
        [BSConfigManager sharedInstance].nickname = self.loginTextView.text;
        [[NSNotificationCenter defaultCenter] postNotificationName:kBChangeNicknameSuccessNotification object:nil];
//        [BSConfigManager sharedInstance].avatar;  // 图片名称
    }
 
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(UITextField*)loginTextView {
    if (!_loginTextView) {
        UITextField *textFeild = [UITextField new];
//        请输入您的名称
        textFeild.font = bsFontRegular(16);
        textFeild.textColor = bsColorString(@"#191C1E");
        textFeild.placeholder = @"请输入您的名称";
        textFeild.delegate = self;
        _loginTextView = textFeild;
    }
    return _loginTextView;
}

-(UIImageView*)logView {
    if (!_logView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_iamge1"]];
        view.contentMode = UIViewContentModeScaleAspectFit ;
        _logView = view;
    }
    return _logView;
}

-(UIView*)loginView {
    if (!_loginView) {
        UIView *view = [UIView new];
        _loginView = view;
    }
    return _loginView;
}


-(UIImageView*)loginBgView {
    if (!_loginBgView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_iamge2"]];
        view.contentMode = UIViewContentModeScaleAspectFit ;
        _loginBgView = view;
    }
    return _loginBgView;
}



-(UIButton*)headBth {
    if (!_headBth) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [btn setImage:[UIImage imageNamed:@"login_head_icon"] forState: UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"home_banner1"] forState: UIControlStateNormal];
        
        btn.layer.cornerRadius = 48;
        btn.layer.masksToBounds = YES;
        _headBth = btn;
    }
    return _headBth;
}

-(UIImageView*)textFieldBgView {
    if (!_textFieldBgView) {
        UIImageView *view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"login_textField_bg"]];
        view.contentMode = UIViewContentModeScaleAspectFit ;
        _textFieldBgView = view;
    }
    return _textFieldBgView;
}


-(UIButton*)loginBth {
    if (!_loginBth) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setImage:[UIImage imageNamed:@"login_iamge3"] forState: UIControlStateNormal];
        _loginBth = btn;
    }
    return _loginBth;
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
