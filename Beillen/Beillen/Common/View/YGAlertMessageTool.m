//
//  YGAlertMessageTool.m
//  Beillen
//
//  Created by chenyi on 2026/9/30.
//

#import "YGAlertMessageTool.h"
#import <UIKit/UIKit.h>

@interface YGAlertMessageTool()<UITextFieldDelegate>
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


@implementation YGAlertMessageTool
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
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
    instance.bgGestureEnabel = enable;
}
/// 更新输入框是否可为空
+ (void)updateInputNoneText:(BOOL)none
{
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
    instance.inputNone = none;
}


/// BSAlertMessageTypeDefault
+ (void)alertMessage:(id)msg subMessage:(id)subMsg cancelTxt:(NSString *)cancel actionTxt:(NSString *)action handle:(BSAlertMessageHandle)handle
{
    [self alertMessage:msg subMessage:subMsg type:BSAlertMessageTypeDefault placeholder:nil txtFldTxt:nil cancelTxt:cancel actionTxt:action handle:handle];
}

/// 红色确认按钮
+ (void)alertMessage:(id)msg
          subMessage:(id)subMsg
           cancelTxt:(NSString *)cancel
        actionTxtRed:(NSString *)action
              handle:(BSAlertMessageHandle)handle{
    [self alertMessage:msg subMessage:subMsg type:BSAlertMessageTypeActionForRedBg placeholder:nil txtFldTxt:nil cancelTxt:cancel actionTxt:action handle:handle];
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
     *  主、副标题 都存在 ： 主 bsFontRegular 20pt #191C1E ；副 bsFontRegular 16pt ##454558
     *  主、副标题 仅存一 ： 主/副 bsFontRegular 16pt #191C1E
     *                 ： 输入框也算副标题之一
     */
    NSAttributedString *msgAttri;
    NSAttributedString *subMsgAttri;
    if ([self messageIsString:msg] && [self messageIsString:subMsg]) {
        msgAttri = [self attributstringWithText:msg font:bsFontRegular(20) color:bsColorString(@"#191C1E")];
        subMsgAttri = [self attributstringWithText:subMsg font:bsFontRegular(16) color:bsColorString(@"#454558")];
    } else {
        UIFont *font = (type == BSAlertMessageTypeTextFeildAlertShowError || type == BSAlertMessageTypeTextFeildToIsEmail) ? bsFontRegular(20) : bsFontRegular(16);
        msgAttri = [self attributstringWithText:([self messageIsString:msg] ? msg : subMsg) font:font color:bsColorString(@"#191C1E")];
    }
    NSAttributedString *cancelAttri = [self attributstringWithText:cancel font:bsFontRegular(14) color:bsColorString(@"#191C1E")];
    NSAttributedString *actionAttri = [self attributstringWithText:action font:bsFontRegular(14) color:bsColorString(@"#FFFFFF")];
    
    BSAlertMessageType alertType = (!cancelAttri || cancelAttri.length == 0) ? BSAlertMessageTypeAlert : type;
    if (type == BSAlertMessageTypeTopImgAndBottonCancel) alertType = type ;
    
    [self alertMessage:msgAttri subMessage:subMsgAttri type:alertType placeholder:placeholder txtFldTxt:txtFldTxt cancelAttri:cancelAttri actionAttri:actionAttri handle:handle];
}

+ (void)alertMessage:(NSAttributedString *)msg subMessage:(NSAttributedString *)subMsg type:(BSAlertMessageType)type placeholder:(NSString *)placeholder txtFldTxt:(NSString *)txtFldTxt cancelAttri:(NSAttributedString *)cancel actionAttri:(NSAttributedString *)action handle:(BSAlertMessageHandle)handle
{
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
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
    if (type == BSAlertMessageTypeActionForRedBg) {
        [instance.actionButton setBackgroundImage:[UIImage imageNamed:@"common_btn_red_bg"] forState:UIControlStateNormal];
    } else {
        [instance.actionButton setBackgroundImage:[UIImage imageNamed:@"common_btn_ok_bg"] forState:UIControlStateNormal];
    }
    instance.actionView.hidden = (type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel);
    instance.singleActionBtn.hidden = !(type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel);
    instance.inputBackgroundView.hidden = !(type == BSAlertMessageTypeTextFeildAlertShowError || type == BSAlertMessageTypeTextFeildToIsEmail || type == BSAlertMessageTypeTextFeild );
    
    if (type == BSAlertMessageTypeAlert || type == BSAlertMessageTypeTopImgAndBottonCancel) {
        CGSize size = [action.string bs_sizeWithLabelHeight:40 font:bsFontRegular(20)] ;
        CGFloat width = [self screenMaxWidth:0 max:460 margin:60] - bsValue(60);
        if ( size.width > width ) {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(width, 44));
            }];
        } else if (size.width+50 > bsValue(160)) {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(size.width + 50, 44));
            }];
        } else {
            [instance.singleActionBtn  mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(140, 44));
            }];
        }
        [instance.singleActionBtn setTitle:action.string forState:UIControlStateNormal];
    } else {
        instance.cancelLabel.attributedText = cancel;
        instance.actionLabel.attributedText = action;
    }
    
    UIWindow *window = nil;
    for (UIScene *scene in [UIApplication sharedApplication].connectedScenes) {
        if ([scene isKindOfClass:[UIWindowScene class]] && scene.activationState == UISceneActivationStateForegroundActive) {
            UIWindowScene *windowScene = (UIWindowScene *)scene;
            for (UIWindow *windowView in windowScene.windows) {
                if (windowView.isKeyWindow) {
                    window = windowView;
                    break;
                }
            }
        }
    }
    
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
        } else if (textFeildType == NO)  {
            textFeildType = (self.alertType == BSAlertMessageTypeTextFeildToIsEmail);
            if (textFeildType && !self.inputNone && (button == self.actionButton)) {
                if (inputTextStr.length <= 0 ||[NSString bs_isEmailWithAccount:inputTextStr] == NO) {
                    self.errorLabel.hidden  = NO;
                    return;
                }
            } else {
                textFeildType = (self.alertType == BSAlertMessageTypeTextFeild);
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
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
    [instance dismissIfNeeded];
}

/// 更新提示语详情的字体大小、颜色
+ (void)updateDetailLabFont:(UIFont *)font color:(UIColor *)color
{
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
    NSString *subMsg = instance.messageLabel.attributedText.string;
    if (![NSString isEnableWithString:subMsg]) return;
    NSAttributedString *subMsgAttri = [self attributstringWithText:subMsg font:font color:color];
    instance.messageLabel.attributedText = subMsgAttri;
}

+(void)setAlertErrorLabelMessage:(NSString*)errorMessage {
    YGAlertMessageTool *instance = [YGAlertMessageTool shareInstance];
    [instance showAlertErrorMessage:errorMessage];
}

#pragma mark - Life Cycle

+ (instancetype)shareInstance {
    static YGAlertMessageTool *instance;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        instance = [[super allocWithZone:NULL] init];;
    });
    return instance;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    return [YGAlertMessageTool shareInstance];
}

- (id)copyWithZone:(struct _NSZone *)zone {
    return [YGAlertMessageTool shareInstance];
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
//    UIView *line1 = [UIView new];
//    line1.backgroundColor = bsColorString(@"#E4E6EA");
    UIView *line2 = [UIView new];
//    line2.backgroundColor = bsColorString(@"#E4E6EA");
//    [self.actionView addSubview:line1];
    [self.actionView addSubview:line2];
    [self.cancelButton addSubview:self.cancelLabel];
    [self.actionButton addSubview:self.actionLabel];
    [self.actionView addSubview:self.cancelButton];
    [self.actionView addSubview:self.actionButton];
    
    [self.actionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.mas_equalTo(0);
        make.top.equalTo(self.contentView.mas_bottom);
    }];
//    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(0);
//        make.left.mas_equalTo(33);
//        make.centerX.mas_equalTo(0);
//        make.height.mas_equalTo(1);
//    }];
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(0);
        make.size.mas_equalTo(CGSizeMake(1, 24));
    }];
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(24);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(0);
//        make.right.mas_equalTo(self.actionView.centerX).offset(-8);
        make.right.equalTo(line2.mas_left).offset(-10);;
    }];
    [self.actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.bottom.right.mas_equalTo(0);
        make.left.equalTo(line2.mas_right).offset(10);
        make.right.mas_equalTo(-24);
//        make.left.mas_equalTo(self.actionView.centerX).offset(8);
        make.height.mas_equalTo(44);
        make.centerY.mas_equalTo(0);
      
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
        make.size.mas_equalTo(CGSizeMake(140, 44));
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
        _bgGestureView.backgroundColor = bsColorAlphaString(@"#000000", 0.6);
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
        _titleLable.font = bsFontRegular(20);
        _titleLable.numberOfLines = 0;
        _titleLable.textColor = bsColorString(@"#191C1E");
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
        _messageLabel.font = bsFontRegular(16);
        _messageLabel.numberOfLines = 0;
        _messageLabel.textColor = bsColorString(@"#454558");
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
        _inputTextFeild.textColor = bsColorString(@"#454558");
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
        [_cancelButton setBackgroundImage:[UIImage imageNamed:@"common_btn_cancel_bg"] forState:UIControlStateNormal];
        [_cancelButton addTarget:self
                          action:@selector(actionsDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UILabel *)cancelLabel {
    if (!_cancelLabel) {
        _cancelLabel = [UILabel new];
        _cancelLabel.font = bsFontRegular(14);
        _cancelLabel.textColor = bsColorString(@"#191C1E");
        _cancelLabel.textAlignment = NSTextAlignmentCenter;
        _cancelLabel.numberOfLines = 0;
    }
    return _cancelLabel;
}

- (UIButton *)actionButton {
    if (!_actionButton) {
        _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_actionButton setBackgroundImage:[UIImage imageNamed:@"common_btn_ok_bg"] forState:UIControlStateNormal];
        [_actionButton addTarget:self
                          action:@selector(actionsDidTouched:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _actionButton;
}

- (UILabel *)actionLabel {
    if (!_actionLabel) {
        _actionLabel = [UILabel new];
        _actionLabel.font = bsFontRegular(14);
        _actionLabel.textColor = bsColorString(@"#FFFFFF");
        _actionLabel.textAlignment = NSTextAlignmentCenter;
        _actionLabel.numberOfLines = 0;
    }
    return _actionLabel;
}

- (UIButton *)singleActionBtn {
    if (!_singleActionBtn) {
        _singleActionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        _singleActionBtn.layer.cornerRadius = 12;
        _singleActionBtn.titleLabel.font = bsFontRegular(14);
        _singleActionBtn.titleLabel.numberOfLines = 2 ;
        _singleActionBtn.titleLabel.textAlignment = NSTextAlignmentCenter ;
        _singleActionBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
//        _singleActionBtn.backgroundColor = bsColorString(@"#181A20");
        [_singleActionBtn setBackgroundImage:[UIImage imageNamed:@"common_btn_ok_bg"] forState:UIControlStateNormal];
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
