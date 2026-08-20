//
//  BSSearchDeviceListView.h
//  Beillen
//
//  Created by skychi on 2022/10/19.
//  Copyright © 2022 Beillen.All rights reserved.
//

#import "BSBaseView.h"


NS_ASSUME_NONNULL_BEGIN

@class YGSearchDeviceModel;
@protocol BSSearchDeviceListViewDelegate <NSObject>
@optional
- (NSInteger)numberOfRowsInSection:(NSInteger)section;
- (CGFloat)heightForRowAtIndexPath:(NSIndexPath *)indexPath;
- (nullable YGSearchDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath;
- (void)didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
@end

@interface BSSearchDeviceListView : BSBaseView
@property(nonatomic,copy,nullable) NSString *cellBGColorHexString;
@property(nonatomic,weak) id<BSSearchDeviceListViewDelegate> delegate;
- (void)reloadData;
//  0 默认  其他值 标题顶部距离 
- (void)initTypezWithTop:(NSInteger)viewTop ;
@end

NS_ASSUME_NONNULL_END
