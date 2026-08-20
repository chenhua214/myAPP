//
//  UICollectionReusableView+BSAdditions.m
//  Beillen
//
//  Created by skychi on 2021/6/15.
//

#import "UICollectionReusableView+BSAdditions.h"

@implementation UICollectionReusableView (BSAdditions)

+ (NSString *)reuseIdForSupplementaryViewOfKind:(NSString *)elementKind{
    return [NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),elementKind];
}

+ (void)registerSupplementaryViewForCollectionView:(UICollectionView *)collectionView supplementaryViewOfKind:(NSString *)elementKind{
    [collectionView registerClass:[self class] forSupplementaryViewOfKind:elementKind withReuseIdentifier:[self reuseIdForSupplementaryViewOfKind:elementKind]];
}

+ (id)supplementaryViewForCollectionView:(UICollectionView *)collectionView supplementaryViewOfKind:(NSString *)elementKind forIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableSupplementaryViewOfKind:elementKind withReuseIdentifier:[self reuseIdForSupplementaryViewOfKind:elementKind] forIndexPath:indexPath];
}

@end
