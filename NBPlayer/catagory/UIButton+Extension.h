//
//  UIButton+Extension.h
//  QFBAPP
//
//  Created by 无常先生 on 2018/5/30.
//  Copyright © 2018年 YIXun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Extension)
// 增加可点击区域
@property (nonatomic, assign) UIEdgeInsets hitTestEdgeInsets;



+ (instancetype) buttonWithTitle:(NSString *)title
                        fontName: (NSString*)fontName
                        fontSize: (CGFloat) fontSize
                    bgImageColor: (UIColor*)color
                      titleColor: (UIColor*) titleColor
                          target:(id)target
                          action:(SEL)action;

@end

@interface UILabel (KKExtension)

+(instancetype)labelWithText: (NSString* _Nullable)text
                    fontName: (NSString* _Nullable)fontName
                    fontSize: (NSInteger)fontSize
                   fontColor: (UIColor* _Nullable) fontColor
               textAlignment: (NSTextAlignment) alignment;

@end
