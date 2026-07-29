//
//  BSAlertMessageTool.m
//  BaseusAPP
//
//  Created by wushuang on 2023/11/29.
//  Copyright © 2023 Baseus. All rights reserved.
//

#import "BSAlertMessageTool.h"
#import <UIKit/UIKit.h>
@interface BSAlertMessageTool()<UITextFieldDelegate>
/// 弹窗视图
@property (nonatomic, strong) UIView *alertView;
/// 手势背景视图
@property (nonatomic, strong) UIView *bgGestureView;
/// 内容背景视图
@property (nonatomic, strong) UIView *contentBgView;

/// 内容视图
@property (nonatomic, strong) UIView *contentView;
/// 标题
@property (nonatomic, strong) UILabel *titleLable;
/// 内容
@property (nonatomic, strong) UILabel *messageLabel;
/// 输入框背景图
@property (nonatomic, strong) UIView *inputBackgroundView;
/// 输入框
@property (nonatomic, strong) UITextField *inputTextFeild;
/// 错误提示
@property (nonatomic, strong) UILabel *errorLabel;
/// 操作事件视图
@property (nonatomic, strong) UIView *actionView;
/// 取消按钮
@property (nonatomic, strong) UILabel  *cancelLabel;
@property (nonatomic, strong) UIButton *cancelButton;
/// 确认操作事件按钮
@property (nonatomic, strong) UILabel  *actionLabel;
@property (nonatomic, strong) UIButton *actionButton;

/// 单个操作事件按钮
@property (nonatomic, strong) UIButton *singleActionBtn;

/// 显示类型
@property (nonatomic, assign) BSAlertMessageType alertType;
/// 是否可以输入空内容
@property (nonatomic, assign) BOOL inputNone;

@property (nonatomic, copy) BSAlertMessageHandle actionHandle;

/// 顶部图片背景--加上背景约束才不会报错
@property (nonatomic, strong) UIView *topImageBgView;
/// 顶部图片
@property (nonatomic, strong) UIImageView *topImageView;
/// 底部取消按钮图标
@property (nonatomic, strong) UIButton *cancelImgButton;
@end

@implementation BSAlertMessageTool

// Tools

+ (BOOL)messageIsString:(id)message {
    return (([message isKindOfClass:[NSString class]] && ((NSString *)message).length > 0) ||
            ([message isKindOfClass:[NSAttributedString class]] && ((NSAttributedString *)message).length > 0));
}

+ (BOOL)messageValid:(id)message subMessage:(id)subMsg {
    return [self messageIsString:message] || [self messageIsString:subMsg];
}

+ (NSAttributedString *)attributstringWithText:(id)text font:(UIFont *)font color:(UIColor *)color {
    return [self attributstringWithText:text font:font color:color lineBreakMode:NSLineBreakByCharWrapping alignment:NSTextAlignmentCenter];
}

+ (NSAttributedString *)attributstringWithText:(id)text font:(UIFont *)font color:(UIColor *)color lineBreakMode:(NSLineBreakMode)lineBreakMode alignment:(NSTextAlignment)alignment {
    if (![self messageIsString:text]) return nil;
    if ([text isKindOfClass:[NSAttributedString class]]) return text;
    NSMutableAttributedString *attri = [[NSMutableAttributedString alloc] initWithString:text];
    [attri addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attri.length)];
    [attri addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(0, attri.length)];
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    [style setParagraphStyle:[NSParagraphStyle defaultParagraphStyle]];
    [style setLineBreakMode:lineBreakMode];
    [style setAlignment:alignment];
    [attri addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, attri.length)];
    return attri;
}

// Methord

+ (void)updateBgGestureEnable:(BOOL)enable
{
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    instance.bgGestureEnabel = enable;
}
/// 更新输入框是否可为空
+ (void)updateInputNoneText:(BOOL)none
{
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    instance.inputNone = none;
}


/// BSAlertMessageTypeDefault
+ (void)alertMessage:(id)msg subMessage:(id)subMsg cancelTxt:(NSString *)cancel actionTxt:(NSString *)action handle:(BSAlertMessageHandle)handle
{
    [self alertMessage:msg subMessage:subMsg type:BSAlertMessageTypeDefault placeholder:nil txtFldTxt:nil cancelTxt:cancel actionTxt:action handle:handle];
}

/// BSAlertMessageTypeTextFeild
+ (void)alertMessage:(id)msg subMessage:(id)subMsg placeholder:(NSString *)placeholder txtFldTxt:(NSString *)txtFldTxt cancelTxt:(NSString *)cancel actionTxt:(NSString *)action handle:(BSAlertMessageHandle)handle
{
    [self alertMessage:msg subMessage:subMsg type:BSAlertMessageTypeTextFeild placeholder:placeholder txtFldTxt:txtFldTxt cancelTxt:cancel actionTxt:action handle:handle];
}

+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
         placeholder:(NSString *)placeholder
           txtFldTxt:(NSString *)txtFldTxt
           cancelTxt:(NSString *)cancel
           actionTxt:(NSString *)action
         MessageType:(BSAlertMessageType )MessageType
              handle:(BSAlertMessageHandle)handle{
    [self alertMessage:msg subMessage:subMsg type:MessageType placeholder:placeholder txtFldTxt:txtFldTxt cancelTxt:cancel actionTxt:action handle:handle];
}

/// BSAlertMessageTypeAlert
+ (void)alertMessage:(id)msg subMessage:(id)subMsg actionTxt:(NSString *)action handle:(BSAlertMessageHandle)handle
{
    [self alertMessage:msg subMessage:subMsg type:BSAlertMessageTypeAlert placeholder:nil txtFldTxt:nil cancelTxt:nil actionTxt:action handle:handle];
}

///BSAlertMessageTypeTopImgAndBottonCancel, ///< 顶部图片和底部取消图标
+ (void)alertMessage:(id)msg imageName:(NSString*)imageName actionTxt:(NSString *)action
              handle:(BSAlertMessageHandle)handle
{
    [self alertMessage:msg subMessage:nil type:BSAlertMessageTypeTopImgAndBottonCancel placeholder:nil txtFldTxt:nil cancelTxt:nil actionTxt:action handle:handle];
}

+ (void)alertMessage:(id)msg subMessage:(id)subMsg type:(BSAlertMessageType)type placeholder:(NSString *)placeholder txtFldTxt:(NSString *)txtFldTxt cancelTxt:(NSString *)cancel actionTxt:(NSString *)action handle:(BSAlertMessageHandle)handle
{
    if (![self messageValid:msg subMessage:subMsg]) return;
    /*  主标题、副标题 字体规则
     *  主、副标题 都存在 ： 主 Bold 20pt #000000 ；副 Medium 16pt #666666
     *  主、副标题 仅存一 ： 主/副 Medium 16pt #000000
     *                 ： 输入框也算副标题之一
     */
    NSAttributedString *msgAttri;
    NSAttributedString *subMsgAttri;
    if ([self messageIsString:msg] && [self messageIsString:subMsg]) {
        msgAttri = [self attributstringWithText:msg font:bsFontBold(20) color:bsColorString(@"#000000")];
        subMsgAttri = [self attributstringWithText:subMsg font:bsFontMedium(16) color:bsColorString(@"#666666")];
    } else {
        UIFont *font = (type == BSAlertMessageTypeTextFeildAlertShowError || type == BSAlertMessageTypeTextFeildToIsEmail) ? bsFontBold(20) : bsFontMedium(16);
        msgAttri = [self attributstringWithText:([self messageIsString:msg] ? msg : subMsg) font:font color:bsColorString(@"#000000")];
    }
    NSAttributedString *cancelAttri = [self attributstringWithText:cancel font:bsFontMedium(20) color:bsColorString(@"#999999")];
    NSAttributedString *actionAttri = [self attributstringWithText:action font:bsFontMedium(20) color:bsColorString(@"#181A20")];
    
    BSAlertMessageType alertType = (!cancelAttri || cancelAttri.length == 0) ? BSAlertMessageTypeAlert : type;
    if (type == BSAlertMessageTypeTopImgAndBottonCancel) alertType = type ;
    
    [self alertMessage:msgAttri subMessage:subMsgAttri type:alertType placeholder:placeholder txtFldTxt:txtFldTxt cancelAttri:cancelAttri actionAttri:actionAttri handle:handle];
}

+ (void)alertMessage:(NSAttributedString *)msg subMessage:(NSAttributedString *)subMsg type:(BSAlertMessageType)type placeholder:(NSString *)placeholder txtFldTxt:(NSString *)txtFldTxt cancelAttri:(NSAttributedString *)cancel actionAttri:(NSAttributedString *)action handle:(BSAlertMessageHandle)handle
{
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    instance.actionHandle = handle;
    instance.alertType = type;
    if (type== BSAlertMessageTypeTextFeildAlertShowError) {
        [instance showErrorLabel];
    } else if (type== BSAlertMessageTypeTextFeildToIsEmail) {
        [instance showErrorForEmailLabel];
    }
    if (type== BSAlertMessageTypeTopImgAndBottonCancel) {
        instance.topImageView.image = [UIImage imageNamed:@"activity_ear_alert_TopIcon"] ;
        instance.topImageBgView.hidden = NO ;
        instance.cancelImgButton.hidden = NO ;
        
    } else {
        if (instance.topImageBgView.hidden == NO) {
            instance.topImageBgView.hidden = YES ;
            instance.cancelImgButton.hidden = YES ;
        }
    }
    instance.inputNone = YES;
    [instance dismissIfNeeded];
    
    instance.titleLable.attributedText = msg;
    instance.titleLable.hidden = (msg == nil);
    instance.messageLabel.attributedText = subMsg;
    instance.messageLabel.hidden = (subMsg == nil);
    instance.inputTextFeild.placeholder = placeholder;
    instance.inputTextFeild.text = txtFldTxt;
    
    instance.actionView.hidden = (type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel);
    instance.singleActionBtn.hidden = !(type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel);
    instance.inputBackgroundView.hidden = !(type == BSAlertMessageTypeTextFeildAlertShowError || type == BSAlertMessageTypeTextFeildToIsEmail );
    
    if (type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel) {
        CGSize size = [action.string bs_sizeWithLabelHeight:40 font:bsFontMedium(20)] ;
        CGFloat width = [self screenMaxWidth:0 max:460 margin:60] - bsValue(60);
        if ( size.width > width ) {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, 66));
            }];
        } else if (size.width+50 > bsValue(160)) {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size.width + 50, 50));
            }];
        } else {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(bsValue(160), 50));
            }];
        }
        [instance.singleActionBtn setTitle:action.string forState:UIControlStateNormal];
    } else {
        instance.cancelLabel.attributedText = cancel;
        instance.actionLabel.attributedText = action;
    }
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
//        [BSCrashProtectionManager reportErrorWithMessage:@"[UIApplication sharedApplication].keyWindow 中 window 为 nil"];

        AppDelegate *delegate = (AppDelegate*) [UIApplication sharedApplication].delegate;
        window = delegate.window;
    }
    if (!window) {
//        [BSCrashProtectionManager reportErrorWithMessage:@"获取 window 为 nil"];
        return;
    }
    [window addSubview:instance.alertView];
    [instance.alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
}


#pragma mark - Actions

- (void)actionsDidTouched:(UIButton *)button
{
    if (self.actionHandle)
    {
        BOOL textFeildType = (self.alertType == BSAlertMessageTypeTextFeildAlertShowError);
        NSString *inputTextStr = self.inputTextFeild.text ;
        inputTextStr = [BSStringUtil removeBothSideBlankWithString:inputTextStr] ;
        if(textFeildType && (button == self.actionButton)) {
            if (!self.inputNone ) {
                if (inputTextStr.length <= 0) {
                    self.errorLabel.hidden  = NO;
                    [self showErrorLabel];
                    return;
                } else {
                    id content = textFeildType ? inputTextStr : nil;
                    self.actionHandle(button == self.cancelButton ? BSAlertMessageActionCancel : BSAlertMessageActionEvents, content);
                    return;
                }
            }
        }
        
        if (textFeildType && !self.inputNone && (button == self.actionButton)) {
            if (inputTextStr.length <= 0) {
                self.errorLabel.hidden  = NO;
                return;
            }
        } else  {
            textFeildType = (self.alertType == BSAlertMessageTypeTextFeildToIsEmail);
            if (textFeildType && !self.inputNone && (button == self.actionButton)) {
                if (inputTextStr.length <= 0 ||[NSString bs_isEmailWithAccount:inputTextStr] == NO) {
                    self.errorLabel.hidden  = NO;
                    return;
                }
            }
        }
        id content = textFeildType ? inputTextStr : nil;
        self.actionHandle(button == self.cancelButton ? BSAlertMessageActionCancel : BSAlertMessageActionEvents, content);
    }
    [self dismissIfNeeded];
}

- (void)dismissGesture:(UIGestureRecognizer *)gesture
{
    if (!self.bgGestureEnabel) return;
    [self dismissIfNeeded];
}

- (void)dismissIfNeeded
{
    self.bgGestureEnabel = YES;
    self.errorLabel.hidden = YES ;
    if (self.alertView.superview) [self.alertView removeFromSuperview];
}

+(void)dismissAlertMessage{
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    [instance dismissIfNeeded];
}

/// 更新提示语详情的字体大小、颜色
+ (void)updateDetailLabFont:(UIFont *)font color:(UIColor *)color
{
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    NSString *subMsg = instance.messageLabel.attributedText.string;
    if (![NSString isEnableWithString:subMsg]) return;
    NSAttributedString *subMsgAttri = [self attributstringWithText:subMsg font:font color:color];
    instance.messageLabel.attributedText = subMsgAttri;
}

+(void)setAlertErrorLabelMessage:(NSString*)errorMessage {
    BSAlertMessageTool *instance = [BSAlertMessageTool shareInstance];
    [instance showAlertErrorMessage:errorMessage];
}

#pragma mark - Life Cycle

+ (instancetype)shareInstance {
    static BSAlertMessageTool *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[super allocWithZone:NULL] init];;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [BSAlertMessageTool shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [BSAlertMessageTool shareInstance];
}

- (instancetype)init {
    if (self = [super init]) {
        self.bgGestureEnabel = YES;
        [self initContentView];
//        [self addRefreshIpadScreenSizeNotification];
    }
    return self;
}

- (void)initContentView
{
    //
    [self.alertView addSubview:self.bgGestureView];
    [self.alertView addSubview:self.contentBgView];
    [self.bgGestureView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0);
    }];
    CGFloat width = [self screenMaxWidth:0 max:460 margin:60];
    [self.contentBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.width.mas_equalTo(width);
        make.height.mas_greaterThanOrEqualTo(bsValue(180));
    }];
    //
    UIStackView *stackView = [[UIStackView alloc] init];
    stackView.spacing = 24;
    stackView.axis  = UILayoutConstraintAxisVertical;
    stackView.distribution = UIStackViewDistributionEqualSpacing;
    [self.contentView addSubview:stackView];
    [self.contentBgView addSubview:self.contentView];
    //
    [stackView addArrangedSubview:self.topImageBgView];
    [self.topImageBgView addSubview:self.topImageView];
    [stackView addArrangedSubview:self.titleLable];
    [stackView addArrangedSubview:self.messageLabel];
    [stackView addArrangedSubview:self.inputBackgroundView];
    [self.inputBackgroundView addSubview:self.inputTextFeild];
    //
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 0, 72, 0));
    }];
    [stackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(bsValue(30), bsValue(30), bsValue(30), bsValue(30)));
    }];
    [self.topImageBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(70-24-bsValue(30));
    }];
    [self.topImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(124, 124));
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(-69-bsValue(30));
    }];
    [self.inputBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(60);
    }];
    [self.inputTextFeild mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(UIEdgeInsetsMake(0, 20, 0, 10));
    }];
    [stackView addArrangedSubview:self.errorLabel];
    [self.errorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.inputBackgroundView.mas_bottom).offset (20);
    }];
    //
    [self.contentBgView addSubview:self.actionView];
    //
    UIView *line1 = [UIView new];
    line1.backgroundColor = bsColorString(@"#E4E6EA");
    UIView *line2 = [UIView new];
    line2.backgroundColor = bsColorString(@"#E4E6EA");
    [self.actionView addSubview:line1];
    [self.actionView addSubview:line2];
    [self.cancelButton addSubview:self.cancelLabel];
    [self.actionButton addSubview:self.actionLabel];
    [self.actionView addSubview:self.cancelButton];
    [self.actionView addSubview:self.actionButton];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.contentView.mas_bottom);
    }];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(33);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(1);
    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.mas_equalTo(0);
        make.right.equalTo(line2.mas_left);
    }];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.right.mas_equalTo(0);
        make.left.equalTo(line2.mas_right);
    }];
    [self.cancelLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    [self.actionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.centerY.mas_equalTo(0);
    }];
    
    //
    [self.contentBgView addSubview:self.singleActionBtn];
    [self.singleActionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-22);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(bsValue(160), 50));
    }];
    /// 添加取消按钮
    [self.alertView addSubview:self.cancelImgButton];
    [self.cancelImgButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentBgView.mas_bottom).offset(18);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(28, 28));
    }];
}

-(void)showErrorLabel{
    self.errorLabel.text = NSLocalizedStringkey(@"self_define_name_is_not_empty") ;
}

-(void)showAlertErrorMessage:(NSString*)errorMessage {
    self.errorLabel.text = errorMessage ;
    self.errorLabel.hidden = NO ;
}

-(void)showErrorForEmailLabel{
    self.errorLabel.text = NSLocalizedStringkey(@"register_email_format_error") ;
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (self.alertType == BSAlertMessageTypeTextFeildAlertShowError || self.alertType == BSAlertMessageTypeTextFeildToIsEmail) {
        self.errorLabel.hidden = YES;
    }
    return YES ;
}

#pragma mark - Getters

- (UIView *)alertView {
    if (!_alertView) {
        _alertView = [[UIView alloc] init];
        _alertView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    }
    return _alertView;
}

- (UIView *)bgGestureView {
    if (!_bgGestureView) {
        _bgGestureView = [[UIView alloc] init];
        _bgGestureView.backgroundColor = bsColorAlphaString(@"#000000", 0.8);
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]
                                            initWithTarget:self action:@selector(dismissGesture:)];
        [_bgGestureView addGestureRecognizer:gesture];
    }
    return _bgGestureView;
}

- (UIView *)contentBgView {
    if (!_contentBgView) {
        _contentBgView = [[UIView alloc] init];
        _contentBgView.backgroundColor = bsColorString(@"#FFFFFF");
        _contentBgView.layer.cornerRadius = 20;
    }
    return _contentBgView;
}

- (UIView *)contentView {
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (UILabel *)titleLable {
    if (!_titleLable) {
        _titleLable = [[UILabel alloc] init];
        _titleLable.font = bsFontBold(20);
        _titleLable.numberOfLines = 0;
        _titleLable.textColor = bsColorString(@"#000000");
        _titleLable.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLable;
}

- (UILabel *)errorLabel {
    if (!_errorLabel) {
        _errorLabel = [[UILabel alloc] init];
        _errorLabel.font = bsFontBold(12);
        _errorLabel.numberOfLines = 0;
        _errorLabel.hidden = YES ;

        _errorLabel.textColor = bsColorString(@"#EA2424");
        _errorLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _errorLabel;
}

- (UILabel *)messageLabel {
    if (!_messageLabel) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.font = bsFontMedium(16);
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = bsColorString(@"#666666");
        _messageLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _messageLabel;
}

- (UIView *)inputBackgroundView {
    if (!_inputBackgroundView) {
        _inputBackgroundView = [[UIView alloc] init];
        _inputBackgroundView.backgroundColor = bsColorString(@"#EAECF1");
        _inputBackgroundView.layer.cornerRadius = 12;
        _inputBackgroundView.hidden = YES;
    }
    return _inputBackgroundView;
}

- (UITextField *)inputTextFeild {
    if (!_inputTextFeild) {
        _inputTextFeild = [[UITextField alloc] init];
        _inputTextFeild.font = bsFontRegular(16);
        _inputTextFeild.textColor = bsColorString(@"#666666");
        _inputTextFeild.delegate = self;
        // [_inputTextFeild setValue:[NSNumber numberWithInt:10] forKey:@"paddingLeft"]; // 输入的文字右偏移10单位,placeholder不会偏移-- Bug
    }
    return _inputTextFeild;
}

- (UIView *)actionView {
    if (!_actionView) {
        _actionView = [UIView new];
    }
    return _actionView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelButton addTarget:self
                          action:@selector(actionsDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [UILabel new];
        _cancelLabel.font = bsFontMedium(20);
        _cancelLabel.textColor = bsColorString(@"#999999");
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.numberOfLines = 0;
    }
    return _cancelLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton addTarget:self
                          action:@selector(actionsDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [UILabel new];
        _actionLabel.font = bsFontMedium(20);
        _actionLabel.textColor = bsColorString(@"#181A20");
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        _actionLabel.numberOfLines = 0;
    }
    return _actionLabel;
}

- (UIButton *)singleActionBtn {
    if (!_singleActionBtn) {
        _singleActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _singleActionBtn.layer.cornerRadius = 12;
        _singleActionBtn.titleLabel.font = bsFontMedium(20);
        _singleActionBtn.titleLabel.numberOfLines = 2 ;
        _singleActionBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
        _singleActionBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _singleActionBtn.backgroundColor = bsColorString(@"#181A20");
        [_singleActionBtn setTitleColor:bsColorString(@"#FFFFFF") forState:UIControlStateNormal];
        [_singleActionBtn addTarget:self
                             action:@selector(actionsDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _singleActionBtn;
}

- (UIView *)topImageBgView {
    if (!_topImageBgView) {
        _topImageBgView = [[UIView alloc] init];
    }
    return _topImageBgView;
}

- (UIImageView *)topImageView {
    if (!_topImageView) {
        _topImageView = [UIImageView new];
        _topImageView.contentMode = UIViewContentModeScaleAspectFit ;
    }
    return _topImageView;
}

- (UIButton *)cancelImgButton {
    if (!_cancelImgButton) {
        _cancelImgButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelImgButton setImage:[UIImage imageNamed:@"close_white"] forState:UIControlStateNormal];
        _cancelImgButton.bs_touchInset = UIEdgeInsetsMake(-20, -20, -20, -20);
        [_cancelImgButton addTarget:self
                             action:@selector(dismissIfNeeded) forControlEvents:UIControlEventTouchUpInside];
        _cancelImgButton.hidden = YES ;
    }
    return _cancelImgButton;
}

#pragma mark - ipad
- (void)refreshIpadScreenSizeAction:(CGSize)size{
    CGFloat width = [self screenWidth:size];
    width = [self screenMaxWidth:width max:460 margin:60];
    [self.contentBgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(width);
    }];
}

-(void)dealloc{
    [self removeRefreshIpadScreenSizeNotification];
}
@end
