//
//  TestCppClass.hpp
//  kkplayer
//
//  Created by Mac on 2019/10/18.
//  Copyright © 2019 Mac. All rights reserved.
//

#ifndef TestCppClass_hpp
#define TestCppClass_hpp

#include <stdio.h>

#ifdef __cplusplus
extern "C" {
#endif
    
#include "../../FFmpeg/include/libavformat/avformat.h"
#include "../../FFmpeg/include/libavutil/imgutils.h"
#include "../../FFmpeg/include/libavutil/opt.h"
#include "../../FFmpeg/include/libavutil/dict.h"
#include "../../FFmpeg/include/libavutil/display.h"
#include "../../FFmpeg/include/libavutil/eval.h"
#include "../../FFmpeg/include/libswscale/swscale.h"
#include "../../FFmpeg/include/libswresample/swresample.h"
    
#ifdef __cplusplus
}
#endif


class FUCK {
    
    
public:
    int age;
    void testfunc(){
        av_register_all();
    }
};


#endif /* TestCppClass_hpp */
