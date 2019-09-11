//
//  VideoHorizontallyViewModel.m
//  NBPlayer
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "VideoHorizontallyViewModel.h"

@implementation VideoHorizontallyViewModel

-(instancetype)initWithUrl:(NSURL*)url{
    if (self = [super init]) {
        _videourl = url;
    }
    return self;
}

@end
