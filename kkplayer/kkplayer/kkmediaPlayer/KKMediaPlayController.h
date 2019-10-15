//
//  KKMediaPlayController.h
//  kkplayer
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KKMediaPlayback.h"

NS_ASSUME_NONNULL_BEGIN



@interface KKMediaPlayController : NSObject<KKMediaPlayback>


- (void)prepareToPlay:(NSString*)url;
- (void)play;
- (void)pause;
- (void)stop;
- (BOOL)isPlaying;
- (void)shutdown;
- (void)setPauseInBackground:(BOOL)pause;
- (UIImage *)thumbnailImageAtCurrentTime;

@end

NS_ASSUME_NONNULL_END
