//
//  BSSearchDeviceListView.m
//  Beillen
//
//  Created by skychi on 2022/10/19.
//  Copyright © 2022 Beillen.All rights reserved.
//

#import "BSSearchDeviceListView.h"
#import "BSAddCell.h"
#import "YGSearchDeviceModel.h"
#import "YGAddDeviceModel.h"

@interface BSSearchDeviceListView()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) UILabel *titleLabel;
@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,assign) CGFloat viewTop ;
@end

@implementation BSSearchDeviceListView

#pragma mark- Life cycle

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        //        [self setup];
        self.viewTop = 0 ;
    }
    return self;
}

- (void)initTypezWithTop:(NSInteger)viewTop {
    _viewTop = viewTop ;
    [self setup];
}

#pragma mark- setup

- (void)setup{
    self.backgroundColor = self.tableView.backgroundColor = [UIColor bs_colorFromARGB:@"#F2F4F8"];
    [self createUI];
    [self setupConstraints];
}

- (void)createUI{
    [self addSubview:self.titleLabel];
    [self addSubview:self.tableView];
}

- (void)setupConstraints{
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.right.mas_equalTo(-24);
        make.top.mas_equalTo(self.viewTop);
    }];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(12);
        make.left.bottom.right.equalTo(self);
    }];
}

#pragma mark- Public methods

- (void)reloadData{
    if(self.hidden || self.alpha == 0){ return; }
    [self.tableView reloadData];
}

#pragma mark- Private methods

- (YGSearchDeviceModel *)modelAtIndexPath:(NSIndexPath *)indexPath{
    YGSearchDeviceModel *model = nil;
    if(self.delegate && [self.delegate respondsToSelector:@selector(modelAtIndexPath:)]){
        model = [self.delegate modelAtIndexPath:indexPath];
    }
    return model;
}

- (void)configData4Cell:(BSAddCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    YGSearchDeviceModel *model = [self modelAtIndexPath:indexPath];
    if(!model){
        return;
    }
//    [cell setIconURL:model.typeModel.icon name:model.typeModel.prodName mac:model.bleDevice.mac
//             checked:model.checked backgroundColorHexString:self.cellBGColorHexString];
     
    [cell setIconURL:model.typeModel.icon name:model.bleDevice.name mac:model.bleDevice.mac
             checked:model.checked backgroundColorHexString:self.cellBGColorHexString];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(self.delegate && [self.delegate respondsToSelector:@selector(numberOfRowsInSection:)]){
        return [self.delegate numberOfRowsInSection:section];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BSAddCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BSAddCell class])];
    if (!cell) {
        cell = [[BSAddCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BSAddCell class])];
    }
    [self configData4Cell:cell atIndexPath:indexPath];
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(heightForRowAtIndexPath:)]){
        return [self.delegate heightForRowAtIndexPath:indexPath];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(self.delegate && [self.delegate respondsToSelector:@selector(didSelectItemAtIndexPath:)]){
        [self.delegate didSelectItemAtIndexPath:indexPath];
    }
}

#pragma mark- Setters && Getters

- (void)setBackgroundColor:(UIColor *)backgroundColor{
    [super setBackgroundColor:backgroundColor];
    self.tableView.backgroundColor = backgroundColor;
}

- (void)setDelegate:(id<BSSearchDeviceListViewDelegate>)delegate{
    _delegate = delegate;
    [self reloadData];
}

- (UILabel *)titleLabel{
    if(!_titleLabel){
        _titleLabel = ({
            UILabel *titleLabel  = [UILabel bs_labelWithFont:[UIFont bs_PingFangBoldFontWithFontSize:20.0]
                                               textAlignment:NSTextAlignmentLeft
                                                   textColor:[UIColor bs_colorFromARGB:@"#333333"]];
            titleLabel.text = NSLocalizedStringkey(@"finded_device");
            titleLabel.numberOfLines = 0;
            titleLabel;
        });
    }
    return _titleLabel;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, CGFLOAT_MIN)];
        _tableView.separatorInset = UIEdgeInsetsZero;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.delegate   = self;
        _tableView.dataSource = self;
        if (@available(iOS 11.0, *)) {
            _tableView.estimatedRowHeight = 0;
            _tableView.estimatedSectionFooterHeight = 0;
            _tableView.estimatedSectionHeaderHeight = 0;
            UIScrollView.appearance.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

@end
