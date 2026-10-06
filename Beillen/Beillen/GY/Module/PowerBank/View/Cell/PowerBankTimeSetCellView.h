//
//  PowerBankTimeSetCellView.h
//  Beillen
//
//  Created by chenyi on 2026/10/6.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class PowerBankTimeSetCellView;
@protocol PowerBankTimeSetCellViewDelegate <NSObject>
/// 按钮点击事件代理
- (void)eventsDidTouchedForView:(PowerBankTimeSetCellView*)view Type:(NSInteger)eventsType value:(NSInteger)value;

@end


@interface PowerBankTimeSetCellView : UIView

/// 按钮点击事件代理
@property (nonatomic, weak) id <PowerBankTimeSetCellViewDelegate> delegate;
@property (nonatomic, strong) UIButton *selectBtn ;

-(void)initAddViewWithType:(NSInteger)typeView time:(NSInteger)timeNumber timeType:(NSString*)tiemeTypeStr;
-(void)selectForView:(BOOL)isSelect;
@end

NS_ASSUME_NONNULL_END
