//
//  VideoPlayViewController.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "VideoPlayViewController.h"

#import "MediaControlView.h"
#import "RotationAnimator.h"
#import "VideoHorizontallyVideoVC.h"


@interface VideoPlayViewController ()<MediaControlViewDelegate>

@property(nonatomic, strong) VideoPlayViewModel *viewModel;
@property(nonatomic, strong) MediaControlView *controlView;
@property (nonatomic, strong) RotationAnimator* customAnimator;

@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor nbWhite];
    _viewModel = (VideoPlayViewModel*)self.vmodel;
    
    _customAnimator = [[RotationAnimator alloc]init];
    
    [IJKFFMoviePlayerController setLogReport:YES];
    [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
    
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    self.player = [[IJKFFMoviePlayerController alloc]initWithContentURL:self.viewModel.videourl withOptions:options];

    self.player.scalingMode = IJKMPMovieScalingModeAspectFit;
    self.player.shouldAutoplay = YES;
    self.player.playbackRate = 1.0f;
    [self.view addSubview:self.player.view];
    
    [self.player.view makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view.mas_centerX);
        make.centerY.mas_equalTo(self.view.centerY);
        make.width.mas_equalTo(self.view.bounds.size.width);
        make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.618);
    }];
    
    [self.player.view layoutIfNeeded];
    
    self.controlView = [[MediaControlView alloc]initWithFrame: CGRectMake(0,  (SCREEN_HEIGHT - SCREEN_WIDTH * 0.618)/2, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
    self.controlView.delegatePlayer = self.player;
    self.controlView.delegate = self;
    [self.view addSubview:self.controlView];
    
    @weakify(self)
    self.popBackBlock = ^(id _Nullable arg1){
        @strongify(self);
        [self.player shutdown];
    };
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.player prepareToPlay];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self.player shutdown];
}


-(void)playPauseButtonDidClick:(UIButton*)playBtn playStatus:(MediaControlPlayStatus)status{
    
}

-(void)fullScreenButtonDidClick:(UIButton*)fullBtn screenStatus: (MediaControlScreenStatus)status{
    [self.player.view  removeFromSuperview];
    [self.controlView removeFromSuperview];
    
    VideoHorizontallyVideoVC *fullvc = [[VideoHorizontallyVideoVC alloc]init];
    fullvc.player = self.player;
    @weakify(self)
    fullvc.popBackBlock = ^(IJKFFMoviePlayerController * arg1) {
        @strongify(self)
        self.player = arg1;
        
        [self.view addSubview:self.player.view];
        [self.player.view makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view.mas_centerX);
            make.centerY.mas_equalTo(self.view.centerY);
            make.width.mas_equalTo(self.view.bounds.size.width);
            make.height.mas_equalTo(self.view.mas_width).multipliedBy(0.618);
        }];
        
        self.controlView = [[MediaControlView alloc]initWithFrame: CGRectMake(0,  (SCREEN_HEIGHT - SCREEN_WIDTH * 0.618)/2, SCREEN_WIDTH, SCREEN_WIDTH * 0.618)];
        self.controlView.delegatePlayer = self.player;
        self.controlView.delegate = self;
        [self.view addSubview:self.controlView];
        if (fullvc.controlView.playStatus == MediaControlPlayStatusComplete) {
            [self.controlView videoComplete];
        }
    };
    
    [self presentViewController:fullvc animated:true completion:nil];
}

-(void)backButtonDidClick:(UIButton*)backBtn{
    [self.navigationController popViewControllerAnimated:true];
}

-(BOOL)prefersStatusBarHidden{
    
    return NO;
}

-(BOOL)shouldAutorotate{
    
    return NO;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    
    return UIInterfaceOrientationMaskPortrait;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    
    return UIInterfaceOrientationPortrait;
}




@end
