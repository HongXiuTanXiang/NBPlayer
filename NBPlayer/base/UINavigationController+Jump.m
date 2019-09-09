//
//  UINavigationController+Jump.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//
/*
 1: UINavigationController是UINavigationBar 的代理,并实现了其代理方法
 ,这些代理方法的调用是在UINavigationBar自己的方法中调用的,回调给UINavigationController
 2: UINavigationControllerDelegate,设计意图是给上层控制器用,回调给控制器层,
 让控制器层能监听到UINavigationController的viewControllers Stack管理状态
 
 所以这四个代理方法是一定会被调用的,可以hook他们
 
 - (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPushItem:(UINavigationItem *)item; // called to push. return NO not to.
 - (void)navigationBar:(UINavigationBar *)navigationBar didPushItem:(UINavigationItem *)item;    // called at end of animation of push or immediately if not animated
 - (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item;  // same as push methods
 - (void)navigationBar:(UINavigationBar *)navigationBar didPopItem:(UINavigationItem *)item;
 
 */

#import "UINavigationController+Jump.h"
#import <objc/runtime.h>

@implementation UINavigationController (Jump)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class cls = NSClassFromString(@"UINavigationController");
        SEL sorce_sel = @selector(pushViewController:animated:);
        SEL exchange_sel = @selector(kk_pushViewController:animated:);
        Method method1 = class_getInstanceMethod(cls, sorce_sel);
        Method method2 = class_getInstanceMethod(cls, exchange_sel);
        method_exchangeImplementations(method1, method2);
        
        
        [self hook];
    });
}

- (void)kk_pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    
    self.tabBarController.tabBar.hidden = true;
    [self kk_pushViewController:viewController animated:animated];
}


void exchangeMethod(Class aClass,Class bClass, SEL oldSEL, SEL newSEL) {
    Method oldMethod = class_getInstanceMethod(aClass, oldSEL);
    assert(oldMethod);
    Method newMethod = class_getInstanceMethod(bClass, newSEL);
    assert(newMethod);
    method_exchangeImplementations(oldMethod, newMethod);
}

+ (void)hook {
    exchangeMethod([self class],
                   [self class],
                   @selector(navigationBar: shouldPopItem:),
                   @selector(kk_navigationBar:shouldPopItem:));
}


- (void)kk_navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem *)item{
    
    if (self.topViewController.popBackBlock) {
        self.topViewController.popBackBlock(nil);
    }
    self.tabBarController.tabBar.hidden = false;
    [self kk_navigationBar:navigationBar shouldPopItem:item];
}




@end
