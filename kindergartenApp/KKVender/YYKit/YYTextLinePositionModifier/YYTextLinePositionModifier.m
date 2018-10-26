//
//  YYTextLinePositionModifier.m
//  llyhbzfwxt
//
//  Created by Macbook Pro 15.4  on 2018/3/9.
//  Copyright © 2018年 jadl. All rights reserved.
//

#import "YYTextLinePositionModifier.h"



#pragma mark - EventType implementation
@implementation EventType

@end


#pragma mark - TextLayout implementation
@implementation TextLayout

@end



#pragma mark -YYTextLinePositionModifier implementation

@implementation YYTextLinePositionModifier

- (instancetype)init {
    self = [super init];
    if (@available(iOS 9, *)) {
        _lineHeightMultiple = 1.34;   // for PingFang SC
    } else {
        _lineHeightMultiple = 1.3125; // for Arial
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
    YYTextLinePositionModifier *one = [self.class new];
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






+ (NSMutableAttributedString *)createAttributedStringWithString:(NSString *)string textColor:(UIColor *)textColor strokeColor:(UIColor *)strokeColor fillColor:(UIColor *)fillColor edgeInset:(UIEdgeInsets)edgeInset font:(UIFont *)font cornerRadius:(CGFloat)cornerRadius textAlignment:(NSTextAlignment)textAlignment hightlightState:(BOOL)hightlight{
    
    if (string.length == 0 || string == nil) return [NSMutableAttributedString new];

    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:string];
  
    [text insertString:@"   " atIndex:0];
    [text appendString:@"   "];
    text.font = font;
    text.color = textColor;
    [text setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:text.rangeOfAll];
    
    YYTextBorder *border = [YYTextBorder new];
    border.strokeWidth = 1.0;
    border.strokeColor = strokeColor;
    border.fillColor = fillColor;
    border.cornerRadius = cornerRadius; // a huge value
    border.insets = edgeInset;
    [text setTextBackgroundBorder:border range:[text.string rangeOfString:text.string]];
    
 
    if (hightlight) {
        YYTextBorder *highlightBorder = border.copy;
        highlightBorder.strokeWidth = 0;
        highlightBorder.fillColor   = [UIColor colorWithWhite:0.5 alpha:0.9];
        
        YYTextHighlight *highlight = [YYTextHighlight new];
        [highlight setColor:[UIColor colorWithHexString:@"bfbfbf"]];
        [highlight setBackgroundBorder:highlightBorder];
        [text setTextHighlight:highlight range:text.rangeOfAll];
    }
    
    return text;
}








/**
 创建富文本,并返回富文本字符串
 
 @param string 字符串
 @param font 字体大小
 @param textColor 字体颜色
 @param alignment 文本水平对齐方式
 @param content 添加的context(例如图片)
 @param contentMode 添加的context(例如图片)的模式
 @param attachmentSize content的size
 @param textVerticalAlignment 富文本的垂直对齐方式
 @return 文本字符串
 */
+ (NSMutableAttributedString *) createAttributedStringWithString:(NSString *) string font:(UIFont *)font
                                                       textColor:(UIColor *) textColor
                                                       alignment:(NSTextAlignment)alignment
                                               attachmentContent:(id)content
                                                     contentMode:(UIViewContentMode)contentMode
                                                  attachmentSize:(CGSize)attachmentSize
                                           textVerticalAlignment:(YYTextVerticalAlignment)textVerticalAlignment{
    
    NSMutableAttributedString *context = [[NSMutableAttributedString alloc] init];
    
    if (content) {
        NSMutableAttributedString *attactImg = [NSMutableAttributedString attachmentStringWithContent:content contentMode:UIViewContentModeScaleAspectFit attachmentSize:attachmentSize alignToFont:font alignment:textVerticalAlignment];
        [context appendAttributedString:attactImg];
        [context appendString:@" "];
    }
    
    if (string.length == 0) return context;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:string];
    attr.color = textColor;
    
    [context appendAttributedString:attr];
    context.alignment = alignment;
    
    return context;
}












+ (TextLayout *) layoutWithContext:(NSString *)context
                     contextColor:(UIColor *)contextColor
                            title:(NSString *)title
                       titleColor:(UIColor *)titleColor
                             font:(UIFont *)font
                          maxRows:(NSUInteger)maxRows
                      containSize:(CGSize)containSize{
    TextLayout *layout = [[TextLayout alloc] init];
    
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    if (context.length == 0) return layout;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    if (title.length == 0) {
        
        NSMutableAttributedString *contextText = [[NSMutableAttributedString alloc] initWithString:context];
        contextText.color = contextColor ? contextColor :[UIColor colorWithHexString:@"656565"] ;
        contextText.font  = font;
        
        [attr appendAttributedString:contextText];
        
    }else{
        
        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
        titleText.color = titleColor ? titleColor : [UIColor colorWithHexString:@"656565"];
        titleText.font  = font;
        
        NSMutableAttributedString *contextText = [[NSMutableAttributedString alloc] initWithString:context];
        contextText.color = contextColor ? contextColor :[UIColor colorWithHexString:@"656565"] ;;
        contextText.font  = font;
        
        [attr appendAttributedString:titleText];
        [attr appendAttributedString:contextText];
    }
    
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = font;
    modifier.paddingTop = 8.1;
    modifier.paddingBottom = 8.1;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = UIEdgeInsetsMake(5, 10, 5, 10);
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows = maxRows ? maxRows : 0;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:attr];
    if (textLayout == nil) return layout;
    textHeight = [modifier heightForLineCount:textLayout.rowCount];
    
    layout.height = textHeight;
    layout.textLayout = textLayout;
    return layout;
}







+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                                    maxRows:(NSUInteger)maxRows
                                 paddingTop:(CGFloat) paddingTop
                              paddingBottom:(CGFloat) paddingBottom
                                     insets:(UIEdgeInsets)insets
                                containSize:(CGSize)containSize{
    
    TextLayout *layout = [[TextLayout alloc] init];
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    if (attributedString.length == 0 || attributedString == nil) return layout ;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    
    if (attributedString.length) {
        [text appendAttributedString:attributedString];
    }
    
    text.font = attributedString.font;
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = attributedString.font;
    modifier.paddingTop = paddingTop > 2.1 ? paddingTop : 2.1;
    modifier.paddingBottom = paddingBottom> 2.1 ? paddingBottom : 2.1;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = insets;
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows  = maxRows ? maxRows : 0;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (textLayout == nil) return layout;
    textHeight = [modifier heightForLineCount:textLayout.rowCount];
    layout.height = textHeight;
    layout.textLayout = textLayout;
    return layout;
    
    
}






+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                                    maxRows:(NSUInteger)maxRows
                                containSize:(CGSize)containSize{
    
    TextLayout *layout = [[TextLayout alloc] init];
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    if (attributedString.length == 0 || attributedString == nil) return layout ;
    

    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    if (attributedString.length) {
        [text appendAttributedString:attributedString];
    }
    
    text.font = attributedString.font;
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = attributedString.font;
    modifier.paddingTop = 8.1;
    modifier.paddingBottom = 8.1;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = UIEdgeInsetsMake(5, 5, 5, 5);
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows  = maxRows ? maxRows : 0;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (textLayout == nil) return layout;
    textHeight        = [modifier heightForLineCount:textLayout.rowCount];
    layout.height     = textHeight;
    layout.textLayout = textLayout;
    return layout;
    
    
}







+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                                      title:(NSMutableAttributedString *) title
                                       font:(UIFont *)font
                                    maxRows:(NSUInteger)maxRows
                                containSize:(CGSize)containSize{
    
    TextLayout *layout = [[TextLayout alloc] init];
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    if (attributedString.length == 0 || attributedString == nil) return layout ;
    
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] init];
    
    if (title.length) {
        [text appendAttributedString:title];
    }
    
    if (attributedString.length) {
        [text appendAttributedString:attributedString];
    }
    
    text.font = font;
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = font;
    modifier.paddingTop = 10.1;
    modifier.paddingBottom = 10.1;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = UIEdgeInsetsMake(5, 10, 5, 10);
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows = maxRows ? maxRows : 0;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:text];
    if (textLayout == nil) return layout;
    textHeight = [modifier heightForLineCount:textLayout.rowCount];
    layout.height = textHeight;
    layout.textLayout = textLayout;
    return layout;
    
    
}






+ (TextLayout *)layoutWithAttributedString:(NSMutableAttributedString *)attributedString
                            insertOfIndex:(NSUInteger)index
                                  context:(NSString *)context
                             contextColor:(UIColor *)contextColor
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                            textAlignment:(NSTextAlignment)textAlignment
                                     font:(UIFont *)font
                                  maxRows:(NSUInteger)maxRows
                              containSize:(CGSize)containSize{
    
    TextLayout *layout = [[TextLayout alloc] init];
    
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    NSString *string = [context stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (string.length == 0 && attributedString.length == 0 && title.length == 0) return layout;
     if (context.length == 0) return layout;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] init];
    
    if (title.length) {
        
        NSMutableAttributedString *titleText = [[NSMutableAttributedString alloc] initWithString:title];
        titleText.color = titleColor ? titleColor : [UIColor colorWithHexString:@"282828"];
        titleText.font  = font;
        [attr appendAttributedString:titleText];
    }
    
    if(context.length){
        
        NSMutableAttributedString *contextText = [[NSMutableAttributedString alloc] initWithString:context];
        contextText.color = contextColor ? contextColor : [UIColor colorWithHexString:@"282828"];
        contextText.font  = font;
        [attr appendAttributedString:contextText];
    }
    
    if (attributedString.length){
        [attr insertAttributedString:attributedString atIndex:index];
    }
    
    attr.alignment = textAlignment;
    attr.font = font;
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = font;
    modifier.paddingTop = 10.1;
    modifier.paddingBottom = 10.1;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = UIEdgeInsetsMake(5, 10, 5, 10);
    container.linePositionModifier = modifier;
    container.maximumNumberOfRows = maxRows ? maxRows : 0;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:attr];
    if (textLayout == nil) return layout;
    textHeight = [modifier heightForLineCount:textLayout.rowCount];
    layout.height = textHeight;
    layout.textLayout = textLayout;
    return layout;
    
}




+ (TextLayout *) layoutWithBordertext:(NSString *)context
                           textColor:(UIColor *) textColor
                         strokeColor:(UIColor *) strokeColor
                           fillColor:(UIColor *) fillColor
                           edgeInset:(UIEdgeInsets)edgeInset
                                font:(UIFont *)font
                        cornerRadius:(CGFloat) cornerRadius
                       textAlignment:(NSTextAlignment) textAlignment
                         containSize:(CGSize)containSize{
    
   TextLayout *layout = [[TextLayout alloc] init];
    
    CGFloat textHeight = 0;
    YYTextLayout *textLayout = nil;
    if (context.length == 0) return layout;
    
    NSMutableAttributedString *attr = [[NSMutableAttributedString alloc] initWithString:context];
    
    attr.alignment = textAlignment;
    attr.font = font;
    attr.color = textColor;
    attr.alignment = textAlignment;
    
    [attr setTextBinding:[YYTextBinding bindingWithDeleteConfirm:NO] range:attr.rangeOfAll];
    
    
    YYTextBorder *border = [YYTextBorder new];
    border.strokeWidth = 1.5;
    border.cornerRadius = cornerRadius;
    border.strokeColor = strokeColor;
    border.fillColor = fillColor;
    border.lineJoin = kCGLineJoinRound;
    border.insets = edgeInset;
    [attr setTextBackgroundBorder:border range:[attr.string rangeOfString:context]];
    
    
    YYTextLinePositionModifier *modifier = [YYTextLinePositionModifier new];
    modifier.font = font;
    modifier.paddingTop = 5;
    modifier.paddingBottom = 5;
    
    YYTextContainer *container = [YYTextContainer new];
    container.size = containSize;
    container.insets = UIEdgeInsetsMake(5, 5, 5, 5);
    container.linePositionModifier = modifier;
    
    textLayout = [YYTextLayout layoutWithContainer:container text:attr];
    if (textLayout == nil) return layout;
    textHeight = [modifier heightForLineCount:textLayout.rowCount];
    layout.height = textHeight;
    layout.textLayout = textLayout;
    layout.width = CGFloatPixelRound(textLayout.textBoundingRect.size.width);
    return layout;
}







@end
