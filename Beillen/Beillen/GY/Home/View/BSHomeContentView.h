//
//  BSHomeContentView.h
//  Beillen
//
//  Created by chenyi on 2026/8/14.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class BSHomeDataModel;
@class BSHomeAddDeviceView;

#define homeHeaderHeight 60
#define homeCenterYScale 1.26
@interface BSHomeContentView : UIView
/// 头部
@property (nonatomic, strong) UIView *headerView;
/// Collection View
@property (nonatomic, strong) UICollectionView *dataCollectionView;
/// 添加新设备
@property (nonatomic, strong) BSHomeAddDeviceView *addDeviceView;
/// Banner Cell Size
@property (nonatomic, assign) CGSize bannerSize;
@property (nonatomic, assign) CGSize bannerCycleViewSize;
/// add Device Size
@property (nonatomic, assign) CGSize addDeviceSize;
/// CollectionView Cell Size
@property (nonatomic, assign) CGSize collectionSize;
/// 所有的点击事件
@property (nonatomic, strong) RACSubject *eventsSubject;


/// 更新Banner、Device 数据 UI
- (void)updateDataModel:(BSHomeDataModel *)model;
/// 仅仅更新数据
- (BSHomeDataModel *)onlyUpdateDataModelWithData:(id)data;
/// 下拉刷新
- (void)endHeaderRefresh;
/// 重绘界面内容
- (void)reloadContentView;

/// 切换语言、更新内容
- (void)updateOnChangeLanguages;



@end

NS_ASSUME_NONNULL_END
