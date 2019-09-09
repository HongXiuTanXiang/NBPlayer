//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "UIButton+Extension.h"
#import "UIImage+ImageWithColor.h"
#import <objc/runtime.h>
#import "UIFont+QFFont.h"
#import "NSString+isNullString.h"

static const NSString *KEY_HIT_TEST_EDGE_INSETS = @"HitTestEdgeInsets";

@implementation UIButton (Extension)
@dynamic hitTestEdgeInsets;


+ (instancetype) buttonWithTitle:(NSString *)title fontSize: (CGFloat) fontSize bgImageColor: (UIColor*)color
                      titleColor: (UIColor*) titleColor
                          target:(id)target action:(SEL)action{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:fontSize];
    btn.layer.cornerRadius = 4;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setClipsToBounds:YES];
    btn.backgroundColor = [UIColor redColor];
    
    return btn;
}

+ (instancetype) buttonWithTitle:(NSString *)title
                        fontName: (NSString*)fontName
                        fontSize: (CGFloat) fontSize
                    bgImageColor: (UIColor*)color
                      titleColor: (UIColor*) titleColor
                          target:(id)target
                          action:(SEL)action{
    UIButton *btn = [[UIButton alloc]init];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:color] forState:UIControlStateNormal];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont fontWithName:fontName size:fontSize];
    btn.layer.cornerRadius = 4;
    [btn setTitleColor:titleColor forState:UIControlStateNormal];
    [btn setClipsToBounds:YES];
    btn.backgroundColor = [UIColor redColor];
    return btn;
}

-(void)setHitTestEdgeInsets:(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = [NSValue value:&hitTestEdgeInsets withObjCType:@encode(UIEdgeInsets)];
    objc_setAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIEdgeInsets)hitTestEdgeInsets {
    NSValue *value = objc_getAssociatedObject(self, &KEY_HIT_TEST_EDGE_INSETS);
    if(value) {
        UIEdgeInsets edgeInsets; [value getValue:&edgeInsets]; return edgeInsets;
    }else {
        return UIEdgeInsetsZero;
    }
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    if(UIEdgeInsetsEqualToEdgeInsets(self.hitTestEdgeInsets, UIEdgeInsetsZero) ||       !self.enabled || self.hidden) {
        return [super pointInside:point withEvent:event];
    }
    
    CGRect relativeFrame = self.bounds;
    CGRect hitFrame = UIEdgeInsetsInsetRect(relativeFrame, self.hitTestEdgeInsets);
    
    return CGRectContainsPoint(hitFrame, point);
}


@end


@implementation UILabel (KKExtension)

+(instancetype)labelWithText: (NSString* _Nullable)text
                    fontName: (NSString* _Nullable)fontName
                    fontSize: (NSInteger)fontSize
                   fontColor: (UIColor* _Nullable) fontColor
               textAlignment: (NSTextAlignment) alignment {
    
    UILabel * lab = [[UILabel alloc]init];
    lab.text = [NSString isNullString:text] ? @"": text;
    NSString *fontN = [NSString isNullString:fontName] ? kFontRegular : fontName;
    lab.font = [UIFont fontWithName:fontN size:fontSize];
    UIColor *color = nil;
    if (fontColor) {
        color = fontColor;
    } else {
        color = [UIColor blackColor];
    }
    lab.textColor = color;
    lab.textAlignment = alignment;
    lab.numberOfLines = 1;
    return lab;
}



@end
