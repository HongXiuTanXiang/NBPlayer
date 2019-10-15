//
//  KK_MediaPlayerInject.c
//  kkplayer
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//

#include "KK_MediaPlayerInject.h"

void init_kk_media_player(KKMediaPlayer **player){
    
    *player = (KKMediaPlayer*)malloc(sizeof(KKMediaPlayer));
    (*player)->options = NULL;
    (*player)->test = 99;
    
}

void kkmp_set_options(KKMediaPlayer *player, int opt_category, const char *key, const char *value){
    av_dict_set(&(player->options), key, value, 0);
}

void kkmp_set_option_int(KKMediaPlayer *player ,int opt_category, const char *key, int64_t value){
    av_dict_set_int(&(player->options), key, value, 0);
}