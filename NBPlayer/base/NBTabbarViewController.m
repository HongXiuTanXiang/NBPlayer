//
//  NBTabbarViewController.m
//  NBPlayer
//
//  Created by Mac on 2019/7/19.
//  Copyright © 2019年 Mac. All rights reserved.
//

#import "NBTabbarViewController.h"
#import "NBNavigationController.h"
#import "NBHomeViewController.h"
#import "NBCameraViewController.h"
#import "NBMyViewController.h"

@interface NBTabbarViewController ()

@end

@implementation NBTabbarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
    
    NBHomeViewModel *homevm = [NBHomeViewModel new];
    NBHomeViewController *homevc = [[NBHomeViewController alloc]initwithViewModel:homevm];
    [self addChildVc:homevc title:@"首页" image:@"icon_tabBar_home" selectedImage:@"icon_tabBar_home_select"];
    
    NBCameraViewModel *cameravm = [[NBCameraViewModel alloc]init];
    NBCameraViewController *cameravc = [[NBCameraViewController alloc]initwithViewModel:cameravm];
    [self addChildVc:cameravc title:@"拍摄" image:@"icon_tabBar_tourist" selectedImage:@"icon_tabBar_tourist_select"];

    NBMyViewModel *myvm = [[NBMyViewModel alloc]init];
    NBMyViewController *myvc = [[NBMyViewController alloc]initwithViewModel:myvm];
    [self addChildVc:myvc title:@"我的" image:@"icon_tabBar_my" selectedImage:@"icon_tabBar_my_select"];
}

- (void)addChildVc:(UIViewController *)childVc title:(NSString *)title image:(NSString *)image selectedImage:(NSString *)selectedImage {
    childVc.title = title;
    childVc.tabBarItem.image = [[UIImage imageNamed:image] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    childVc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    // 设置文字的样式
    NSMutableDictionary *textAttrs = [NSMutableDictionary dictionary];
    textAttrs[NSForegroundColorAttributeName] = [UIColor colorWithHexString:@"000000"];
    textAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [childVc.tabBarItem setTitleTextAttributes:textAttrs forState:UIControlStateNormal];
    
    NSMutableDictionary *selectTextAttrs = [NSMutableDictionary dictionary];
    selectTextAttrs[NSForegroundColorAttributeName] =  [UIColor orangeColor];
    selectTextAttrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    [childVc.tabBarItem setTitleTextAttributes:selectTextAttrs forState:UIControlStateSelected];
    
    // 包装导航控制器
    NBNavigationController *nav = [[NBNavigationController alloc]initWithRootViewController:childVc];
    
    [self addChildViewController:nav];
}
@end
