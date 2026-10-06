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
#import "BSHomePageBannerCell.h"
@interface BSHomeContentView()
<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,BSHomePageCellDelegate,BSHomePageHeaderDelegate>
@property (nonatomic, strong) BSHomeDataModel *dataModel;
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
    self.backgroundColor = bsColorString(@"#F7F9FB");
    [self addSubview:self.headerView];
    [self addSubview:self.dataCollectionView];
    [self.headerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.top.mas_equalTo(StatusBar_HEIGHT);
        make.height.mas_equalTo(homeHeaderHeight);
    }];
    [self.dataCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.headerView.mas_bottom);
    }];
}

/// 更新Banner、Device 数据 UI
- (void)updateDataModel:(BSHomeDataModel *)model
{
    self.dataModel = model;
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
    [self.headerView updateOnChangeLanguages];
}

#pragma mark - 协议 - BSHomePageHeaderDelegate

/// 首页-头部视图点击事件
- (void)homePageHeaderEventsWithType:(BSHomePageEventsType)eventsType
{
    [self sendEventsType:eventsType data:nil];
}

#pragma mark - BSHomePageCellDelegate

/// Cell 中的 按钮开关 点击 事件
- (void)homePageCellSwitchTouchedWithModel:(BSHomeDeviceModel *)deviceModel
{
//    [self sendEventsType:BSHomePageEventsTypeCellSwitch data:deviceModel];
}

#pragma mark - BSHomePageBannerCellDelegate Banner图点击事件


#pragma mark - UICollectionViewDelegate

/// Cell 点击
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) return;
    if (indexPath.section ==2) {
        [self sendEventsType:BSHomePageEventsTypeAddDevice data:nil];
    } else if (indexPath.section == 1) {
        if ([self isDeviceNumber]) {
            if (indexPath.item >= self.dataModel.devices.count) return;
            BSHomeDeviceModel *deviceModel = self.dataModel.devices[indexPath.item];
            [self sendEventsType:BSHomePageEventsTypeCellTouch data:deviceModel];
        } else {
            [self sendEventsType:BSHomePageEventsTypeAddDevice data:nil];
        }
    }
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
    if (indexPath.section == 0) {
        return  self.bannerSize;
    } else if ([self isDeviceNumber]) {
        if (indexPath.section == 1) {
            return  self.collectionSize;
        }
    }
    return  self.addDeviceSize;
   
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    
   if ([self isDeviceNumber]) {
        if (section == 1) {
            return  CGSizeMake(kScreenWidth, 50);
        }
    }
    return CGSizeZero;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    if (section == 2) {
        return  CGSizeMake(kScreenWidth, 90);
    }
    return CGSizeZero;;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return section == 0 ? UIEdgeInsetsMake(0, 0, 0, 0)  : UIEdgeInsetsMake(10, 30, 20, 30);
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return ([self isDeviceNumber]) ? 3 : 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    if (section == 1 && [self isDeviceNumber]) {
        return self.dataModel.devices.count;
    }
    return  1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader] && indexPath.section == 1) {
        if ([self isDeviceNumber]) {
            BSHomePageSectionReusableView *reusableView = [BSHomePageSectionReusableView supplementaryViewForCollectionView:collectionView supplementaryViewOfKind:kind forIndexPath:indexPath];
            [reusableView updateData];
            return reusableView;
        }
       
    } else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && indexPath.section == 2) {
        if ([self isDeviceNumber]) {
            UICollectionReusableView *reusableView = [UICollectionReusableView supplementaryViewForCollectionView:collectionView supplementaryViewOfKind:kind forIndexPath:indexPath];
            return reusableView;
        }
    }
    return [UICollectionReusableView new];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        BSHomePageBannerCell *cell = [BSHomePageBannerCell cellForCollectionView:collectionView indexPath:indexPath];
        [cell updateBanners:self.dataModel.banners size:self.bannerCycleViewSize];
        return cell;
    } else  if ([self isDeviceNumber] && indexPath.section  == 1) {
        BSHomePageCell *cell = [BSHomePageCell cellForCollectionView:collectionView indexPath:indexPath];
        [cell updateDeviceModel:self.dataModel.devices[0]];
        cell.delegate = self;
        return cell;
    } else {
        BSHomeAddDeviceView *cell = [BSHomeAddDeviceView cellForCollectionView:collectionView indexPath:indexPath];
        return cell;
    }
}

-(BOOL)isDeviceNumber {
    
    BOOL isNnumber = NO;
    if (self.dataModel!=nil) {
        if (self.dataModel.devices !=nil) {
            if (self.dataModel.devices.count>0) {
                isNnumber = YES ;
            }
        }
    }
    return isNnumber;
}

#pragma mark - Getters

- (BSHomePageHeader *)headerView {
    if (!_headerView) {
        _headerView = [BSHomePageHeader new];
        _headerView.delegate = self;
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
        [_dataCollectionView registerClass:[BSHomePageBannerCell class] forCellWithReuseIdentifier:NSStringFromClass([BSHomePageBannerCell class])];
        [_dataCollectionView registerClass:[BSHomeAddDeviceView class] forCellWithReuseIdentifier:NSStringFromClass([BSHomeAddDeviceView class])];
        
        [BSHomePageSectionReusableView registerSupplementaryViewForCollectionView:_dataCollectionView
                                                          supplementaryViewOfKind:UICollectionElementKindSectionHeader];
        
        [UICollectionReusableView registerSupplementaryViewForCollectionView:_dataCollectionView
                                                          supplementaryViewOfKind:UICollectionElementKindSectionFooter];
    }
    return _dataCollectionView;
}

#pragma mark - Setter
- (void)setAddDeviceSize:(CGSize)addDeviceSize
{
    _addDeviceSize = addDeviceSize;
}
@end
