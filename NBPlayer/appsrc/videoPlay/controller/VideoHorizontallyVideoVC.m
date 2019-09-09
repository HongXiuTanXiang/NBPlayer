//
//  VideoHorizontallyVideoVC.m
//  NBPlayer
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "VideoHorizontallyVideoVC.h"
#import "RotationAnimator.h"
#import "MediaControlView.h"
#import "VideoHorizontallyViewModel.h"

@interface VideoHorizontallyVideoVC ()<MediaControlViewDelegate>


@property(nonatomic, strong) VideoHorizontallyViewModel *viewModel;
@property(nonatomic, strong) MediaControlView *controlView;
@property (nonatomic, strong) RotationAnimator* customAnimator;

@end

@implementation VideoHorizontallyVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _viewModel = (VideoHorizontallyViewModel*)self.vmodel;
    
    _customAnimator = [[RotationAnimator alloc]init];
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    if (!self.player) {
        IJKFFOptions *options = [IJKFFOptions optionsByDefault];
        self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:self.viewModel.videourl withOptions:options];
    }

    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.player.playbackRate = 1.0f;
    [self.view addSubview:self.player.view];
    
    [self.player.view makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(20);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    CGFloat statusBarH = [UIApplication sharedApplication].statusBarFrame.size.height;
    self.controlView = [[MediaControlView alloc]initWithFrame:CGRectMake(0, statusBarH, self.view.bounds.size.width, self.view.bounds.size.height - statusBarH)];
    self.controlView.delegatePlayer = self.player;
    self.controlView.delegate = self;
    [self.view addSubview:self.controlView];
    self.controlView.screenStatus = MediaControlScreenStatusFullScreen;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.player prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
}

-(void)playPauseButtonDidClick:(UIButton*)playBtn playStatus:(MediaControlPlayStatus)status{
    
}

-(void)fullScreenButtonDidClick:(UIButton*)fullBtn screenStatus: (MediaControlScreenStatus)status{
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.popBackBlock) {
        self.popBackBlock(self.player);
    }
}

-(void)backButtonDidClick:(UIButton*)backBtn{
    [self dismissViewControllerAnimated:true completion:nil];
    if (self.popBackBlock) {
        self.popBackBlock(self.player);
    }
}

-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleDefault;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskLandscapeRight;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationLandscapeRight;
}

@end
