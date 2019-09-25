//
//  NBBaseViewController.m
//  NBPlayer
//
//  Created by Mac on 2019/9/25.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBBaseViewController.h"

@interface NBBaseViewController ()<UINavigationControllerDelegate>

@end

@implementation NBBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
}

// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    id <UIViewControllerTransitionCoordinator>tc = navigationController.topViewController.transitionCoordinator;
    [tc notifyWhenInteractionChangesUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
        // NO返回成功,YES 未返回
        if ([context isCancelled] == NO) {
            if (self.popBackBlock && self.popBackBlockOver == false) {
                self.popBackBlock(nil);
                self.popBackBlockOver = true;
            }
            self.tabBarController.tabBar.hidden = false;
        } else {
            self.tabBarController.tabBar.hidden = true;
        }
        
    }];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"");
}



@end
