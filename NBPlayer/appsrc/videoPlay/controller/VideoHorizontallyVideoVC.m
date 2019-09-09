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
#import "ScanSuccessJumpVC.h"

@interface VideoHorizontallyVideoVC ()<MediaControlViewDelegate>


@property(nonatomic, strong) VideoHorizontallyViewModel *viewModel;
@property(nonatomic, strong) MediaControlView *controlView;
@property (nonatomic, strong) RotationAnimator* customAnimator;

@end

@implementation VideoHorizontallyVideoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
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
    
    [self addNotifi];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.controlView = [[MediaControlView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
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

-(void)dealloc{
    [self removeMovieNotificationObservers];
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
    
    if (self.shouldClosed) {
        [self.player shutdown];
    }
}

-(BOOL)prefersStatusBarHidden{
    
    return true;
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

-(void)addNotifi{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
}

- (void)loadStateDidChange:(NSNotification*)notification
{
    //    MPMovieLoadStateUnknown        = 0,
    //    MPMovieLoadStatePlayable       = 1 << 0,
    //    MPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    //    MPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
    
    IJKMPMovieLoadState loadState = _player.loadState;
    
    if ((loadState & IJKMPMovieLoadStateUnknown) == 0) {
        
    }
}

-(void)dealVideoError{
    [self showAlertTitle:@"温馨提示" content:@"视频地址异常,播放失败,是否使用浏览器打开?" cancle:@"" sure:@"" cancleAction:^{
        [self.navigationController popViewControllerAnimated:true];
    } sureAction:^{
        BOOL canopen = [[UIApplication sharedApplication]canOpenURL:self.viewModel.videourl];
        if (canopen) {
            [[UIApplication sharedApplication]openURL:self.viewModel.videourl options:@{} completionHandler:nil];
        }
    }];
}

- (void)moviePlayBackDidFinish:(NSNotification*)notification
{
    //    MPMovieFinishReasonPlaybackEnded,
    //    MPMovieFinishReasonPlaybackError,
    //    MPMovieFinishReasonUserExited
    int reason = [[[notification userInfo] valueForKey:IJKMPMoviePlayerPlaybackDidFinishReasonUserInfoKey] intValue];
    
    switch (reason)
    {
        case IJKMPMovieFinishReasonPlaybackEnded:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonPlaybackEnded: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonUserExited:
            NSLog(@"playbackStateDidChange: IJKMPMovieFinishReasonUserExited: %d\n", reason);
            break;
            
        case IJKMPMovieFinishReasonPlaybackError:
            [self dealVideoError];
            break;
        default:
            NSLog(@"playbackPlayBackDidFinish: ???: %d\n", reason);
            break;
    }
}

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerLoadStateDidChangeNotification object:_player];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:_player];

}

@end
