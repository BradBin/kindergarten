//
//  YYTextLinePositionModifier.h
//  llyhbzfwxt
//
//  Created by Macbook Pro 15.4  on 2018/3/9.
//  Copyright © 2018年 jadl. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


#import "YYKit.h"



@interface EventType : NSObject

@property (nonatomic,strong) UIColor *eventColor;
@property (nonatomic,copy)  NSString *eventName;

@end


/**
 布局保存类
*/
@interface TextLayout : NSObject

@property (nonatomic,strong) YYTextLayout  *textLayout;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;

@end


/**
 文本 Line 位置修改
 将每行文本的高度和位置固定下来，不受中英文/Emoji字体的 ascent/descent 影响
 */
@interface YYTextLinePositionModifier : NSObject<YYTextLinePositionModifier>

@property (nonatomic, strong) UIFont *font; // 基准字体 (例如 Arial/PingFang SC)
@property (nonatomic, assign) CGFloat paddingTop; //文本顶部留白
@property (nonatomic, assign) CGFloat paddingBottom; //文本底部留白
@property (nonatomic, assign) CGFloat lineHeightMultiple; //行距倍数



- (CGFloat)heightForLineCount:(NSUInteger)lineCount;





+ (NSMutableAttributedString *)createAttributedStringWithString:(NSString *)string
                                                      textColor:(UIColor *)textColor
                                                    strokeColor:(UIColor *)strokeColor
                                                      fillColor:(UIColor *)fillColor
                                                      edgeInset:(UIEdgeInsets)edgeInset
                                                           font:(UIFont *)font
                                                   cornerRadius:(CGFloat)cornerRadius
                                                  textAlignment:(NSTextAlignment)textAlignment
                                                hightlightState:(BOOL)hightlight;






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
+ (NSMutableAttributedString *) createAttributedStringWithString:(NSString *) string
                                                            font:(UIFont *)font
                                                       textColor:(UIColor *) textColor
                                                       alignment:(NSTextAlignment)alignment
                                               attachmentContent:(id)content
                                                     contentMode:(UIViewContentMode)contentMode
                                                  attachmentSize:(CGSize)attachmentSize
                                           textVerticalAlignment:(YYTextVerticalAlignment)textVerticalAlignment;








+ (TextLayout *) layoutWithContext:(NSString *)context
                     contextColor:(UIColor *)contextColor
                            title:(NSString *)title
                     titleColor:(UIColor *)titleColor
                             font:(UIFont *)font
                             maxRows:(NSUInteger)maxRows
                      containSize:(CGSize)containSize;
















+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                                    maxRows:(NSUInteger)maxRows
                                 paddingTop:(CGFloat) paddingTop
                              paddingBottom:(CGFloat) paddingBottom
                                     insets:(UIEdgeInsets)insets
                                containSize:(CGSize)containSize;




+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                                    maxRows:(NSUInteger)maxRows
                                containSize:(CGSize)containSize;






+ (TextLayout *) layoutWithAttributedString:(NSMutableAttributedString *) attributedString
                             title:(NSMutableAttributedString *)title
                              font:(UIFont *)font
                           maxRows:(NSUInteger)maxRows
                       containSize:(CGSize)containSize;











+ (TextLayout *)layoutWithAttributedString:(NSMutableAttributedString *)attributedString
                            insertOfIndex:(NSUInteger)index
                                  context:(NSString *)context
                             contextColor:(UIColor *)contextColor
                                    title:(NSString *)title
                               titleColor:(UIColor *)titleColor
                            textAlignment:(NSTextAlignment)textAlignment
                                     font:(UIFont *)font
                                  maxRows:(NSUInteger)maxRows
                              containSize:(CGSize)containSize;

















+ (TextLayout *) layoutWithBordertext:(NSString *)context
                           textColor:(UIColor *) textColor
                         strokeColor:(UIColor *) strokeColor
                           fillColor:(UIColor *) fillColor
                           edgeInset:(UIEdgeInsets)edgeInset
                                font:(UIFont *)font
                        cornerRadius:(CGFloat) cornerRadius
                       textAlignment:(NSTextAlignment) textAlignment
                         containSize:(CGSize)containSize;

@end
