//
//  MediaControlView.h
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MediaControlPlayStatusPlay,
    MediaControlPlayStatusPause,
    MediaControlPlayStatusStop,
    MediaControlPlayStatusComplete,
} MediaControlPlayStatus;

typedef enum : NSUInteger {
    MediaControlScreenStatusFullScreen,
    MediaControlScreenStatusNormal,
} MediaControlScreenStatus;

@protocol MediaControlViewDelegate <NSObject>

@optional

-(void)playPauseButtonDidClick:(UIButton*)playBtn playStatus:(MediaControlPlayStatus)status;

-(void)fullScreenButtonDidClick:(UIButton*)fullBtn screenStatus: (MediaControlScreenStatus)status;

-(void)backButtonDidClick:(UIButton*)backBtn;

@end

@interface MediaControlView : UIView

@property(nonatomic, weak) id <MediaControlViewDelegate>delegate;
@property(nonatomic,weak) id<IJKMediaPlayback> delegatePlayer;
@property(nonatomic, assign) MediaControlScreenStatus screenStatus;

-(MediaControlPlayStatus)getMediaPlayStatus;


@end

NS_ASSUME_NONNULL_END
