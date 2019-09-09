//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
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
