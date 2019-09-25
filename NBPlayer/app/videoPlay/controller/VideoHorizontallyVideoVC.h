//
//  VideoHorizontallyVideoVC.h
//  NBPlayer
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
#import "VideoHorizontallyViewModel.h"
#import "MediaControlView.h"
NS_ASSUME_NONNULL_BEGIN

@interface VideoHorizontallyVideoVC : NBBaseViewController
@property(nonatomic, strong) IJKFFMoviePlayerController *player;
@property(nonatomic, assign) BOOL shouldClosed;
@property(nonatomic, strong) MediaControlView *controlView;

@end

NS_ASSUME_NONNULL_END
