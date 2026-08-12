//
//  YGHomeViewController.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import "YGHomeViewController.h"
#import "YGSearchDeviceViewController.h"
#import "BSDeviceDBHelper.h"
#import "BSHomeModel.h"

@interface YGHomeViewController ()
/// Device 数据
@property (nonatomic, strong) BSHomeDataModel *dataModel;
@end

@implementation YGHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    self.title =@"11111";
    
//    self.tabBarItem.title = @"22222";;
    UIButton *addLab = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:addLab];
    [addLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.mas_equalTo(60);
        make.height.mas_equalTo(50);
        make.width.mas_equalTo(120);
    }];
//    addLab set = @"添加设备";
    [addLab  setTitle:@"添加设备" forState:UIControlStateNormal];
    
    addLab.titleLabel.font = [UIFont bs_regularFontWithFontSize:16];
    [addLab setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [addLab addTarget:self action:@selector(addDevice_pushVC) forControlEvents:UIControlEventTouchUpInside];
  
    
    
    // Do any additional setup after loading the view.
    [self enterIntoGeustMode];
    [self requestHomeData];
}


/// 获取首页数据
-(void)requestHomeData {
    if (IS_GUEST_MODE) {
        [BSDeviceDBHelper allDevicesWithCallback:^(BOOL result, id responseData) {
            if (result && responseData) {
                BSHomeDataModel* homeDataModel = [BSHomeDataModel new];
                homeDataModel.devices = [(NSArray *)responseData copy];
                NSLog(@"dataALL %ld",(unsigned long)homeDataModel.devices.count);
            }
            //            if (self.allInfoSubject) [self.allInfoSubject sendNext:homeDataModel];
        }];
    }
//        return;
}

-(void)addDevice_pushVC{
    NSLog(@"添加设备");
    YGSearchDeviceViewController *vc = [[YGSearchDeviceViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)enterIntoGeustMode{
    [BSGuestModeHelper switchUsageMode:BSUsageModeGuest callback:^{
        [self dismissAndEnterInfoGuestMode];
    }];
}

- (void)dismissAndEnterInfoGuestMode {
    [BSUserDefaults setBool:YES forKey:kBSDidUsedGuestMode];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBSLoginStateChangedNotification object:nil];
    [self dismissViewControllerAnimated:YES completion:^{}];
}

@end
