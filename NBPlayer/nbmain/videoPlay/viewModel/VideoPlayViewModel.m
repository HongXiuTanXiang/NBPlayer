//
//  VideoPlayViewModel.m
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "VideoPlayViewModel.h"

@implementation VideoPlayViewModel

-(instancetype)initWithUrl:(NSURL*)url{
    if (self = [super init]) {
        _videourl = url;
    }
    return self;
}

@end
