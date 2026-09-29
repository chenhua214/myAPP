//
//  SegmentedView.h
//  Beillen
//
//  Created by chenyi on 2026/9/17.
//

#import <UIKit/UIKit.h>
#import "BSPowerBankDevice.h"
NS_ASSUME_NONNULL_BEGIN


@interface selectTypeView : UIView
///（必须） 文案正常颜色 (默认黑色)
@property (nonatomic, strong) UIColor *titleNormalColor;

/// 文案选中颜色 (默认为 titleNormalColor )
@property (nonatomic, strong) UIColor *titleSelectedColor;

///（必须） 文案正常字体
@property (nonatomic, strong) UIFont *titleNormalFont;

/// 文案选中字体 （默认为 titleNormalFont ）
@property (nonatomic, strong) UIFont *titleSelectedFont;


///（必须）选中的背景的颜色
@property (nonatomic, strong) UIColor *selectBgColor;
///（必须）选择器的背景颜色
@property (nonatomic, strong) UIColor *BgColor;
/// 背景弧度
@property (nonatomic, assign) CGFloat BgShadowRadius;
@property (nonatomic, assign) CGFloat selectBgShadowRadius;

@property (nonatomic, assign) CGFloat itemWidth;
/// 界面高度
@property (nonatomic, assign) CGFloat viewWidth;
@property (nonatomic, strong) NSArray *arrItems;
/// 当前选择的 Index
@property (nonatomic, assign) NSInteger selectedIndex;
-(void)initAddView;
@end




#pragma mark   线材信息view   ============
@interface TypeMessageView : UIView
-(void)initAddView;
@end

@interface SelectTypeMessageView : UIView
-(void)initAddView;
@end


#pragma mark   开关选择 cellview   ============
@interface TypeSwitchCellView : UIView
//-(void)initAddViewWithType:(NSInteger)typeView;
-(void)initAddViewWithType:(NSInteger)typeView type:(NSString*)type icon:(NSString*)icon;
@end


#pragma mark   电池信息 cellview   ============
@interface BatteryInfoView : UIView
@property (nonatomic, strong) UIButton *rightBtn;
-(void)initAddView;
@end

#pragma mark   线材Type选择view   ============
@interface SegmentedView : UIView
/// 电池信息
@property (nonatomic, strong) BatteryInfoView *batteryView;
@property (nonatomic,strong) BSPowerBankDevice *deviceModel ;
-(void)initAddView;
@end

NS_ASSUME_NONNULL_END
