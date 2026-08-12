//
//  AppColorHeader.h
//  BaseusAPP
//
//  Created by wushuang on 2021/6/25.
//

#ifndef AppColorHeader_h
#define AppColorHeader_h

// MARK: - Color

/// 颜色值
#define bsColorString(x) [UIColor bs_colorFromARGB:x]
/// 颜色值-透明度
#define bsColorAlphaString(x,alp) [UIColor bs_colorFromARGB:x alpha:alp]

/// 橙色
#define bsOrangeColor [UIColor bs_colorFromARGB:@"#FD6906"]
/// 橙色
#define bsOrangeDisabledColor [UIColor bs_colorFromARGB:@"#FFD1B3"]
/// 灰黑色
#define bsGrayBlackColor [UIColor bs_colorFromARGB:@"#333333"]
/// 淡灰色
#define bsLightGrayColor [UIColor bs_colorFromARGB:@"#F0F0F1"]
/// 黑色
#define bsBlackColor [UIColor bs_colorFromARGB:@"#000000"]
/// 白色
#define bsWhiteColor [UIColor bs_colorFromARGB:@"#FFFFFF"]

// MARK: UI Color

/// 按钮背景色 - 橙色
#define bsBtnBgColor bsOrangeColor
/// 按钮背景色-不可点击 - 橙色
#define bsBtnBackDisabledColor bsOrangeDisabledColor
/// 文案颜色 - 橙色
#define bsTextFgColor bsOrangeColor

// MARK:- UIFont

/// Regular
#define bsFontRegular(x) [UIFont bs_regularFontWithFontSize:x]
/// Medium
#define bsFontMedium(x) [UIFont bs_mediumFontWithFontSize:x]
/// Bold
#define bsFontBold(x) [UIFont bs_semiboldFontWithFontSize:x]
/// Thin
#define bsFontThin(x) [UIFont bs_thinFontWithFontSize:x]

#endif /* AppColorHeader_h */
