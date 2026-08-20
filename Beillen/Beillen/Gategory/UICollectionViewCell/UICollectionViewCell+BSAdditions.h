//
//  UICollectionViewCell+BSAdditions.h
//  Beillen
//
//  Created by skychi on 2021/5/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UICollectionViewCell (BSAdditions)
+ (NSString *)reusableCellId;
+ (void)registerCellForCollectionView:(UICollectionView *)collectionView;
+ (id)cellForCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath;
- (void)addSectionCornerRadius:(CGFloat)cornerRadius forCollectionView:(UICollectionView *)collectionView atIndexPath:(NSIndexPath *)indexPath;
@end

NS_ASSUME_NONNULL_END
