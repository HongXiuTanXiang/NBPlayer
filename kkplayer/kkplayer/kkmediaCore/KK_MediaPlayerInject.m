//
//  KK_MediaPlayerInject.c
//  kkplayer
//
//  Created by Mac on 2019/10/15.
//  Copyright © 2019 Mac. All rights reserved.
//

#include "KK_MediaPlayerInject.h"

int kkmp_init_media_player(KKMediaPlayer **player){
    int ret = 0;
    *player = (KKMediaPlayer*)malloc(sizeof(KKMediaPlayer));
    if (player == NULL) {
        return KKMediaPlayerErrorInitPlayerFailuer;
    }
    (*player)->options = NULL;
    ret = kk_core_init_mediaplayer(&((*player)->kk_player));
    if (ret != 0) {
        free((*player));
        return KKMediaPlayerErrorInitPlayerFailuer;
    }
    
    return 0;
}

void kkmp_set_options(KKMediaPlayer *player, int opt_category, const char *key, const char *value){
    av_dict_set(&(player->options), key, value, 0);
}

void kkmp_set_option_int(KKMediaPlayer *player ,int opt_category, const char *key, int64_t value){
    av_dict_set_int(&(player->options), key, value, 0);
}


void kkmp_set_playback_rate(KKMediaPlayer *player,float rate){
    player->kk_player->rate = rate;
}

void kkmp_set_playback_volume(KKMediaPlayer *player,float volume){
    player->kk_player->volume = volume;
}

int kkmp_prepare_async(KKMediaPlayer *player,const char* file_name){
    player->kk_player->file_name = file_name;
    return kk_core_prepare_async(player->kk_player);
}

int kkmp_play(KKMediaPlayer *player);
