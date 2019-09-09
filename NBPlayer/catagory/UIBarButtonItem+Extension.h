//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

/**
 便捷创建一个UIBarButtonItem 方法

 @param title 文字
 @param color 文字颜色
 @param imageName 图片名，没有图片可传nil
 @param target 监听者
 @param action 监听方法
 @return  UIBarButtonItem
 */
+ (UIBarButtonItem *)itemWithTitle:(NSString *)title titleColor:(UIColor *)color image:(NSString *)imageName target:(id)target  action:(SEL)action;



@end
