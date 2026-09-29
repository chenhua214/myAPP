//
//  MessageCellView.m
//  Beillen
//
//  Created by chenyi on 2026/9/29.
//

#import "MessageCellView.h"

@implementation MessageCellModel

@end


@interface MessageCellView()
@property (nonatomic, strong) NSString *typeStr;
@property (nonatomic, strong) NSString *messageStr;
@property (nonatomic, strong) NSString *iconStr;
@property (nonatomic, assign) NSInteger typeView;
@property (nonatomic, assign) BOOL isLineShow;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIImageView *iconView ;
@property (nonatomic, strong) UILabel *typeLab;
@end

@implementation MessageCellView

-(void)initAddViewWithType:(NSInteger)typeView
                      type:(NSString*)type
                   message:(NSString*)message
                      icon:(NSString*)icon
                  showLine:(BOOL)hidden{
    _typeStr     = type;
    _typeView    = typeView;
    _messageStr  = message;
    _iconStr     = icon;
    _isLineShow = hidden;
    if (typeView == 1) {
        [self initTypeViewForMessage];
    } else if (typeView == 2) {
        [self initTypeViewForIcon];
    }
}

-(void)initTypeViewForMessage{
    CGFloat sp_left = 25;
   
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.mas_equalTo(0);
       
    }];
    if (_isLineShow) {
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sp_left);
            make.right.mas_equalTo(-sp_left);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

-(void)initTypeViewForIcon{
    CGFloat sp_left = 25;
    [self addSubview:self.typeLab];
    [self addSubview:self.messageLab];
    [self addSubview:self.iconView];
    self.iconView.image = [UIImage imageNamed:self.iconStr];
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(sp_left);
        make.height.width.mas_equalTo(16);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.typeLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(46);
        make.centerY.mas_equalTo(0);
    }];
    
    [self.messageLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-sp_left);
        make.centerY.mas_equalTo(0);
    }];
    if (_isLineShow) {
        [self addSubview:self.lineView];
        [self.lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(sp_left);
            make.right.mas_equalTo(-sp_left);
            make.height.mas_equalTo(1);
            make.bottom.mas_equalTo(0);
        }];
    }
    self.typeLab.text = self.typeStr;
    self.messageLab.text = self.messageStr;
}

-(UIView*)lineView{
    if (!_lineView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#C5C4DB" alpha:0.1];
        _lineView = view;
    }
    return _lineView;
}

-(UILabel*)typeLab {
    if (!_typeLab) {
        _typeLab = [UILabel bs_labelWithFont:[UIFont bs_mediumFontWithFontSize:16] textAlignment:NSTextAlignmentLeft textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _typeLab;
}

-(UILabel*)messageLab {
    if (!_messageLab) {
        _messageLab = [UILabel bs_labelWithFont:[UIFont bs_semiboldFontWithFontSize:16] textAlignment:NSTextAlignmentRight textColor:[UIColor bs_colorFromARGB:@"#191C1E"]] ;
    }
    return _messageLab;
}

-(UIImageView*)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc]init];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconView;
}

@end





@interface MessageBgCellView()
@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, assign) CGFloat viewTop;
@end

@implementation MessageBgCellView
-(void)initAddViewWithType:(NSInteger)typeView
                      type:(NSString*)type
                   message:(NSString*)message
                      icon:(NSString*)icon
                  showLine:(BOOL)hidden{
    
}

-(void)setModelArr:(NSArray<MessageCellModel *> *)modelArr {
    _modelArr = modelArr;
    [self initTypeViewForMessage];
    
}

-(void)upDataWithModelArr:(NSArray<MessageCellModel *> *)modelArr {
    
}

-(void)initTypeViewForMessage {
    [self addSubview:self.bgView];
    [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];

    self.viewTop = 9;
    for (NSInteger i = 0; i<self.modelArr.count; i++) {
        MessageCellModel *Model= self.modelArr[i];
        [self addSettingCellViewIcon:Model];
      }
}

-(UIView*)bgView{
    if (!_bgView) {
        UIView *view = [UIView new];
        view.backgroundColor = [UIColor bs_colorFromARGB:@"#FFFFFF"];
        view.layer.cornerRadius = 30;
        _bgView = view;
    }
    return _bgView;
}

-(MessageCellView *)addSettingCellViewIcon:(MessageCellModel*)model {
    
    MessageCellView *view = [MessageCellView new];
    [view initAddViewWithType:model.typeView type:model.typeStr message:model.messageStr icon:model.iconStr showLine:model.isLineShow];
    view.tag = model.typeView;
    [self.bgView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(9+ (model.typeTag-1) *63);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.width.mas_equalTo(self.bgView).offset(0);
        make.height.mas_equalTo(63);
    }];
    return view;
}

@end
