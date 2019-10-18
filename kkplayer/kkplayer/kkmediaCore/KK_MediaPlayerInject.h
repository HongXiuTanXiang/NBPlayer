//
//  KK_MediaPlayerInject.h
//  kkplayer
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//
/*
 引入第三方.a静态库注意事项
 https://www.jianshu.com/p/155a3cfb765e?utm_campaign=hugo
 1: link Binary with Binaries 中添加第三方依赖有好处也有坏处
 好处是别人只用导入我们的库就可以了,坏处是如果别的sdk里包含这个库,
 那么别人用的时候会有冲入
 */

#ifndef KK_MediaPlayerInject_h
#define KK_MediaPlayerInject_h

#include <stdio.h>
#import <libavformat/avformat.h>
#import <libavutil/imgutils.h>
#import <libavutil/opt.h>
#import <libavutil/dict.h>
#import <libavutil/display.h>
#import <libavutil/eval.h>
#import <libswscale/swscale.h>
#import <libswresample/swresample.h>
#import <VideoToolbox/VideoToolbox.h>

#include "KKCoreMedia.h"

typedef enum KKMediaPlayerError{
    KKMediaPlayerErrorInitPlayerFailuer,
}KKMediaPlayerError;
    
typedef struct KKMediaPlayer {
    
    AVDictionary *options;
    KKCoreMediaPlayer *kk_player;


}KKMediaPlayer;

int kkmp_init_media_player(KKMediaPlayer **player);

void kkmp_set_options(KKMediaPlayer *player, int opt_category, const char *key, const char *value);

void kkmp_set_option_int(KKMediaPlayer *player ,int opt_category, const char *key, int64_t value);

void kkmp_set_playback_rate(KKMediaPlayer *player,float rate);

void kkmp_set_playback_volume(KKMediaPlayer *player,float volume);

int  kkmp_prepare_async(KKMediaPlayer *player,const char* file_name);

int  kkmp_play(KKMediaPlayer *player);


#endif /* KK_MediaPlayerInject_h */
