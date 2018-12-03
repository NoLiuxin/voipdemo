//
//  TestListLayout.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/6/1.
//  Copyright © 2018年 Liuxin. All rights reserved.
//


#import "TestListLayout.h"

// 宽高
#define kWBCellTopMargin 8      // cell 顶部灰色留白
#define kWBCellTitleHeight 36   // cell 标题高度 (例如"仅自己可见")
#define kWBCellPadding 12       // cell 内边距
#define kWBCellPaddingText 10   // cell 文本与其他元素间留白
#define kWBCellPaddingPic 4     // cell 多张图片中间留白
#define kWBCellProfileHeight 56 // cell 名片高度
#define kWBCellCardHeight 70    // cell card 视图高度
#define kWBCellNamePaddingLeft 14 // cell 名字和 avatar 之间留白
#define kWBCellContentWidth (kScreenWidth - 2 * kWBCellPadding) // cell 内容宽度
#define kWBCellNameWidth (kScreenWidth - 110) // cell 名字最宽限制

#define kWBCellTagPadding 8         // tag 上下留白
#define kWBCellTagNormalHeight 16   // 一般 tag 高度
#define kWBCellTagPlaceHeight 24    // 地理位置 tag 高度

#define kWBCellToolbarHeight 35     // cell 下方工具栏高度
#define kWBCellToolbarBottomMargin 2 // cell 下方灰色留白

// 字体 应该做成动态的，这里只是 Demo，临时写死了。
#define kWBCellNameFontSize 16      // 名字字体大小
#define kWBCellSourceFontSize 12    // 来源字体大小
#define kWBCellTextFontSize 17      // 文本字体大小
#define kWBCellTextFontRetweetSize 16 // 转发字体大小
#define kWBCellCardTitleFontSize 16 // 卡片标题文本字体大小
#define kWBCellCardDescFontSize 12 // 卡片描述文本字体大小
#define kWBCellTitlebarFontSize 14 // 标题栏字体大小
#define kWBCellToolbarFontSize 14 // 工具栏字体大小

// 颜色
#define kWBCellNameNormalColor UIColorHex(333333) // 名字颜色
#define kWBCellNameOrangeColor UIColorHex(f26220) // 橙名颜色 (VIP)
#define kWBCellTimeNormalColor UIColorHex(828282) // 时间颜色
#define kWBCellTimeOrangeColor UIColorHex(f28824) // 橙色时间 (最新刷出)

#define kWBCellTextNormalColor UIColorHex(333333) // 一般文本色
#define kWBCellTextSubTitleColor UIColorHex(5d5d5d) // 次要文本色
#define kWBCellTextHighlightColor UIColorHex(527ead) // Link 文本色
#define kWBCellTextHighlightBackgroundColor UIColorHex(bfdffe) // Link 点击背景色
#define kWBCellToolbarTitleColor UIColorHex(929292) // 工具栏文本色
#define kWBCellToolbarTitleHighlightColor UIColorHex(df422d) // 工具栏文本高亮色

#define kWBCellBackgroundColor UIColorHex(f2f2f2)    // Cell背景灰色
#define kWBCellHighlightColor UIColorHex(f0f0f0)     // Cell高亮时灰色
#define kWBCellInnerViewColor UIColorHex(f7f7f7)   // Cell内部卡片灰色
#define kWBCellInnerViewHighlightColor  UIColorHex(f0f0f0) // Cell内部卡片高亮时灰色
#define kWBCellLineColor [UIColor colorWithWhite:0.000 alpha:0.09] //线条颜色

#define kWBLinkHrefName @"href" //NSString
#define kWBLinkURLName @"url" //WBURL
#define kWBLinkTagName @"tag" //WBTag
#define kWBLinkTopicName @"topic" //WBTopic
#define kWBLinkAtName @"at" //NSString

@implementation TestListLayout

- (instancetype)initWithStatus:(TestListModel *)status{
    if (!status) return nil;
    self = [super init];
    _status = status;
    [self layout];
    return self;
}
- (void)layout{
    [self _layout];
}
- (void)_layout{
    _marginTop = kWBCellTopMargin;
    _profileHeight = 0;
    _textHeight = 0;
    _picHeight = 0;
    _toolbarHeight = kWBCellToolbarHeight;
    _marginBottom = kWBCellToolbarBottomMargin;
    
    // 文本排版，计算布局
    [self _layoutProfile];
    
    [self _layoutText];
    
    [self _layoutPics];
    
    [self _layoutToolbar];
    
    // 计算高度
    _height = 0;
    _height += _marginTop;
    _height += _profileHeight;
    _height += _textHeight;
    
    if (_picHeight > 0) {
        _height += _picHeight;
    }
    if (_picHeight > 0) {
        _height += kWBCellPadding;
    }
    _height += _toolbarHeight;
    _height += _marginBottom;
}
- (void)_layoutProfile {
    [self _layoutName];
    [self _layoutSource];
    _profileHeight = kWBCellProfileHeight;
}
/// 名字
- (void)_layoutName {
    NSString *nameStr = @"黑默丁格";
    if (nameStr.length == 0) {
        _nameTextLayout = nil;
        return;
    }
    
    NSMutableAttributedString *nameText = [[NSMutableAttributedString alloc] initWithString:nameStr];
    nameText.font = [UIFont systemFontOfSize:kWBCellNameFontSize];
    nameText.color = kWBCellNameNormalColor ;
    nameText.lineBreakMode = NSLineBreakByCharWrapping;
    
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
    container.maximumNumberOfRows = 1;
    _nameTextLayout = [YYTextLayout layoutWithContainer:container text:nameText];
}
/// 时间和来源
- (void)_layoutSource {
    NSMutableAttributedString *sourceText = [NSMutableAttributedString new];
    NSString *createTime = @"2018-06-01 02:29";
    
    // 时间
    if (createTime.length) {
        NSMutableAttributedString *timeText = [[NSMutableAttributedString alloc] initWithString:createTime];
        [timeText appendString:@"  "];
        timeText.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        timeText.color = kWBCellTimeNormalColor;
        [sourceText appendAttributedString:timeText];
    }
    
    NSString *sourceStr = @"iPhone6S";
    // <a href="sinaweibo://customweibosource" rel="nofollow">iPhone 5siPhone 5s</a>
    static NSRegularExpression *hrefRegex, *textRegex;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hrefRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=href=\").+(?=\" )" options:kNilOptions error:NULL];
        textRegex = [NSRegularExpression regularExpressionWithPattern:@"(?<=>).+(?=<)" options:kNilOptions error:NULL];
    });
    NSTextCheckingResult *hrefResult, *textResult;
    NSString *href = nil, *text = nil;
    hrefResult = [hrefRegex firstMatchInString:sourceStr options:kNilOptions range:NSMakeRange(0, sourceStr.length)];
    textResult = [textRegex firstMatchInString:sourceStr options:kNilOptions range:NSMakeRange(0, sourceStr.length)];
    if (hrefResult && textResult && hrefResult.range.location != NSNotFound && textResult.range.location != NSNotFound) {
        href = [sourceStr substringWithRange:hrefResult.range];
        text = [sourceStr substringWithRange:textResult.range];
    }
    if (href.length && text.length) {
        NSMutableAttributedString *from = [NSMutableAttributedString new];
        [from appendString:[NSString stringWithFormat:@"来自 %@", text]];
        from.font = [UIFont systemFontOfSize:kWBCellSourceFontSize];
        from.color = kWBCellTimeNormalColor;
        
        NSRange range = NSMakeRange(3, text.length);
        [from setColor:kWBCellTextHighlightColor range:range];
        YYTextBackedString *backed = [YYTextBackedString stringWithString:href];
        [from setTextBackedString:backed range:range];
        
        YYTextBorder *border = [YYTextBorder new];
        border.insets = UIEdgeInsetsMake(-2, 0, -2, 0);
        border.fillColor = kWBCellTextHighlightBackgroundColor;
        border.cornerRadius = 3;
        YYTextHighlight *highlight = [YYTextHighlight new];
        if (href) highlight.userInfo = @{kWBLinkHrefName : href};
        [highlight setBackgroundBorder:border];
        [from setTextHighlight:highlight range:range];

        [sourceText appendAttributedString:from];
    }
    
    if (sourceText.length == 0) {
        _sourceTextLayout = nil;
    } else {
        YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kWBCellNameWidth, 9999)];
        container.maximumNumberOfRows = 1;
        _sourceTextLayout = [YYTextLayout layoutWithContainer:container text:sourceText];
    }
}

/// 文本
- (void)_layoutText {
    _textHeight = 0;
    _textLayout = nil;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:_status.contentText];
    text.font = [UIFont systemFontOfSize:kWBCellTextFontSize];
    text.color = kWBCellTextNormalColor;
    
    if (text.length == 0) return;
    
    WBTextLinePositionModifier *modifier = [WBTextLinePositionModifier new];
    modifier.font = [UIFont fontWithName:@"Heiti SC" size:kWBCellTextFontSize];
    modifier.paddingTop = kWBCellPaddingText;
    modifier.paddingBottom = kWBCellPaddingText;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = CGSizeMake(kWBCellContentWidth, HUGE);
    container.linePositionModifier = modifier;
    
    _textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (!_textLayout) return;
    
    _textHeight = [modifier heightForLineCount:_textLayout.rowCount];
}

- (void)_layoutPics {
    _picSize = CGSizeZero;
    _picHeight = 0;
    
    if (_status.imageArray.count == 0) return;
    
    CGSize picSize = CGSizeZero;
    CGFloat picHeight = 0;
    
    CGFloat len1_3 = (kWBCellContentWidth + kWBCellPaddingPic) / 3 - kWBCellPaddingPic;
    len1_3 = CGFloatPixelRound(len1_3);
    switch (_status.imageArray.count) {
        case 1: {
            CGFloat maxLen = kWBCellContentWidth / 2.0;
            maxLen = CGFloatPixelRound(maxLen);
            picSize = CGSizeMake(maxLen, maxLen);
            picHeight = maxLen;
        } break;
        case 2: case 3: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3;
        } break;
        case 4: case 5: case 6: {
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 2 + kWBCellPaddingPic;
        } break;
        default: { // 7, 8, 9
            picSize = CGSizeMake(len1_3, len1_3);
            picHeight = len1_3 * 3 + kWBCellPaddingPic * 2;
        } break;
    }
    _picSize = picSize;
    _picHeight = picHeight;
}
- (void)_layoutToolbar {
    // should be localized
    UIFont *font = [UIFont systemFontOfSize:kWBCellToolbarFontSize];
    YYTextContainer *container = [YYTextContainer containerWithSize:CGSizeMake(kScreenWidth, kWBCellToolbarHeight)];
    container.maximumNumberOfRows = 1;
    
    NSMutableAttributedString *repostText = [[NSMutableAttributedString alloc] initWithString:@"1000"];
    repostText.font = font;
    repostText.color = kWBCellToolbarTitleColor;
    _toolbarRepostTextLayout = [YYTextLayout layoutWithContainer:container text:repostText];
    _toolbarRepostTextWidth = CGFloatPixelRound(_toolbarRepostTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *commentText = [[NSMutableAttributedString alloc] initWithString:@"200"];
    commentText.font = font;
    commentText.color = kWBCellToolbarTitleColor;
    _toolbarCommentTextLayout = [YYTextLayout layoutWithContainer:container text:commentText];
    _toolbarCommentTextWidth = CGFloatPixelRound(_toolbarCommentTextLayout.textBoundingRect.size.width);
    
    NSMutableAttributedString *likeText = [[NSMutableAttributedString alloc] initWithString:@"5000"];
    likeText.font = font;
    likeText.color = kWBCellToolbarTitleColor;
    _toolbarLikeTextLayout = [YYTextLayout layoutWithContainer:container text:likeText];
    _toolbarLikeTextWidth = CGFloatPixelRound(_toolbarLikeTextLayout.textBoundingRect.size.width);
}
@end

/*
 将每行的 baseline 位置固定下来，不受不同字体的 ascent/descent 影响。
 
 注意，Heiti SC 中，    ascent + descent = font size，
 但是在 PingFang SC 中，ascent + descent > font size。
 所以这里统一用 Heiti SC (0.86 ascent, 0.14 descent) 作为顶部和底部标准，保证不同系统下的显示一致性。
 间距仍然用字体默认
 */
@implementation WBTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    
    if (kiOS9Later) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Heiti SC
    }
    
    return self;
}

- (void)modifyLines:(NSArray *)lines fromText:(NSAttributedString *)text inContainer:(YYTextContainer *)container {
    //CGFloat ascent = _font.ascender;
    CGFloat ascent = _font.pointSize * 0.86;
    
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    for (YYTextLine *line in lines) {
        CGPoint position = line.position;
        position.y = _paddingTop + ascent + line.row  * lineHeight;
        line.position = position;
    }
}

- (id)copyWithZone:(NSZone *)zone {
    WBTextLinePositionModifier *one = [self.class new];
    one->_font = _font;
    one->_paddingTop = _paddingTop;
    one->_paddingBottom = _paddingBottom;
    one->_lineHeightMultiple = _lineHeightMultiple;
    return one;
}

- (CGFloat)heightForLineCount:(NSUInteger)lineCount {
    if (lineCount == 0) return 0;
    //    CGFloat ascent = _font.ascender;
    //    CGFloat descent = -_font.descender;
    CGFloat ascent = _font.pointSize * 0.86;
    CGFloat descent = _font.pointSize * 0.14;
    CGFloat lineHeight = _font.pointSize * _lineHeightMultiple;
    return _paddingTop + _paddingBottom + ascent + descent + (lineCount - 1) * lineHeight;
}
@end
