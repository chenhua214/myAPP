//
//  YGBSCurveTabBar.m
//  JDKJAPP
//
//  Created by chenyi on 2026/1/26.
//

#import "YGBSCurveTabBar.h"
#import "UITabBar+BSAddition.h"


static CGFloat kBSTabBarMargin      = 2.0;
static CGFloat kBSTabBarItemSpacing = 4.0;

@interface YGBSCurveTabBar()
///商城按钮 客服中心按钮
//@property(nonatomic,  weak) BSTabBarButton *mallButtonCenter;
/////商城按钮
//@property(nonatomic,  weak) BSTabBarButton *mallButtonNew;
/////背景视图
//@property(nonatomic,  weak) BSTabBarBackgroundView *tabBarBackgroundView;
///商城按钮对应的索引 中心突出按钮
@property(nonatomic,assign) NSInteger indexOfMallButton;
///是否有商城按钮
@property(nonatomic,assign) BOOL hasMallButton;
///商城按钮是否有对应的控制器
@property(nonatomic,assign) BOOL hasController4MallButton;
/// 控制器的个数
@property(nonatomic,assign) NSInteger numberOfControllers;

/// 每个item: <index,frame>
@property(nonatomic,strong) NSMutableDictionary<NSString *,NSValue *> *frameValueDict;
@end

@implementation YGBSCurveTabBar

#pragma mark- Life cycle

- (instancetype)init{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self setup];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    [self tabBarBackgroundColor:[UIColor whiteColor] customSeparatorColor:nil height:0];
    if (!self.hasMallButton || self.numberOfControllers <= 0) {
        return;
    }
    [self updateTabBarCustomViewsFrame];
//    [self updateTabBarButtonsFrame];
}

#pragma mark- setup

- (void)setup{
    [self configParams];
    [self configMallButtonIfNeeded];
}

- (void)configParams{
    self.numberOfControllers = 0;
    if (self.curveDelegate && [self.curveDelegate respondsToSelector:@selector(numberOfControllers)]) {
        self.numberOfControllers = [self.curveDelegate numberOfControllers];
    }
    self.indexOfMallButton = NSNotFound;
    if (self.curveDelegate && [self.curveDelegate respondsToSelector:@selector(indexOfMallButton)]) {
        self.indexOfMallButton = [self.curveDelegate indexOfMallButton];
    }
    self.hasMallButton = (self.indexOfMallButton > 0 && self.indexOfMallButton != NSNotFound);
    /**
     满足以下条件则说明包含商城按钮对应的控制器
     1、有商城按钮
     2、TabBar控制器个数大于两个
     3、控制器总个数为奇数
     */
    self.hasController4MallButton = self.hasMallButton && (self.numberOfControllers > 2 ) && (self.numberOfControllers % 2 != 0);
}

- (void)configMallButtonIfNeeded{
    if (!self.hasMallButton) {
        return;
    }
//    BSTabBarBackgroundView *tabBarBackgroundView = [BSTabBarBackgroundView new];
//    [self insertSubview:tabBarBackgroundView atIndex:0];
//    self.tabBarBackgroundView = tabBarBackgroundView;
//    __weak typeof(self) weakSelf = self;
//    BSTabBarButton *button = [BSTabBarButton tabBarButtonWithType:0 Callback:^(BSTabBarButton *sender){
//        [weakSelf didMallButtonPressed:sender];
//    }];
//    [self addSubview:button];
//    self.mallButtonCenter = button;
    
//    BSTabBarButton *buttonNew = [BSTabBarButton tabBarButtonWithType:1 Callback:^(BSTabBarButton *sender){
////        [self didMallButtonPressed:sender];
//        [weakSelf didMallWithButton:sender];
//    }];
//    [self addSubview:buttonNew];
//    self.mallButtonNew = buttonNew;
}

#pragma mark- Public methods

- (void)reloadData{
    [self setup];
    [self layoutIfNeeded];
}

- (void)refreshImageIfNeeded{

}

- (CGRect)itemFrameAtIndex:(NSInteger)index{
    CGRect frame = CGRectZero;
    @synchronized (self.frameValueDict) {
        NSValue *value = [self.frameValueDict valueForKey:@(index).stringValue];
        if(value){ frame = [value CGRectValue]; }
    }
    return frame;
}

/// 切换APP语言后更新商城文案
- (void)updateMallTexExchangeLanguage
{
//    [self.mallButtonNew reloadTitle];
}

#pragma mark- Private methods

- (void)updateTabBarCustomViewsFrame{

//    CGFloat width = CGRectGetWidth(self.frame);
//    CGFloat curveViewHeight = CGRectGetHeight(self.tabBarBackgroundView.frame);
//    self.tabBarBackgroundView.frame = CGRectMake(0, -curveViewHeight, width, curveViewHeight);
//
//    // 设置按钮的frame
//    CGRect buttonFrame = self.mallButtonCenter.frame;
//    buttonFrame.origin.x = (width - CGRectGetWidth(buttonFrame))/2.0;
//    //button按钮高度向上偏移14像素 = 48 - CGRectGetHeight(buttonFrame)
//    buttonFrame.origin.y = -14;
//    self.mallButtonCenter.frame = buttonFrame;
//
//    // 设置按钮的frame
//    CGRect buttonFrameNew = self.mallButtonNew.frame;
//    buttonFrameNew.origin.x = (width - CGRectGetWidth(buttonFrame))/4.0;
//    self.mallButtonNew.frame = buttonFrameNew;
}

- (void)updateTabBarButtonsFrame {
    
//    NSArray *arr = [self subviews];
#if 0
    // arr 中 UITabBarButton 的排序可能会被打乱，导致通过 indexOfMallButton 查找到的 View 不准确
    
    if ([arr containsObject:self.mallButtonNew] && arr.count > 4)
    {
        NSInteger idx = 0;
        for (UIView *view in self.subviews) {
            if (![view isKindOfClass:[UIControl class]] || view == self.mallButtonNew) continue;
            if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
                if (idx == self.indexOfMallButton)
                {
                    view.hidden = YES;
                    self.mallButtonNew.frame = view.frame;
                }
                idx += 1;
            }
        }
    }
#else
//    if (![arr containsObject:self.mallButtonNew] || arr.count < 4) return;
//    
//    NSMutableArray *originXs = [NSMutableArray array];
//    for (UIView *view in arr) {
//        if (![view isKindOfClass:[UIControl class]] || view == self.mallButtonNew) continue;
//        if ([view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//            [originXs addObject:view];
//        }
//    }
//    if (originXs.count <= self.indexOfMallButton) return;
//    
//    NSArray *sortedArray = [originXs sortedArrayUsingComparator:^NSComparisonResult(UIView *obj1, UIView *obj2) {
//        return (obj1.frame.origin.x > obj2.frame.origin.x);
//    }];
//    
//    UIView *mallView = sortedArray[self.indexOfMallButton];
//    mallView.hidden = YES;
//    self.mallButtonNew.frame = mallView.frame;
#endif
    
//    // 设置其他UITabBarButton的frame
//    CGFloat mallButtonWidth = CGRectGetWidth(self.mallButtonCenter.frame);
//    NSInteger itemCount = (self.hasController4MallButton && self.numberOfControllers > 1) ? self.numberOfControllers - 1  : self.numberOfControllers;
//    // 按钮宽度 = (总宽度 - 商城按钮宽度 - item 间距 * item 个数 - 左右间距) / item 个数
//    CGFloat tabBarButtonWidth = (CGRectGetWidth(self.frame) - mallButtonWidth - kBSTabBarItemSpacing * itemCount - kBSTabBarMargin * 2) * 1.0 / itemCount;
//    // 计算间距
//    CGFloat tabBarButtonSpace = tabBarButtonWidth + kBSTabBarItemSpacing;
//    NSInteger index = 0;
//    CGFloat originX = 0;
//    CGFloat originY = 0;
//    /// UITabBarButton 真实宽度
//    CGFloat buttonWidth = 0;
//    NSInteger indexDiffValue  = 0;
//    for (UIView *view in self.subviews) {
//        if (![view isKindOfClass:[UIControl class]] || view == self.mallButtonCenter || view == self.mallButtonNew) continue;
//        indexDiffValue = (index - self.indexOfMallButton);
//        originX = kBSTabBarMargin + index * tabBarButtonSpace;
//        //默认按钮宽度
//        buttonWidth = tabBarButtonWidth;
//        if (self.hasController4MallButton) {
//            if (indexDiffValue == 0 || indexDiffValue == -1 ) {
//                //控制器的索引与mall Button 索引一致,设置TabBarButton宽度等于商城按钮宽度
//                buttonWidth = mallButtonWidth;
//                //隐藏UITabBarButton
//                view.hidden = YES;
//            }else if(indexDiffValue > 0){
//                //在Mall Button 右侧
//                originX += mallButtonWidth + kBSTabBarItemSpacing - tabBarButtonSpace;
//            }
//        }else{
//            //无商城控制按钮
//            if (indexDiffValue >= 0) {
//                originX += mallButtonWidth + kBSTabBarItemSpacing;
//            }
//        }
//        view.frame = CGRectMake(originX, originY, buttonWidth, view.frame.size.height);
//        [self setValueWithFrame:view.frame atIndex:index];
//        // 增加索引
//        index++;
//    }
}

- (void)setValueWithFrame:(CGRect)frame atIndex:(NSInteger)index{
    @synchronized (self.frameValueDict) {
        [self.frameValueDict setValue:[NSValue valueWithCGRect:frame] forKey:@(index).stringValue];
    }
}

#pragma mark- override

///处理响应区域
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    if (!self.isHidden && self.mallButtonCenter && !self.mallButtonCenter.hidden) {
//        //将当前tabbar的触摸点转换坐标系，转换到中间按钮的身上，生成一个新的点
//        CGPoint tPoint = [self convertPoint:point toView:self.mallButtonCenter];
//        //判断如果这个新的点是在中间按钮身上，那么处理点击事件最合适的view就是中间按钮
//        if ([self.mallButtonCenter pointInside:tPoint withEvent:event]) {
//            return self.mallButtonCenter;
//        }
//    }
    return [super hitTest:point withEvent:event];
}

#pragma mark- Action

//- (void)didMallWithButton:(BSTabBarButton *)sender {
//    if ([self.curveDelegate respondsToSelector:@selector(didMallButtonWithBtn:)]) {
//        [self.curveDelegate didMallButtonWithBtn:sender];
//    }
//}

//- (void)didMallButtonPressed:(BSTabBarButton *)sender{
//    if (!self.curveDelegate) {
//        NSLog(@"请设置delegate");
//        return;
//    }
//    if (sender == self.mallButtonCenter) {
//        if(self.hasController4MallButton){
//            NSInteger index = self.indexOfMallButton;
//            NSLog(@"index : %ld",index);
//            if (index < 0 || index == NSNotFound || index > self.numberOfControllers - 1) {
//                return;
//            }
//            if ([self.curveDelegate respondsToSelector:@selector(tabBar:didSelectedItemAtIndex:)]) {
//                [self.curveDelegate tabBar:self didSelectedItemAtIndex:index];
//                self.mallButtonCenter.selected = YES ;
//            }
//            return;
//        }
//    }
//    
//    if ([self.curveDelegate respondsToSelector:@selector(didMallButtonPressed)]) {
//        [self.curveDelegate didMallButtonPressed];
//    }
//}

- (void)upMallButtonIsSelect {
    if(self.hasController4MallButton){
        NSInteger index = self.indexOfMallButton;
        NSLog(@"index : %ld",index);
        if (index < 0 || index == NSNotFound || index > self.numberOfControllers - 1) {
            return;
        }
//        self.mallButtonCenter.selected = NO ;
    }
}

#pragma mark- Setters && Getters

- (NSMutableDictionary<NSString *,NSValue *> *)frameValueDict{
    if(!_frameValueDict){
        _frameValueDict = [NSMutableDictionary dictionary];
    }
    return _frameValueDict;
}










@end
