//
//  MediaControlView.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "MediaControlView.h"
#import <pop/POP.h>

#define BAR_HEIGHT 38

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
    
    self.topBar.layer.anchorPoint = CGPointMake(0.5, 1.0);
    self.bottomBar.layer.anchorPoint = CGPointMake(0, 0);
    
    self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
    self.bottomBar.frame = CGRectMake(0, self.bounds.size.height - BAR_HEIGHT, self.bounds.size.width, 0);
    self.hubView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
    
}

-(void)hubViewDidClick:(UIButton*)btn{
    [self topBarAndBottomBarAnimation];
}

-(void)topBarAndBottomBarAnimation{
    if (self.barHide) {
        [UIView animateWithDuration:0.5 animations:^{
//            self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, BAR_HEIGHT);
            self.bottomBar.frame = CGRectMake(0, self.bounds.size.height - BAR_HEIGHT, self.bounds.size.width, BAR_HEIGHT);
        }];
        self.barHide = false;
    } else {
        
        [UIView animateWithDuration:0.5 animations:^{
//            self.topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
            self.bottomBar.frame = CGRectMake(0, self.bounds.size.height - BAR_HEIGHT, self.bounds.size.width, 0);
        }];
        self.barHide = true;
        
    }
    
}


@end
