//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"
#import "UIButton+Extension.h"
#import "UIView+Extension.h"
@implementation UIBarButtonItem (Extension)
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)color image:(NSString *)imageName target:(id)target action:(SEL)action {
    
    UIButton *item = [UIButton buttonWithType:UIButtonTypeCustom];
    if (imageName.length) {
        [item setImage:[[UIImage imageNamed:imageName]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:normal];
        item.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    if (title.length) {
        [item setTitle:title forState:normal];
    }
    [item setTitleColor:color forState:normal];
    item.titleLabel.font = [UIFont systemFontOfSize:16];
    [item addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [item sizeToFit];
    item.height = 35;
    return [[UIBarButtonItem alloc]initWithCustomView:item];
}

@end
