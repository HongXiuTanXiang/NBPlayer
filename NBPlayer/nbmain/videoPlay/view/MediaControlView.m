//
//  MediaControlView.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "MediaControlView.h"

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

@end

@implementation MediaControlView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

-(void)setupUI
{
    
    _topBar = [[UIView alloc]init];
    _topBar.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
    
    _bottomBar = [[UIView alloc]init];
    _bottomBar.backgroundColor = [UIColor colorWithHexString:@"#000000" alpha:0.7];
    
    _hubView = [UIButton buttonWithTitle:@"" fontName:kFontRegular fontSize:0 bgImageColor:[UIColor clearColor] titleColor:[UIColor clearColor] target:self action:@selector(hubViewDidClick:)];
    _hubView.backgroundColor = [UIColor clearColor];
    
    [self addSubview:self.topBar];
    [self addSubview:self.bottomBar];
    [self addSubview:self.hubView];
    
    _topBar.frame = CGRectMake(0, 0, self.bounds.size.width, 44);
    _bottomBar.frame = CGRectMake(0, self.bounds.size.height - 44, self.bounds.size.width, 44);
    _hubView.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
}

-(void)hubViewDidClick:(UIButton*)btn{
    
}


@end
