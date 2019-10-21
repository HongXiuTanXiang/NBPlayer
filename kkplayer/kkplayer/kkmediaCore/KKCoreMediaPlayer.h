//
//  KKCoreMediaPlayer.h
//  kkplayer
//
//  Created by Mac on 2019/10/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <libavformat/avformat.h>
#import <libavutil/imgutils.h>
#import <libavutil/opt.h>
#import <libavutil/display.h>
#import <libavutil/eval.h>
#import <libswscale/swscale.h>
#import <libswresample/swresample.h>
#import "KKConstant.h"

NS_ASSUME_NONNULL_BEGIN
using namespace std;

class KKCoreMediaPlayer {
public:
    char *file_name;//视频地址,外部传值
    float rate;//播放速率,外部传值
    float volume;//音量,外部传值
    
    AVFormatContext *fmtcontext;
    AVDictionary *options;
    
    AVCodecContext *video_codec_ctx;
    int picture_stream;//艺术照
    int video_stream_index;
    AVFrame *p_video_frame;
    AVFrame *p_video_sws_frame;
    struct SwsContext *video_sws_ctx;
    double video_fps;
    double video_timebase;
    
    
    int audio_channels;//音频通道,外部传值
    int audio_sample_rate;//音频采样率,外部传值
    
    double audio_timebase;
    int audio_stream_index;
    AVFrame *audio_frame;
    AVCodecContext *audio_codec_ctx;
    SwrContext *audio_swr_ctx;
    
    int is_yuv;
    int has_video;
    int has_audio;
    int has_picture;
    int is_eof;
    double rotation;
    int64_t duration;//视频时长
    AVDictionary *metadata;//媒体信息
    AVIOInterruptCB interrupt_callback;//外部传入,中断函数
    
public:
    
    // MARK: ------外部使用方法----
    KKCoreMediaPlayer(){
        
    }
    
    int kk_core_prepare_async(char * file_name);
    
    // MARK: ------内部使用方法----
    //找到视频流
    int kk_core_find_video_stream(AVFormatContext *fmtcontext,AVCodecContext*_Nonnull* _Nonnull codec_ctx,int *pictureStream);
    //打开视频解码器
    AVCodecContext *kk_core_open_video_codec(AVFormatContext *fmtctx,int stream_index);
    
    // 设置视频帧的时间基和帧率
    void kk_core_timebase_and_fps_of_stream(AVStream*stream,double*fps,double *timebase,double default_value);
    // 视频旋转信息
    double kk_core_rotation_from_video_stream(AVStream*stream);
    // 查找音频流
    int kk_core_find_audio_stream(AVFormatContext *fmtcontext,AVCodecContext *_Nonnull*_Nonnull codec_ctx);
    // 打开音频解码器
    AVCodecContext *kk_core_open_audio_codec(AVFormatContext *fmtcontext,int stream);
    
};


NS_ASSUME_NONNULL_END
