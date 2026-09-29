//
//  BSHomePageBannerCell.h
//  Beillen
//
//  Created by chenyi on 2026/9/28.
//

#import <UIKit/UIKit.h>
@class BSHomeBannerModel;
NS_ASSUME_NONNULL_BEGIN

@interface BSHomePageBannerCell : UICollectionViewCell
@property (nonatomic, strong) NSArray<BSHomeBannerModel *> *banners;

- (void)updateBanners:(NSArray <BSHomeBannerModel *> *)banners;

- (void)updateBanners:(NSArray<BSHomeBannerModel *> *)banners size:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
