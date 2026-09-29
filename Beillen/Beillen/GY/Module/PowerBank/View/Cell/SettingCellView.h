//
//  SettingCellView.h
//  Beillen
//
//  Created by chenyi on 2026/9/23.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SettingCellView : UIView
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *messageLab;
/// 黑点
@property (nonatomic, strong) UIView *iconSpotView;
-(void)initAddView;
-(void)initAddViewWithType:(NSInteger)typeView
                      type:(NSString*)type
                   message:(NSString*)message
                      icon:(NSString*)icon
                  showLine:(BOOL)hidden;
@end

NS_ASSUME_NONNULL_END
