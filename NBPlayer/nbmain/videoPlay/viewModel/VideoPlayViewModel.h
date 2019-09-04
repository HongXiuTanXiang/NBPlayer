//
//  VideoPlayViewModel.h
//  NBPlayer
//
//  Created by Mac on 2019/9/4.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoPlayViewModel : NBViewModel

@property(nonatomic, strong) NSURL *videourl;

-(instancetype)initWithUrl:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END
