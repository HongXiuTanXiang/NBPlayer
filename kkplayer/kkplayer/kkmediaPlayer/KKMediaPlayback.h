//
//  KKMediaPlayback.h
//  kkplayer
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, KKMPMoviePlaybackState) {
    KKMPMoviePlaybackStateStopped,
    KKMPMoviePlaybackStatePlaying,
    KKMPMoviePlaybackStatePaused,
    KKMPMoviePlaybackStateInterrupted,
    KKMPMoviePlaybackStateSeekingForward,
    KKMPMoviePlaybackStateSeekingBackward
};

typedef NS_OPTIONS(NSUInteger, KKMPMovieLoadState) {
    KKMPMovieLoadStateUnknown        = 0,
    KKMPMovieLoadStatePlayable       = 1 << 0,
    KKMPMovieLoadStatePlaythroughOK  = 1 << 1, // Playback will be automatically started in this state when shouldAutoplay is YES
    KKMPMovieLoadStateStalled        = 1 << 2, // Playback will be automatically paused in this state, if started
};

typedef NS_ENUM(NSInteger, KKMPMovieScalingMode) {
    KKMPMovieScalingModeNone,       // No scaling
    KKMPMovieScalingModeAspectFit,  // Uniform scale until one dimension fits
    KKMPMovieScalingModeAspectFill, // Uniform scale until the movie fills the visible bounds. One dimension may have clipped contents
    KKMPMovieScalingModeFill        // Non-uniform scale. Both render dimensions will exactly match the visible bounds
};

@protocol KKMediaPlayback <NSObject>

- (void)prepareToPlay:(NSString*)url;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPauseInBackground:(BOOL)pause;

@property(nonatomic, readonly,strong)  UIView *glView;
@property(nonatomic,assign)            NSTimeInterval currentPlaybackTime;
@property(nonatomic, readonly,assign)  NSTimeInterval duration;
@property(nonatomic, readonly,assign)  NSTimeInterval playableDuration;
@property(nonatomic, readonly,assign)  NSInteger bufferingProgress;

@property(nonatomic, readonly,assign)  BOOL isPreparedToPlay;

@property(nonatomic, readonly,assign)  KKMPMoviePlaybackState playbackState;
@property(nonatomic, readonly,assign)  KKMPMovieLoadState loadState;
@property(nonatomic, readonly,assign) int isSeekBuffering;
@property(nonatomic, readonly,assign) int isAudioSync;
@property(nonatomic, readonly,assign) int isVideoSync;

@property(nonatomic, readonly,assign) int64_t numberOfBytesTransferred;

@property(nonatomic, readonly,assign) CGSize naturalSize;
@property(nonatomic,assign) KKMPMovieScalingMode scalingMode;
@property(nonatomic,assign) BOOL shouldAutoplay;

@property(nonatomic,assign) BOOL allowsMediaAirPlay;
@property(nonatomic,assign) BOOL isDanmakuMediaAirPlay;
@property(nonatomic, readonly,assign) BOOL airPlayMediaActive;

@property(nonatomic,assign) float playbackRate;
@property(nonatomic,assign) float playbackVolume;

- (UIImage *)thumbnailImageAtCurrentTime;

@end

NS_ASSUME_NONNULL_END
