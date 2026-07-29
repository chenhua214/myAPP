//
//  YGViewController.h
//  JDKJAPP
//
//  Created by chenyi on 2026/1/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface YGViewController : UIViewController

@property(nonatomic, assign)BOOL  isGesturesBackDenied;
- (void)onBackAction;
- (void)popToMineDeviceViewControllerIfNeeded;
- (void)pop2ViewControllerWithName:(NSString *)controllerName;
- (void)updateBackBtnImage:(NSString * __nullable)image imageEdgeInsets:(UIEdgeInsets)edgeInsets;
- (void)push2ProductManuaVCWithURL:(NSString *)urlString;
/// 获取购物车列表数据
- (void)requestShoppingList;
/// 根据型号和分类ID跳转至帮助反馈页面
- (void)push2HelpFeedbackViewWithModel:(NSString *)model categoryId:(NSInteger)categoryId;
- (void)removeViewControllerName:(NSString *)className;
- (void)hiddenBackBtn:(BOOL)hidden;

/// 更新返回按钮图片以及字体颜色为粗体
- (void)updateBackImgAndTitleFonts;
@end

NS_ASSUME_NONNULL_END
