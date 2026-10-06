//
//  PowerBankScreenSetView.h
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol PowerBankScreenSetViewDelegate <NSObject>
/// 按钮点击事件代理
- (void)eventsDidTouched:(NSInteger)eventsType value:(NSInteger)value;

@end

@interface PowerBankScreenSetCellView : UIView
-(void)initAddViewWithType:(NSInteger)typeView;
@end


@interface PowerBankScreenSetTextView : UIView
-(void)initAddViewWithType:(NSInteger)typeView;
-(void)upDataForViewWithType:(NSInteger)type;
/// 按钮点击事件代理
@property (nonatomic, weak) id <PowerBankScreenSetViewDelegate> delegate;
@end


@interface PowerBankScreenSetView : UIView
/// 按钮点击事件代理
@property (nonatomic, weak) id <PowerBankScreenSetViewDelegate> delegate;
-(void)initAddViewWithType:(NSInteger)typeView;
/// 更新界面信息
-(void)upDataWithLcdTimeType:(NSInteger)LcdTimeType  LcdInteractType:(NSInteger)LcdInteractType;
@end

NS_ASSUME_NONNULL_END
