//
//  MediaControlView.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

/*
 在iOS中,anchorPoint,左上角为(0,0),右下角为(1,1),默认值为(0.5,0.5)
 position.x = frame.origin.x + anchorPoint.x * bounds.size.width
 position.y = frmae.origin.y + anchorPoint.y * bounds.size.height
 */

#import "MediaControlView.h"
#import <pop/POP.h>


#define BAR_HEIGHT 38
#define BACK_HEIGHT 28

@interface MediaControlView()

@property(nonatomic, strong) UIButton *backBtn;
@property(nonatomic, strong) UIButton *playBtn;
@property(nonatomic, strong) UIButton *fullScreenBtn;
@property(nonatomic, strong) UIButton *chageRateBtn;
@property(nonatomic, strong) UISlider *progressSlider;
@property(nonatomic, strong) UILabel *timeStartLab;
@property(nonatomic, strong) UILabel *timeEndLab;
@property(nonatomic, strong) UILabel *videoTitleLab;

@property(nonatomic, strong) UIView *topBar;
@property(nonatomic, strong) UIView *bottomBar;
@property(nonatomic, strong) UIButton *hubView;
@property(nonatomic, assign) BOOL barHide;
@property(nonatomic, assign) BOOL isMediaSliderBeingDragged;
@property(nonatomic, strong) UIProgressView *cacheProgress;

@property(nonatomic, assign) MediaControlPlayStatus playStatus;
@property(nonatomic, assign) MediaControlScreenStatus screenStatus;


@end

@implementation MediaControlView

-(MediaControlPlayStatus)getMediaPlayStatus{
    return self.playStatus;
}

-(MediaControlScreenStatus)getMediaSreenStatus{
    return self.screenStatus;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        _barHide = true;
        _screenStatus = MediaControlScreenStatusNormal;
        _playStatus = MediaControlPlayStatusPlay;
        [self addMediaObserver];
    }
    return self;
}

-(void)dealloc{
    [self removeMediaObserver];
}

-(void)setupUI
{
    
    _topBar = [[UIView alloc]init];
    _topBar.backgroundColor = [UIColor colorWithHexString:@"#A9A9A9    " alpha:0.6];
    
    _bottomBar = [[UIView alloc]init];
    _bottomBar.backgroundColor = [UIColor colorWithHexString:@"#A9A9A9    " alpha:0.6];
    
    _hubView = [UIButton buttonWithTitle:@"" fontName:kFontRegular fontSize:0 bgImageColor:[UIColor clearColor] titleColor:[UIColor clearColor] target:self action:@selector(hubViewDidClick:)];
    _hubView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.topBar];
    [self addSubview:self.bottomBar];
    [self addSubview:self.hubView];
    
    
    self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, BAR_HEIGHT);
    self.topBar.alpha = 0;
    
    self.bottomBar.frame = CGRectMake(0, self.bounds.size.height - BAR_HEIGHT, self.bounds.size.width, BAR_HEIGHT);
    self.bottomBar.alpha = 0;
    
    self.hubView.frame = CGRectMake(0, BAR_HEIGHT, self.bounds.size.width, self.bounds.size.height - 2 * BAR_HEIGHT);

    // 同时设置这两个位置,才能保证视图位置的正确
    self.topBar.layer.anchorPoint = CGPointMake(0.5, 0);
    self.topBar.layer.position = CGPointMake(self.bounds.size.width/2, 0);
    
    self.bottomBar.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.bottomBar.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2.0, BACK_HEIGHT, BACK_HEIGHT)];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.topBar addSubview:self.backBtn];
    [self.backBtn addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.playBtn = [[UIButton alloc]init];
    self.playBtn.frame = CGRectMake(8, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2.0, BACK_HEIGHT, BACK_HEIGHT);
    [self.playBtn setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
    [self.playBtn setImage:[UIImage imageNamed:@"play"] forState:UIControlStateSelected];
    [self.playBtn addTarget:self action:@selector(playButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.playBtn];
    
    self.fullScreenBtn = [[UIButton alloc]init];
    self.fullScreenBtn.frame = CGRectMake(self.bounds.size.width - 8 - BACK_HEIGHT, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2.0, BACK_HEIGHT, BACK_HEIGHT);
    [self.fullScreenBtn setImage:[UIImage imageNamed:@"Fullscreen"] forState:UIControlStateNormal];
    [self.fullScreenBtn addTarget:self action:@selector(fullScreenBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomBar addSubview:self.fullScreenBtn];
    
    self.timeStartLab = [UILabel labelWithText:@"--:--" fontName:kFontRegular fontSize:14 fontColor:[UIColor nbOringe] textAlignment:NSTextAlignmentLeft];
    self.timeStartLab.frame = CGRectMake(8+BACK_HEIGHT+3, (CGFloat)(BAR_HEIGHT-19)/2.0, 60, 19);
    self.timeStartLab.numberOfLines = 1;
    [self.bottomBar addSubview:self.timeStartLab];
    
    self.timeEndLab = [UILabel labelWithText:@"--:--" fontName:kFontRegular fontSize:14 fontColor:[UIColor nbOringe] textAlignment:NSTextAlignmentRight];
    self.timeEndLab.frame = CGRectMake(self.bounds.size.width - 8 - BACK_HEIGHT - 3 - 60, (BAR_HEIGHT-19)/2.0, 60, 19);
    self.timeEndLab.numberOfLines = 1;
    [self.bottomBar addSubview:self.timeEndLab];
    
    self.progressSlider = [[UISlider alloc]init];
    
    [self.progressSlider addTarget:self action:@selector(sliderUIControlEventTouchDown) forControlEvents:UIControlEventTouchDown];
    
    [self.progressSlider addTarget:self action:@selector(sliderUIControlEventTouchCancel) forControlEvents:UIControlEventTouchCancel];
    
    [self.progressSlider addTarget:self action:@selector(sliderUIControlEventTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    
    [self.progressSlider addTarget:self action:@selector(sliderUIControlEventTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [self.progressSlider addTarget:self action:@selector(sliderUIControlEventValueChanged) forControlEvents:UIControlEventValueChanged];
    
    self.progressSlider.minimumTrackTintColor = [UIColor nbOringe];
    self.progressSlider.maximumTrackTintColor = [UIColor colorWithHexString:@"#F5F5F5" alpha:0.3];
    CGFloat proW = self.bounds.size.width - 2* (8+BACK_HEIGHT+3 + 60);
    self.progressSlider.frame = CGRectMake(8+BACK_HEIGHT+3 + 60, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2,  proW, BACK_HEIGHT);
    
    self.cacheProgress = [[UIProgressView alloc]init];
    self.cacheProgress.progressTintColor = [UIColor colorWithHexString:@"#90EE90"];
    self.cacheProgress.trackTintColor = [UIColor clearColor];
    self.cacheProgress.backgroundColor = [UIColor clearColor];
    self.cacheProgress.frame = CGRectMake(8 + BACK_HEIGHT + 3 + 60 +2, (CGFloat)(BAR_HEIGHT - 2)/2,  proW, 2);
    self.progressSlider.backgroundColor = [UIColor clearColor];
    [self.bottomBar addSubview:self.cacheProgress];
    [self.bottomBar addSubview:self.progressSlider];
    
    
    self.progressSlider.thumbTintColor = [UIColor nbOringe];
    // 通常状态下
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateNormal];
    
    // 滑动状态下
    [self.progressSlider setThumbImage:[UIImage imageNamed:@"iconfont-yuandian"] forState:UIControlStateHighlighted];
    
    self.videoTitleLab = [UILabel labelWithText:@"标题" fontName:kFontRegular fontSize:14 fontColor:[UIColor nbOringe] textAlignment:NSTextAlignmentLeft];
    self.videoTitleLab.frame = CGRectMake(8 + BACK_HEIGHT + 3, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2.0, BACK_HEIGHT, BACK_HEIGHT);
    [self.topBar addSubview:self.videoTitleLab];
    
    self.chageRateBtn = [[UIButton alloc]init];
    self.chageRateBtn.frame = CGRectMake(self.bounds.size.width - 70, (BAR_HEIGHT - BACK_HEIGHT)/2.0, 60, BACK_HEIGHT);
    self.chageRateBtn.backgroundColor = [UIColor clearColor];
    [self.chageRateBtn setTitle:@"1.0" forState:UIControlStateNormal];
    [self.chageRateBtn setTitleColor:[UIColor nbOringe] forState:UIControlStateNormal];
    [self.chageRateBtn addTarget:self action:@selector(changeRateButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.topBar addSubview:self.chageRateBtn];
    
}
float rate = 1.0f;
-(void)changeRateButtonClick:(UIButton*)btn{
    rate = (float)[self.delegatePlayer playbackRate];
    if (rate == 0.8f) {
        rate = 1.0;
    } else if (rate == 1.0f) {
        rate = 1.25f;
    } else if (rate == 1.25f) {
        rate = 1.5;
    } else if (rate == 1.5f) {
        rate = 2.0;
    } else if (rate == 2.0f) {
        rate = 0.8;
    }
    
    [self.delegatePlayer setPlaybackRate:rate];
    [self.chageRateBtn setTitle:[NSString stringWithFormat:@"%.1f",rate] forState:UIControlStateNormal];
}

void ijk_io_callback(const char *url,
                     int64_t read_bytes, int64_t total_size,
                     int64_t elpased_time, int64_t total_duration){
    NSLog(@"%lld",elpased_time);
}

-(void)sliderUIControlEventTouchDown{
    [self beginDragMediaSlider];
}

-(void)sliderUIControlEventTouchCancel{
    [self endDragMediaSlider];
}

-(void)sliderUIControlEventTouchUpOutside{
    [self endDragMediaSlider];
}

// MARK: ------快进----
-(void)sliderUIControlEventTouchUpInside{
    self.delegatePlayer.currentPlaybackTime = self.progressSlider.value;
    [self endDragMediaSlider];
}

-(void)sliderUIControlEventValueChanged{
    [self continueDragMediaSlider];
}



-(void)fullScreenBtnClick:(UIButton*)btn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(fullScreenButtonDidClick:screenStatus:)]) {
        if (self.screenStatus == MediaControlScreenStatusNormal) {
            self.screenStatus = MediaControlScreenStatusFullScreen;
        } else {
            self.screenStatus = MediaControlScreenStatusFullScreen;
        }
        [self.delegate fullScreenButtonDidClick:btn screenStatus:self.screenStatus];
    }
}

-(void)playButtonClick:(UIButton*)btn{
    btn.selected = !btn.selected;
    if (btn.selected) {
        
        self.playStatus = MediaControlPlayStatusPause;
        if ([self.delegatePlayer isPlaying]) {
            [self.delegatePlayer pause];
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(playPauseButtonDidClick:playStatus:)]) {
            [self.delegate playPauseButtonDidClick:btn playStatus:MediaControlPlayStatusPause];
        }
    } else {
        if (self.playStatus == MediaControlPlayStatusComplete) {
            self.progressSlider.value = 0;
        }
        self.playStatus = MediaControlPlayStatusPlay;
        [self.delegatePlayer play];
        [self refreshMediaControl];
        if (self.delegate && [self.delegate respondsToSelector:@selector(playPauseButtonDidClick:playStatus:)]) {
            [self.delegate playPauseButtonDidClick:btn playStatus:MediaControlPlayStatusPlay];
        }
    }
}

-(void)backButtonClick:(UIButton*)backBtn{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonDidClick:)]) {
        [self.delegate backButtonDidClick:backBtn];
    }
}

-(void)hubViewDidClick:(UIButton*)btn{
    [self topBarAndBottomBarAnimation];
}

-(void)topBarAndBottomBarAnimation{
    if (self.barHide) {
        
        [UIView animateWithDuration:0.25 animations:^{
            self.topBar.alpha = 1;
            self.bottomBar.alpha = 1;
        }];
        
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale.y";
        anima.fromValue = @(0);
        anima.toValue = @(1);
        anima.duration = 0.25;
        anima.removedOnCompletion = false;
        anima.fillMode = kCAFillModeForwards;
        anima.beginTime = CACurrentMediaTime();
        anima.repeatCount = 0;
        [self.topBar.layer addAnimation:anima forKey:@"topscaley"];
        
        
        CABasicAnimation *anima1 = [CABasicAnimation animation];
        anima1.keyPath = @"transform.scale.y";
        anima1.fromValue = @(0);
        anima1.toValue = @(1);
        anima1.duration = 0.25;
        anima1.removedOnCompletion = false;
        anima1.fillMode = kCAFillModeForwards;
        anima1.beginTime = CACurrentMediaTime();
        anima1.repeatCount = 0;
        [self.bottomBar.layer addAnimation:anima1 forKey:@"bottomscaley"];
        
        self.barHide = false;
        [self refreshMediaControl];
    } else {
        
        CABasicAnimation *anima = [CABasicAnimation animation];
        anima.keyPath = @"transform.scale.y";
        anima.fromValue = @(1);
        anima.toValue = @(0);
        anima.duration = 0.25;
        anima.removedOnCompletion = false;
        anima.fillMode = kCAFillModeForwards;
        anima.beginTime = CACurrentMediaTime();
        anima.repeatCount = 0;
        [self.topBar.layer addAnimation:anima forKey:@"topscaley"];
        
        CABasicAnimation *anima1 = [CABasicAnimation animation];
        anima1.keyPath = @"transform.scale.y";
        anima1.fromValue = @(1);
        anima1.toValue = @(0);
        anima1.duration = 0.25;
        anima1.removedOnCompletion = false;
        anima1.fillMode = kCAFillModeForwards;
        anima1.beginTime = CACurrentMediaTime();
        anima1.repeatCount = 0;
        [self.bottomBar.layer addAnimation:anima1 forKey:@"bottomscaley"];
        
        self.barHide = true;
    }

}


- (void)beginDragMediaSlider
{
    _isMediaSliderBeingDragged = YES;
}

- (void)endDragMediaSlider
{
    _isMediaSliderBeingDragged = NO;
}

- (void)continueDragMediaSlider
{
    [self refreshMediaControl];
}

-(void)setDelegatePlayer:(id<IJKMediaPlayback>)delegatePlayer{
    _delegatePlayer = delegatePlayer;
}

- (void)refreshMediaControl
{
    // duration
    NSInteger intDuration = ceil(self.delegatePlayer.duration);

    self.timeEndLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intDuration / 60), (int)(intDuration % 60)];
    
    self.cacheProgress.progress = (float)self.delegatePlayer.playableDuration /(float)self.delegatePlayer.duration;
    
    if (!self.isMediaSliderBeingDragged) {
        if (self.playStatus == MediaControlPlayStatusComplete) {
            self.progressSlider.value = 1.0;
            return;
        }
        self.progressSlider.value = self.delegatePlayer.currentPlaybackTime/self.delegatePlayer.duration;
    }
    
    
    NSInteger intPosition = ceilf(self.delegatePlayer.currentPlaybackTime);
    self.timeStartLab.text = [NSString stringWithFormat:@"%02d:%02d", (int)(intPosition / 60), (int)(intPosition % 60)];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshMediaControl) object:nil];
    
    if (!self.barHide && self.playStatus != MediaControlPlayStatusComplete) {
        [self performSelector:@selector(refreshMediaControl) withObject:nil afterDelay:0.1];
    }
}

-(void)addMediaObserver{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(videoComplete) name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)removeMediaObserver{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:IJKMPMoviePlayerPlaybackDidFinishNotification object:nil];
}

-(void)videoComplete{
    self.playStatus = MediaControlPlayStatusComplete;
    self.progressSlider.value = 1.0;
    self.playBtn.selected = !self.playBtn.selected;
}


@end
