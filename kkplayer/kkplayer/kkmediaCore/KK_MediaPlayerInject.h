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
#include "libavformat/avformat.h"
#include "libavutil/imgutils.h"
#include "libavutil/opt.h"
#include "libavutil/dict.h"
#include "libavutil/display.h"
#include "libavutil/eval.h"
#include "libswscale/swscale.h"
#include "libswresample/swresample.h"

#import "KK_MediaPlayer.hpp"


#ifdef __cplusplus
extern "C" {
#endif
    
    typedef struct KKMediaPlayer {
        
        AVDictionary *options;
        
        KKBasePlayer *basePlayer;
        
        int test;
        
        
    }KKMediaPlayer;
    
    void init_kk_media_player(KKMediaPlayer **player);
    
    void kkmp_set_options(KKMediaPlayer *player, int opt_category, const char *key, const char *value);
    
#ifdef __cplusplus
}
#endif //__cplusplus

#endif /* KK_MediaPlayerInject_h */
