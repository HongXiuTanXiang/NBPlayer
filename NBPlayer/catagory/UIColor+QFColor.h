//
//  UIColor+QFColor.h
//  QFBAPP
//
//  Created by 无常先生 on 2018/5/22.
//  Copyright © 2018年 YIXun. All rights reserved.
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
