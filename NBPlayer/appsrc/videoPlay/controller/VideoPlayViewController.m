//
//  VideoPlayViewController.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "MediaControlView.h"


@interface VideoPlayViewController ()<UINavigationControllerDelegate>
@property(nonatomic, strong) IJKFFMoviePlayerController *player;
@property(nonatomic, strong) VideoPlayViewModel *viewModel;
@property(nonatomic, strong) MediaControlView *controlView;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.delegate = self;
    
    self.view.backgroundColor = [UIColor whiteColor];
    _viewModel = (VideoPlayViewModel*)self.vmodel;
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:self.viewModel.videourl withOptions:options];

    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    [self.view addSubview:self.player.view];
    
    [self.player.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.centerY);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.618);
    }];
    
    [self.player.view layoutIfNeeded];
    
    self.controlView = [[MediaControlView alloc]initWithFrame: self.player.view.bounds];
    self.controlView.delegatePlayer = self.player;
    [self.player.view addSubview:self.controlView];
    
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.player prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.player shutdown];
}


// Called when the navigation controller shows a new top view controller via a push, pop or setting of the view controller stack.
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"");
}
    
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
    NSLog(@"");
}





@end
