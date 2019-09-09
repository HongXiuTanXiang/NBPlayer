//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "UIView+Extension.h"

@implementation UIView (Extension)
#pragma mark 设置view的X值
- (void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (CGFloat)x
{
    return self.frame.origin.x;
}

#pragma mark 设置view的y值
- (void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (CGFloat)y
{
    return self.frame.origin.y;
}

#pragma mark 设置view的宽度
- (void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (CGFloat)width
{
    return self.frame.size.width;
}

#pragma mark 设置view的高度
- (void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)setMaxX:(CGFloat)MaxX
{
    self.x = MaxX - self.width;
}

- (CGFloat)MaxX
{
    return CGRectGetMaxX(self.frame);
}


- (void)setMaxY:(CGFloat)MaxY
{
    self.y = MaxY - self.height;
}

- (CGFloat)MaxY
{
    return CGRectGetMaxY(self.frame);
}

#pragma mark 设置view的Origin
- (void) setOrigin:(CGPoint)point
{
    self.frame = CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height);
}
- (CGPoint) origin
{
    return self.frame.origin;
}

#pragma mark 设置view的Size
- (void)setSize:(CGSize)size
{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}
- (CGSize)size
{
    return self.frame.size;
}


#pragma mark 设置view的bottom
- (void)setBottom:(CGFloat)bottom
{
    self.frame = CGRectMake(self.x, bottom - self.height, self.width, self.height);
}
- (CGFloat)bottom
{
    return self.y + self.height;
}

#pragma mark 设置view的right
- (void)setRight:(CGFloat)right
{
    self.frame = CGRectMake(right - self.width, self.y, self.width, self.height);
}
- (CGFloat)right
{
    return self.x + self.width;
}

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


#pragma mark - 加载xib
//根据Xib文件创建View
+ (id)createWithXibName:(NSString *)xibName {
    if (!xibName) {
        id temp = [[[self class] alloc]init];
        return temp;
    }else{
        NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:xibName owner:nil options:nil];
        return [nibView objectAtIndex:0];
    }
}

//根据Xib文件创建View
+ (id)createWithXib {
    NSString *className = NSStringFromClass([self class]);
    return [self createWithXibName:className];
}

//根据同一个Xib文件获取不同View
+ (id)creatXibWithIndex:(NSInteger)index {
    NSString *className = NSStringFromClass([self class]);
    return [self createWithXibName:className index:index];
    
}

+ (id)createWithXibName:(NSString *)xibName index:(NSInteger)index {
    if (!xibName) {
        id temp = [[[self class]alloc]init];
        return temp;
    }else {
        NSArray *nibView = [[NSBundle mainBundle]loadNibNamed:xibName owner:nil options:nil];
        return [nibView objectAtIndex:index];
    }
}


@end
