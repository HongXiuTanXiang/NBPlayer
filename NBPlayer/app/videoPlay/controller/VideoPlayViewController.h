//
//  VideoPlayViewController.h
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoPlayViewModel.h"
#import <IJKMediaFramework/IJKMediaFramework.h>
NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayViewController : NBBaseViewController
@property(nonatomic, strong) IJKFFMoviePlayerController *player;
@end

NS_ASSUME_NONNULL_END
