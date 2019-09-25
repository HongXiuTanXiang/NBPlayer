//
//  UIViewController+ViewModel.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "UIViewController+ViewModel.h"
#import <objc/runtime.h>

@implementation UIViewController (ViewModel)

- (void)setVmodel:(NBViewModel *)vmodel{
    objc_setAssociatedObject(self, @selector(vmodel), vmodel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(NBViewModel *)vmodel{
   return objc_getAssociatedObject(self, @selector(vmodel));
}

-(void)setPopBackBlock:(PopBackBlock)popBackBlock{
    objc_setAssociatedObject(self, @selector(popBackBlock), popBackBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(PopBackBlock)popBackBlock{
   return objc_getAssociatedObject(self, @selector(popBackBlock));
}

-(void)setPopBackBlockOver:(BOOL)popBackBlockOver{
    objc_setAssociatedObject(self, @selector(popBackBlockOver), @(popBackBlockOver), OBJC_ASSOCIATION_ASSIGN);
}

-(BOOL)popBackBlockOver{
    return objc_getAssociatedObject(self, @selector(popBackBlockOver));
}

- (instancetype)initwithViewModel: (NBViewModel*)vmodel{
    UIViewController *somevc = [[[self class] alloc]initWithNibName:nil bundle:nil];
    if (somevc) {
        somevc.vmodel = vmodel;
    }
    return somevc;
}



@end
