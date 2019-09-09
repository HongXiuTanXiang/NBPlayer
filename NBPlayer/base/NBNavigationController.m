//
//  NBNavigationController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
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

#import "NBNavigationController.h"




@implementation NBNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}


- (BOOL)shouldAutorotate{
    
    return [[self.viewControllers lastObject] shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

-(BOOL)prefersStatusBarHidden{
    
    return [[self.viewControllers lastObject] prefersStatusBarHidden];
}


@end
