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
