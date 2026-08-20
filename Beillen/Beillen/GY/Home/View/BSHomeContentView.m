//
//  BSHomeContentView.m
//  Beillen
//
//  Created by chenyi on 2026/8/14.
//

#import "BSHomeContentView.h"
#import "BSHomePageCell.h"
#import "BSHomeProfilesModel.h"
#import "BSHomeModel.h"
#import "BSHomeAddDeviceView.h"
#import "BSHomePageSectionReusableView.h"

@interface BSHomeContentView()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BSHomePageCellDelegate>

///
@property (nonatomic, strong) BSHomeDataModel *dataModel;
///

@end

@implementation BSHomeContentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.eventsSubject = [RACSubject subject];
        [self initSubview];
    }
    return self;
}

#pragma mark - UI

- (void)initSubview {
    self.backgroundColor = bsColorString(@"#F2F4F8");
    [self addSubview:self.headerView];
    [self addSubview:self.dataCollectionView];
    [self.dataCollectionView addSubview:self.addDeviceView];
    
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(StatusBar_HEIGHT);
        make.height.mas_equalTo(homeHeaderHeight);
    }];
    [self.dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
    [self.addDeviceView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.centerY.mas_equalTo(0).multipliedBy(homeCenterYScale);
        make.size.mas_equalTo(self.addDeviceSize);
    }];
}


/// 更新Banner、Device 数据 UI
- (void)updateDataModel:(BSHomeDataModel *)model
{
    self.dataModel = model;
    self.addDeviceView.hidden = model.devices.count > 0;
    // self.dataCollectionView.scrollEnabled = model.devices.count > 0;
//    [self updateUserInfomationWithDevices:model.devices.count];
    [self reloadCollectionViewData];
}

/// 仅仅更新数据
- (BSHomeDataModel *)onlyUpdateDataModelWithData:(id)data
{
    BSHomeDeviceModel *model = data;
    [self.dataModel.devices enumerateObjectsUsingBlock:^(BSHomeDeviceModel *obj, NSUInteger idx, BOOL *stop) {
        if ([obj.model isEqualToString:model.model] && [obj.identifier isEqualToString:model.identifier]) {
//            obj.params = model.params;
            *stop = YES;
        }
    }];
    return self.dataModel;
}


/// 下拉刷新
- (void)endHeaderRefresh
{
//    [BSRefresh endHeaderRefreshWithScrollView:self.dataCollectionView];
}

/// 刷新表单
- (void)reloadCollectionViewData
{
    [self.dataCollectionView reloadData];
}

/// ipad适配
- (void)reloadContentView
{
    [self layoutIfNeeded];
    [self.dataCollectionView reloadData];
}

/// 切换语言、更新内容
- (void)updateOnChangeLanguages
{
//    [self.headerView updateOnChangeLanguages];
//    [self.addDeviceView updateOnChangeLanguages];
}


#pragma mark - BSHomePageBannerCellDelegate Banner图点击事件
//
///// 滚动轮播图
///// @param cell 控件
///// @param index 当前index
//- (void)homePageBannerCollectionViewCell:(BSHomePageBannerCell *)cell didScrollAtIndex:(NSInteger)index
//{
//    
//}
//
///// 点击轮播图
///// @param cell 控件
///// @param index 当前index
//- (void)homePageBannerCollectionViewCell:(BSHomePageBannerCell *)cell didClickedAtIndex:(NSInteger)index
//{
//    NSLog(@"点击轮播图 %ld",(long)index);
//    if (index >= 0 && index < self.dataModel.banners.count) {
//        BSHomeBannerModel *bannerModel = self.dataModel.banners[index];
//        [self sendEventsType:BSHomePageEventsTypeBanner data:bannerModel];
//    }
//}
//
//#pragma mark - BSHomePageCellDelegate
//
///// Cell 中的 按钮开关 点击 事件
//- (void)homePageCellSwitchTouchedWithModel:(BSHomeDeviceModel *)deviceModel
//{
//    [self sendEventsType:BSHomePageEventsTypeCellSwitch data:deviceModel];
//}
//
//

#pragma mark - UICollectionViewDelegate

/// Cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return;
    if (indexPath.item >= self.dataModel.devices.count) return;
    BSHomeDeviceModel *deviceModel = self.dataModel.devices[indexPath.item];
    [self sendEventsType:BSHomePageEventsTypeCellTouch data:deviceModel];
}

/// 去添加设备
- (void)gotoAddDevicesGesture:(UIGestureRecognizer *)gesture
{
    [self sendEventsType:BSHomePageEventsTypeAddDevice data:nil];
}

/// 开始发送
- (void)sendEventsType:(BSHomePageEventsType)type data:(id)data
{
    RACTuple *tuple = [RACTuple tupleWithObjects:@(type), data, nil];
    [self.eventsSubject sendNext:tuple];
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.section == 0 ? self.bannerSize : self.collectionSize;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return section == 0 ? CGSizeZero : CGSizeMake(kScreenWidth, 50);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return section == 0 ? UIEdgeInsetsMake(0, 0, 0, 0) : UIEdgeInsetsMake(10, 30, 20, 30);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return (self.dataModel.devices.count == 0) ? 1 : 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return section == 0 ? 1 : self.dataModel.devices.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 1) {
        BSHomePageSectionReusableView *reusableView = [BSHomePageSectionReusableView supplementaryViewForCollectionView:collectionView supplementaryViewOfKind:kind forIndexPath:indexPath];
        
//       
//        BSHomePageSectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:NSStringFromClass([BSHomePageSectionReusableView class]) forIndexPath:indexPath];
//                [headerView addSubview:self.headView];
        [reusableView updateData];
        return reusableView;
            
        
      
    }
    return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
//        BSHomePageBannerCell *cell = [BSHomePageBannerCell cellForCollectionView:collectionView indexPath:indexPath];
//        [cell updateBanners:self.dataModel.banners size:self.bannerCycleViewSize];
//        cell.delegate = self;
        BSHomePageCell *cell = [BSHomePageCell cellForCollectionView:collectionView indexPath:indexPath];
        [cell updateDeviceModel:self.dataModel.devices[indexPath.item]];
        cell.delegate = self;
        return cell;
    } else {
        BSHomePageCell *cell = [BSHomePageCell cellForCollectionView:collectionView indexPath:indexPath];
        [cell updateDeviceModel:self.dataModel.devices[indexPath.item]];
        cell.delegate = self;
        return cell;
    }
}


#pragma mark - Getters

- (UIView *)headerView {
    if (!_headerView) {
        _headerView = [UIView new];
//        _headerView.delegate = self;
    }
    return _headerView;
}

- (UICollectionView *)dataCollectionView {
    if (!_dataCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.itemSize = CGSizeMake(100, 100);
        layout.minimumLineSpacing = 20;
        layout.minimumInteritemSpacing = 20;
        _dataCollectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _dataCollectionView.dataSource = self;
        _dataCollectionView.delegate = self;
        _dataCollectionView.backgroundColor = [UIColor clearColor];
        _dataCollectionView.showsHorizontalScrollIndicator = NO;
        _dataCollectionView.showsVerticalScrollIndicator = NO;
        if (@available(iOS 11.0, *)) {
            _dataCollectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
       
        
        [_dataCollectionView registerClass:[BSHomePageCell class] forCellWithReuseIdentifier:NSStringFromClass([BSHomePageCell class])];
//        [_dataCollectionView registerClass:[BSHomePageSectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:NSStringFromClass([BSHomePageSectionReusableView class])];
        [BSHomePageSectionReusableView registerSupplementaryViewForCollectionView:_dataCollectionView
                                                          supplementaryViewOfKind:UICollectionElementKindSectionHeader];
//            [BSHomePageBannerCell registerCellForCollectionView:_dataCollectionView];
//            [BSHomePageSectionReusableView registerSupplementaryViewForCollectionView:_dataCollectionView
//                                                          supplementaryViewOfKind:UICollectionElementKindSectionHeader];
    }
    return _dataCollectionView;
}




- (BSHomeAddDeviceView *)addDeviceView {
    if (!_addDeviceView) {
        _addDeviceView = [BSHomeAddDeviceView new];
        _addDeviceView.hidden = YES;
        UITapGestureRecognizer *tapGestire = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoAddDevicesGesture:)];
        [_addDeviceView addGestureRecognizer:tapGestire];
    }
    return _addDeviceView;
}

#pragma mark - Setter
- (void)setAddDeviceSize:(CGSize)addDeviceSize
{
    _addDeviceSize = addDeviceSize;
    [self.addDeviceView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(addDeviceSize);
    }];
}
@end
