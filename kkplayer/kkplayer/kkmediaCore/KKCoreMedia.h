//
//  KKCoreMedia.h
//  kkplayer
//
//  Created by yushang on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//
/*
 播放器核心层,解码,音视频同步
 */

#ifndef KKCoreMedia_h
#define KKCoreMedia_h

#include <stdio.h>

typedef struct KKCoreMediaPlayer{
    char *file_name;//视频地址
    float rate;//播放速率
    float volume;//音量
    
}KKCoreMediaPlayer;

int kk_core_prepare_async(KKCoreMediaPlayer *kk_player);

#endif /* KKCoreMedia_h */
