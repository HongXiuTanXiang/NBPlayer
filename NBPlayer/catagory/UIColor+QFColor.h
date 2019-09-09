//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (QFColor)

+(UIColor *) nbOringe;

+(UIColor *) nbWhite;

+(UIColor *) nbBlack;

+(UIColor *) nbGray;

+(UIColor*) nbDarkGray;

/** 随机色 用于调试UI使用 */
+ (UIColor *) QFRandom;

+ (UIColor *) colorWithHexString:(NSString *)color;

+ (UIColor *) colorWithHexString:(NSString *)hexSting alpha:(CGFloat)alpha;
@end
