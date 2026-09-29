//
//  BSHomePageBannerCell.m
//  Beillen
//
//  Created by chenyi on 2026/9/28.
//

#import "BSHomePageBannerCell.h"
#import "BSHomeModel.h"
#import "SDCycleScrollView.h"

@interface BSHomePageBannerCell()<SDCycleScrollViewDelegate>

@property(nonatomic,strong) SDCycleScrollView *cycleScrollView;

@end

@implementation BSHomePageBannerCell


- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}

- (void)setup {
    [self.contentView addSubview:self.cycleScrollView];
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(10, 0, 10, 0));
    }];
}

/** 点击图片回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
}

/** 图片滚动回调 */
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index {
   
}

#pragma mark- Setters && Getters
- (void)updateBanners:(NSArray<BSHomeBannerModel *> *)banners size:(CGSize)size{
    [self updateBanners:banners];
    if (size.width != 0 && size.height != 0) {
        NSLog(@"updateBanners--size width: %f  height: %f", size.width, size.height);
        [self.cycleScrollView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(size);
            make.center.equalTo(self);
        }];
        [self.cycleScrollView setNeedsLayout];
        [self.cycleScrollView layoutIfNeeded];
        [self.cycleScrollView adjustWhenControllerViewWillAppera];
    }
}

- (void)updateBanners:(NSArray<BSHomeBannerModel *> *)banners {
    
    self.banners = banners;
    NSMutableArray *paths = [NSMutableArray array];
    for (BSHomeBannerModel *bannerModel in banners) {
        if (bannerModel && [bannerModel respondsToSelector:@selector(imgUrl)]) {
            //Bugly 有上报 -[__NSCFString imgUrl]: unrecognized selector sent to instance 0x280437bc0
            [paths addObject:bannerModel.imgUrl];
        }
    }
    self.cycleScrollView.imageURLStringsGroup = paths;
}

- (SDCycleScrollView *)cycleScrollView{
    if (!_cycleScrollView) {
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectZero shouldInfiniteLoop:YES imageNamesGroup:nil];
        _cycleScrollView.placeholderImage = [UIImage imageNamed:@"img_default_list"];
        _cycleScrollView.delegate = self;
        _cycleScrollView.autoScrollTimeInterval = 3;
        _cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleClassic;
        _cycleScrollView.showPageControl = YES;
        _cycleScrollView.autoScroll = YES;
        _cycleScrollView.pageDotImage = [UIImage imageNamed:@"normal_page_dot_icon"];
        _cycleScrollView.currentPageDotImage = [UIImage imageNamed:@"current_page_dot_icon"];
        _cycleScrollView.pageControlBottomOffset = 0;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.backgroundColor = [UIColor clearColor];
        _cycleScrollView.layer.cornerRadius = 18;
        _cycleScrollView.layer.masksToBounds = YES;
    }
    return _cycleScrollView;
}

@end
