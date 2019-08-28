//
//  NBRemuxing.m
//  NBPlayer
//
//  Created by Mac on 2019/7/26.
//  Copyright © 2019 Mac. All rights reserved.
//

//https://cloud.tencent.com/developer/article/1333501

#import "NBRemuxing.h"
#import <libavutil/imgutils.h>
#import <libavutil/opt.h>
#import <libavutil/display.h>
#import <libavutil/eval.h>
#import <libswscale/swscale.h>
#import <libswresample/swresample.h>
#import <libavutil/timestamp.h>
#import <libavformat/avformat.h>
#import <VideoToolbox/VideoToolbox.h>
#import <AudioToolbox/AudioToolbox.h>

typedef enum TranscodeError{
    ERROR_SUCCESS = 0,
    ERROR_ALLOC_BSF = -1,
    ERROR_OPEN_INPUT = -2,
    ERROR_FIND_STREAM = -3,
    ERROR_ALLOC_OUTPUT = -4,
    ERROR_ALLOC_STREAM = -5,
    ERROR_COPY_PARAMS = -6,
    ERROR_AVIO_OPEN = -7,
    ERROR_WRITE_HEAD = -8,

}TranscodeError;



@implementation NBRemuxing


int transcode(const char* input , const char* output){
    int ret = ERROR_SUCCESS;
    //av_register_all();
    
    // for aac
    AVBSFContext *avbsf_ctx = NULL;
    const AVBitStreamFilter* av_bsf = av_bsf_get_by_name("aac_adtstoasc");
    ret = av_bsf_alloc(av_bsf , &avbsf_ctx);
    if(ret != 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to alloc bsf\n");
        return ERROR_ALLOC_BSF;
    }
    //av_bsf_init(avbsf_ctx);
    
    AVBSFContext *videobsf_ctx = NULL;
    const AVBitStreamFilter* video_bsf = av_bsf_get_by_name("h264_mp4toannexb");
    ret = av_bsf_alloc(video_bsf , &videobsf_ctx);
    if(ret != 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to alloc bsf\n");
        return ERROR_ALLOC_BSF;
    }
    
    
    AVFormatContext *ifmt_ctx = NULL;
    AVFormatContext *ofmt_ctx;
    AVOutputFormat  *ofmt = NULL;
    
    ret = avformat_open_input(&ifmt_ctx , input , NULL , NULL);
    if(ret != 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to open the input file\n" , ret);
        return ERROR_OPEN_INPUT;
    }
    
    ret = avformat_find_stream_info(ifmt_ctx , NULL);
    if(ret < 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to find the input file stream info\n" , ret);
        return ERROR_FIND_STREAM;
    }
    av_dump_format(ifmt_ctx , 0 , input , 0);
    
    ret = avformat_alloc_output_context2(&ofmt_ctx , NULL , NULL , output);
    if(ret < 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to alloc output format context\n" , ret);
        return ERROR_ALLOC_OUTPUT;
    }
    
    ofmt = ofmt_ctx->oformat;
    for(int i = 0 ; i < ifmt_ctx->nb_streams ; i++){
        AVStream *in_stream = ifmt_ctx->streams[i];
        AVCodec *codec = avcodec_find_decoder(in_stream->codecpar->codec_id);
        AVStream *out_stream = avformat_new_stream(ofmt_ctx , codec);
        if(!out_stream){
            av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to alloc new stream [%d] for output fmtctx\n" , ret, i);
            return ERROR_ALLOC_STREAM;
        }
        
        AVCodecContext *p_codec_ctx = avcodec_alloc_context3(codec);
        ret = avcodec_parameters_to_context(p_codec_ctx , in_stream->codecpar);
        if(ret < 0){
            av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to praramters to context stream [%d] parameters to outstream\n" , ret, i);
            return ERROR_COPY_PARAMS;
        }
        p_codec_ctx->codec_tag = 0;
        
        if(ofmt_ctx->oformat->flags & AVFMT_GLOBALHEADER){
            p_codec_ctx->flags |= AV_CODEC_FLAG_GLOBAL_HEADER;
        }
        
        ret = avcodec_parameters_from_context(out_stream->codecpar , p_codec_ctx);
        if(ret < 0){
            av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to paramters codec paramter \n" , ret);
        }
    }
    
    av_dump_format(ofmt_ctx , NULL , output , 1);
    
    AVPacket pkt;
    av_init_packet(&pkt);
    pkt.data = NULL;
    pkt.size = 0;
    
    if (!(ofmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&ofmt_ctx->pb, output, AVIO_FLAG_WRITE);
        if (ret < 0) {
            av_log(NULL, AV_LOG_ERROR, "eno:[%d] error to open the output file to write\n", ret);
            return ERROR_AVIO_OPEN;
        }
    }
    
    ret = avformat_write_header(ofmt_ctx , NULL);
    if(ret < 0){
        av_log(NULL , AV_LOG_ERROR , "eno:[%d] error to write the header for output\n" , ret);
        return ERROR_WRITE_HEAD;
    }
    
    int index = 0;
    while(1){
        ret = av_read_frame(ifmt_ctx , &pkt);
        if(ret < 0){
            av_log(NULL , AV_LOG_WARNING , "read frame error\n");
            break;
        }
        
        AVStream* in_stream = ifmt_ctx->streams[pkt.stream_index];
        AVStream* out_stream = ofmt_ctx->streams[pkt.stream_index];
        
        if(pkt.stream_index == 0 ){
            if (in_stream->codecpar->codec_type == AVMEDIA_TYPE_AUDIO) {
                ret = av_bsf_send_packet(videobsf_ctx , &pkt);
                if(ret != 0){
                    av_log(NULL , AV_LOG_WARNING , "wno:[%d] filter audio error\n",ret);
                    continue;
                }
                ret = av_bsf_receive_packet(videobsf_ctx , &pkt);
            }
        }

        //for aac
        if(pkt.stream_index == 1 ){
            ret = av_bsf_send_packet(avbsf_ctx , &pkt);
            if(ret != 0){
                av_log(NULL , AV_LOG_WARNING , "wno:[%d] filter audio error\n",ret);
                continue;
            }
            ret = av_bsf_receive_packet(avbsf_ctx , &pkt);
        }
        
        
        pkt.pts = av_rescale_q_rnd(pkt.pts , in_stream->time_base , out_stream->time_base , AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX);
        pkt.dts = av_rescale_q_rnd(pkt.dts , in_stream->time_base , out_stream->time_base , AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX);
        pkt.duration = av_rescale_q(pkt.duration , in_stream->time_base , out_stream->time_base);
        pkt.pos = -1;
        
        
        ret = av_interleaved_write_frame(ofmt_ctx , &pkt);
        if(ret < 0){
            index++;
            av_packet_unref(&pkt);
            continue;
        }
        av_log(NULL , AV_LOG_INFO , "write frame [%d] ok\n" , index);
        index++;
        av_packet_unref(&pkt);
    }
    
    av_write_trailer(ofmt_ctx);
    avformat_close_input(&ifmt_ctx);
    avio_close(ofmt_ctx->pb);
    avformat_free_context(ofmt_ctx);
    return ret;
}





/**
 将一种视频格式转换为另一种视频格式

 @param inputFilepath 输入文件的路径
 @param outputFilePath 输出文件的路径
 @return 返回值 <0 表示失败
 */
+(int)remuxingInputFilepath: (NSString*)inputFilepath outputFilepath: (NSString*)outputFilePath {
    
    char *in_filename;
    char *out_filename;
    in_filename = [inputFilepath UTF8String];
    out_filename = [outputFilePath UTF8String];

    
    AVFormatContext *in_fmt_ctx = NULL;
    AVFormatContext *out_fmt_ctx = NULL;
    
    AVOutputFormat *output_fmt = NULL;
    AVPacket pkt;
    
    
    
    // *stream_mapping 取出数组首元素,sizeof此元素,得到该数据类型的大小
    // 输入流个数
    int stream_mapping_size = 0;
    int *stream_mapping = NULL;
    
    int ret = 0;
    in_filename = [inputFilepath UTF8String];
    out_filename = [outputFilePath UTF8String];
    
    
    av_register_all();
    
    // 打开输入文件,并将信息放到AVFromatContex里
    ret = avformat_open_input(&in_fmt_ctx, in_filename, 0, 0);
    if (ret < 0) {
        NSLog(@"Could not open input file%@",inputFilepath);
        ret = -2;
        goto end;
    }
    
    // 将输入文件的 stream_info 放入 AVFromatContex;
    ret = avformat_find_stream_info(in_fmt_ctx, 0);
    if (ret < 0) {
        NSLog(@"avformat_find_stream_info error");
        ret = -2;
        goto end;
    }
    
    // 输出信息
    av_dump_format(in_fmt_ctx, 0, in_filename, 0);
    
    // 为输出环境上下文分配内存
    avformat_alloc_output_context2(&out_fmt_ctx, NULL, NULL, out_filename);
    
    if (!out_fmt_ctx) {
        NSLog(@"avformat_alloc_output_context2 error");
        ret = -2;
        goto end;
    }
    

    stream_mapping_size = in_fmt_ctx->nb_streams;
    stream_mapping = av_malloc_array(stream_mapping_size, sizeof(*stream_mapping));
    
    if (!stream_mapping) {
        NSLog(@"av_malloc_array error");
        ret = -2;
        goto end;
    }
    
    output_fmt = out_fmt_ctx->oformat;
    int stream_index = 0;
    
    // 找到数据流数组里的视频流,音频流,字幕流
    // 并对输出流分配内存
    for (int i = 0; i < in_fmt_ctx->nb_streams; i++) {
        AVStream *out_stream;
        AVStream *in_stream = in_fmt_ctx->streams[i];
        AVCodecParameters *in_codecpar = in_stream->codecpar;
        
        if (in_codecpar->codec_type != AVMEDIA_TYPE_VIDEO &&
            in_codecpar->codec_type != AVMEDIA_TYPE_AUDIO &&
            in_codecpar->codec_type != AVMEDIA_TYPE_SUBTITLE) {
            stream_mapping[i] = -1;
            continue;
        }
        
        stream_mapping[i] = stream_index;
        stream_index++;
        
        // 输出流创建内存
        out_stream = avformat_new_stream(out_fmt_ctx, NULL);
        if (!out_stream) {
            NSLog(@"avformat_new_stream error");
            ret = -2;
            goto end;
        }
        
        // 输出流编码参数拷贝
        ret = avcodec_parameters_copy(out_stream->codecpar, in_codecpar);
        if (ret < 0) {
            NSLog(@"avcodec_parameters_copy error");
            ret = -2;
            goto end;
        }
        
        out_stream->codecpar->codec_tag = 0;
    }
    
    // 输出一些日志信息
    av_dump_format(out_fmt_ctx, 0, out_filename, 1);
    
    // 打开输出文件
    if (!(output_fmt->flags & AVFMT_NOFILE)) {
        ret = avio_open(&out_fmt_ctx->pb, out_filename, AVIO_FLAG_WRITE);
        if (ret < 0) {
            NSLog(@"Could not open output file");
            ret = -2;
            goto end;
        }
    }
    
    // 写输出头
    ret = avformat_write_header(out_fmt_ctx, NULL);
    if (ret < 0) {
        NSLog(@"avformat_write_header error");
        ret = -2;
        goto end;
    }
    
    // 写内容
    while (av_read_frame(in_fmt_ctx, &pkt) >= 0) {
        
        AVStream *in_stream, *out_stream;
        
        in_stream = in_fmt_ctx->streams[pkt.stream_index];
        if (pkt.stream_index >= stream_mapping_size ||
            stream_mapping[pkt.stream_index] < 0) {
            av_packet_unref(&pkt);
            continue;
        }
        
        pkt.stream_index = stream_mapping[pkt.stream_index];
        out_stream = out_fmt_ctx->streams[pkt.stream_index];

        // presentation time stamp 显示时间戳
        pkt.pts = av_rescale_q_rnd(pkt.pts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX);
        // decoding time stamp解码时间戳
        pkt.dts = av_rescale_q_rnd(pkt.dts, in_stream->time_base, out_stream->time_base, AV_ROUND_NEAR_INF|AV_ROUND_PASS_MINMAX);
        
        pkt.duration = av_rescale_q(pkt.duration, in_stream->time_base, out_stream->time_base);
        pkt.pos = -1;
        
        
        ret = av_interleaved_write_frame(out_fmt_ctx, &pkt);
        if (ret < 0) {
            NSLog(@"muxing error packet");
            ret = -2;
            break;
        }
        
        av_packet_unref(&pkt);
    }
    
    //写结尾
    av_write_trailer(out_fmt_ctx);
    
end:
    
    avformat_close_input(&in_fmt_ctx);
    
    if (out_fmt_ctx && !(output_fmt->flags & AVFMT_NOFILE)) {
        avio_close(out_fmt_ctx->pb);
    }
    if (out_fmt_ctx) {
        avformat_free_context(out_fmt_ctx);
    }
    
    if (stream_mapping) {
         av_free(stream_mapping);
    }
    
    return ret;
}




@end
