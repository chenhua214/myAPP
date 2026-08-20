//
//  BSHomePageSectionReusableView.m
//  Beillen
//
//  Created by wushuang on 2023/12/8.
//  Copyright © 2023 Beillen All rights reserved.
//

#import "BSHomePageSectionReusableView.h"

@interface BSHomePageSectionReusableView()

@property (nonatomic, strong) UILabel *titleLab;

@end

@implementation BSHomePageSectionReusableView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        UILabel *label = [[UILabel alloc] init];
        label.textColor = [UIColor bs_colorFromARGB:@"#333333"];
        label.font = bsFontBold(20);
        label.textAlignment = NSTextAlignmentLeft;
        label.text = NSLocalizedStringkey(@"my_devices");
        [self addSubview:label];
        self.titleLab = label;
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(30);
            make.centerY.mas_equalTo(0).multipliedBy(1.4);
        }];
    }
    return self;
}

- (void)updateData 
{
    self.titleLab.text = NSLocalizedStringkey(@"my_devices");
}

@end
