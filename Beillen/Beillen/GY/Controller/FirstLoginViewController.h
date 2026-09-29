//
//  FirstLoginViewController.h
//  Beillen
//
//  Created by chenyi on 2026/9/29.
//

#import "YGViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FirstLoginViewController : YGViewController
@property (nonatomic, strong) UIButton *loginBth;
@property (nonatomic,   weak) YGViewController *superVC;
+ (void)loginAnimatedForNOWithVC:(YGViewController *)vc;
@end

NS_ASSUME_NONNULL_END
