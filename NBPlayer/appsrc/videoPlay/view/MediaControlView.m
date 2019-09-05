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

@end

@implementation MediaControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
        _barHide = true;
    }
    return self;
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
    
    self.hubView.frame = CGRectMake(0, BAR_HEIGHT, self.bounds.size.width, self.bounds.size.height - BAR_HEIGHT);

    // 同时设置这两个位置,才能保证视图位置的正确
    self.topBar.layer.anchorPoint = CGPointMake(0.5, 0);
    self.topBar.layer.position = CGPointMake(self.bounds.size.width/2, 0);
    
    self.bottomBar.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.bottomBar.layer.position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height);
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(8, (CGFloat)(BAR_HEIGHT - BACK_HEIGHT)/2.0, BACK_HEIGHT, BACK_HEIGHT)];
    [self.backBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [self.topBar addSubview:self.backBtn];
    
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


@end
