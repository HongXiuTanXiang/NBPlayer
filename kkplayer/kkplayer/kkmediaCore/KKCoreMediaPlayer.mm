//
//  KKCoreMediaPlayer.m
//  kkplayer
//
//  Created by Mac on 2019/10/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "KKCoreMediaPlayer.h"



int KKCoreMediaPlayer:: kk_core_prepare_async(char * file_name){
    this->file_name = file_name;
    unsigned long file_length = strlen(this->file_name);
    if (file_length == 0 || file_length > 2048) {
        return KK_CORE_ERROR_FILE_LENGTH;
    }
    
    int ret = 0;
    //1 init
    av_register_all();
    avformat_network_init();
    
    
    AVFormatContext *fmtcontext = NULL;
    
    //2 open
    ret = avformat_open_input(&fmtcontext, this->file_name, NULL, &(this->options));
    if (ret != 0) {
        return KK_CORE_ERROR_FILE_OPEN_FAILURE;
    }
    
#ifdef DEBUG
    av_dump_format(fmtcontext, 0, this->file_name, 0);
#endif
    
    //3 analyze stream info
    ret = avformat_find_stream_info(fmtcontext, NULL);
    if (ret < 0) {
        return KK_CORE_ERROR_STREAM_INFO_FAILURE;
    }
    
    //4 find video stream
    AVFrame *video_frame = NULL;
    AVFrame *video_sws_frame = NULL;
    struct SwsContext * video_sws_ctx = NULL;
    double rotation = 0;
    int has_video = 1;
    int is_yuv = 0;
    int picstream = -1;
    AVCodecContext *video_codec_ctx = NULL;
    
    int video_stream = kk_core_find_video_stream(fmtcontext, &video_codec_ctx, &picstream);
    if (video_stream < 0) {
        has_video = 0;
    }
    
    if (video_codec_ctx == NULL) {
        has_video = 0;
        goto video_stream_failure;
    }
    
    if (video_stream >= 0 && video_codec_ctx != NULL) {
        
        // 像素格式
        if (video_codec_ctx->pix_fmt != AV_PIX_FMT_NONE) {
            video_frame = av_frame_alloc();
            if (video_frame == NULL) {
                has_video = 0;
                goto video_stream_failure;
            }
            is_yuv = (video_codec_ctx->pix_fmt == AV_PIX_FMT_YUV420P) || (video_codec_ctx->pix_fmt == AV_PIX_FMT_YUVJ420P);
            
            if (!is_yuv) {//rgb
                video_sws_frame = av_frame_alloc();
                if (video_sws_frame == NULL) {
                    has_video = 0;
                    goto video_stream_failure;
                }
                ret = av_image_alloc(video_sws_frame->data, video_sws_frame->linesize, video_codec_ctx->width, video_codec_ctx->height, AV_PIX_FMT_RGB24, 1);
                if (ret < 0) {
                    has_video = 0;
                    goto video_stream_failure;
                }
                
                video_sws_ctx = sws_getContext(video_codec_ctx->width, video_codec_ctx->height, video_codec_ctx->pix_fmt, video_codec_ctx->width, video_codec_ctx->height, AV_PIX_FMT_RGB24, SWS_BILINEAR, NULL, NULL, NULL);
                if (video_sws_ctx == NULL) {
                    has_video = 0;
                    goto video_stream_failure;
                }
            }
            
        video_stream_failure:
            if (has_video == 0) {
                if (video_codec_ctx) {
                    avcodec_free_context(&video_codec_ctx);
                    this->video_codec_ctx = NULL;
                }
                if (video_frame) {av_frame_free(&video_frame);}
                if (video_sws_frame) {av_frame_free(&video_sws_frame);}
                if (video_sws_ctx) {sws_freeContext(video_sws_ctx);}
                
            } else {
                //设置帧率和时间基
                kk_core_timebase_and_fps_of_stream(fmtcontext->streams[video_stream], &(this->video_fps), &(this->video_timebase), 0.04);
                rotation = kk_core_rotation_from_video_stream(fmtcontext->streams[video_stream]);
            }
        }
    }
    
    // find audio stream
    AVFrame *audio_frame = NULL;
    AVCodecContext *audio_codec_ctx = NULL;
    SwrContext *audio_swr_ctx = NULL;
    int has_audio = 1;
    int audio_stream = -1;
    
    
    audio_stream = kk_core_find_audio_stream(fmtcontext, &audio_codec_ctx);
    if (audio_stream < 0) {
        has_audio = 0;
    }
    
    if (audio_stream >= 0 && audio_codec_ctx != NULL) {
        audio_frame = av_frame_alloc();
        if (audio_frame == NULL) {
            has_audio = 0;
            goto audio_stream_failure;
        }
        kk_core_timebase_and_fps_of_stream(fmtcontext->streams[audio_stream], NULL, &(this->audio_timebase), 0.025);
        //设置音频的重采样
        audio_swr_ctx = swr_alloc_set_opts(NULL, av_get_default_channel_layout(this->audio_channels), AV_SAMPLE_FMT_S16, this->audio_sample_rate, av_get_default_channel_layout(audio_codec_ctx->channels), audio_codec_ctx->sample_fmt, audio_codec_ctx->sample_rate, 0, NULL);
        if (audio_swr_ctx == NULL) {
            has_audio = 0;
            goto audio_stream_failure;
        }
        
    audio_stream_failure:
        if (has_audio == 0) {
            if (audio_frame != NULL) {
                av_frame_free(&audio_frame);
            }
            if (audio_codec_ctx != NULL) {
                avcodec_free_context(&audio_codec_ctx);
            }
        } else {
            ret = swr_init(audio_swr_ctx);
            if (ret < 0) {
                if (audio_swr_ctx != NULL) swr_free(&audio_swr_ctx);
                if (audio_codec_ctx != NULL) avcodec_free_context(&audio_codec_ctx);
                if (audio_frame != NULL) av_frame_free(&audio_frame);
            }
        }
    }
    
    if (video_stream < 0 && audio_stream < 0) {
        return KK_CORE_ERROR_STREAM_ERROR;
    }
    
    this->fmtcontext = fmtcontext;
    this->video_codec_ctx = video_codec_ctx;
    this->video_stream_index = video_stream;
    this->picture_stream = picstream;
    this->p_video_frame = video_frame;
    this->p_video_sws_frame = video_sws_frame;
    this->video_sws_ctx = video_sws_ctx;
    
    this->audio_stream_index = audio_stream;
    this->audio_frame = audio_frame;
    this->audio_codec_ctx = audio_codec_ctx;
    this->audio_swr_ctx = audio_swr_ctx;
    
    this->is_yuv = is_yuv;
    this->has_video = has_video;
    this->has_audio = has_audio;
    this->has_picture = picstream >= 0;
    this->is_eof = 0;
    this->rotation = rotation;
    this->duration = fmtcontext->duration/AV_TIME_BASE;
    this->metadata = fmtcontext->metadata;
    // 中断函数
    this->fmtcontext->interrupt_callback = this->interrupt_callback;
    
    return KK_CORE_PREPARE_SUCCESS;
}

int KKCoreMediaPlayer:: kk_core_find_video_stream(AVFormatContext *fmtcontext,AVCodecContext** codec_ctx,int *pictureStream){
    int stream = -1;
    
    for (int i = 0; i < fmtcontext->nb_streams; ++i) {
        if (fmtcontext->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_VIDEO) {
            int disposition = fmtcontext->streams[i]->disposition;
            
            if ((disposition & AV_DISPOSITION_ATTACHED_PIC) == 0) {// 不是艺术照封面
                AVCodecContext *video_codec_ctx = kk_core_open_video_codec(fmtcontext, i);
                if (video_codec_ctx != NULL) {
                    *codec_ctx = video_codec_ctx;
                    stream = i;
                    break;
                }
            } else {
                *pictureStream = i;
            }
        }
        
    }
    
    return stream;
}


AVCodecContext *KKCoreMediaPlayer:: kk_core_open_video_codec(AVFormatContext *fmtctx,int stream_index){
    
    if (fmtctx == NULL) {
        return NULL;
    }
    
    int ret = 0;
    
    AVCodecParameters *codec_par = fmtctx->streams[stream_index]->codecpar;
    AVCodec *video_codec = avcodec_find_decoder(codec_par->codec_id);
    
    if (video_codec == NULL) {
        return NULL;
    }
    
    AVCodecContext *codec_ctx = avcodec_alloc_context3(video_codec);
    if (codec_ctx == NULL) {
        goto open_failure;
    }
    
    ret = avcodec_parameters_to_context(codec_ctx, codec_par);
    if (ret < 0) {
        goto open_failure;
    }
    
    ret = avcodec_open2(codec_ctx, video_codec, NULL);
    if (ret < 0) {
        goto open_failure;
    }
    return codec_ctx;
    
open_failure:
    av_free(video_codec);
    if (codec_ctx != NULL) {
        avcodec_free_context(&codec_ctx);
    }
    return NULL;
}

void KKCoreMediaPlayer::kk_core_timebase_and_fps_of_stream(AVStream*stream,double*fps,double *timebase,double default_value){
    if (stream == NULL) {
        return;
    }
    
    double f = 0,t = 0;
    if (stream->time_base.den > 0 && stream->time_base.num > 0) {
        t = av_q2d(stream->time_base);
    } else {
        t = default_value;
    }
    
    if (stream->avg_frame_rate.den > 0 && stream->avg_frame_rate.num) {
        f = av_q2d(stream->avg_frame_rate);
    } else if (stream->r_frame_rate.den > 0 && stream->r_frame_rate.num > 0) {
        f = av_q2d(stream->r_frame_rate);
    } else {
        f = 1 / t;
    }
    
    if (fps != NULL) {
        *fps = f;
    }
    
    if (timebase != NULL) {
        *timebase = t;
    }
    
}


double KKCoreMediaPlayer:: kk_core_rotation_from_video_stream(AVStream*stream){
    if (stream == NULL) {
        return 0;
    }
    double rotation = 0;
    AVDictionaryEntry *entry = av_dict_get(stream->metadata, "rotate", NULL, AV_DICT_MATCH_CASE);
    if (entry && entry->value) {
        rotation = av_strtod(entry->value, NULL);
    }
    uint8_t *display_matrix = av_stream_get_side_data(stream, AV_PKT_DATA_DISPLAYMATRIX, NULL);
    if (display_matrix) {
        rotation = -av_display_rotation_get((int32_t *)display_matrix);
    }
    return rotation;
}

int KKCoreMediaPlayer:: kk_core_find_audio_stream(AVFormatContext *fmtcontext,AVCodecContext **codec_ctx){
    int stream = -1;
    for (int i = 0; i < fmtcontext->nb_streams; ++i) {
        if (fmtcontext->streams[i]->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
            AVCodecContext *audio_codec_ctx = kk_core_open_audio_codec(fmtcontext, i);
            if (audio_codec_ctx != NULL) {
                *codec_ctx = audio_codec_ctx;
                stream = i;
                break;
            }
        }
    }
    
    return stream;
}

AVCodecContext * KKCoreMediaPlayer:: kk_core_open_audio_codec(AVFormatContext *fmtcontext,int stream){
    
    AVCodecParameters *params = fmtcontext->streams[stream]->codecpar;
    if (params == NULL) {
        return NULL;
    }
    AVCodec *codec = avcodec_find_decoder(params->codec_id);
    if (codec == NULL) return NULL;
    
    AVCodecContext *context = avcodec_alloc_context3(codec);
    if (context == NULL){
        return NULL;
    }
    
    int ret = avcodec_parameters_to_context(context, params);
    if (ret < 0) {
        av_free(codec);
        goto audio_codec_failure;
    }
    
    ret = avcodec_open2(context, codec, NULL);
    if (ret < 0) {
        goto audio_codec_failure;
    }
    
    return context;
    
audio_codec_failure:
    if (codec != NULL) {
        av_free(codec);
    }
    
    if (context != NULL) {
        avcodec_free_context(&context);
    }
    
    return NULL;
}
