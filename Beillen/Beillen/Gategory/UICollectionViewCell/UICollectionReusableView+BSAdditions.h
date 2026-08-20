//
//  UICollectionReusableView+BSAdditions.h
//  Beillen
//
//  Created by skychi on 2021/6/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionReusableView (BSAdditions)
+ (NSString *)reuseIdForSupplementaryViewOfKind:(NSString *)elementKind;
+ (void)registerSupplementaryViewForCollectionView:(UICollectionView *)collectionView supplementaryViewOfKind:(NSString *)elementKind;
+ (id)supplementaryViewForCollectionView:(UICollectionView *)collectionView supplementaryViewOfKind:(NSString *)elementKind forIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
