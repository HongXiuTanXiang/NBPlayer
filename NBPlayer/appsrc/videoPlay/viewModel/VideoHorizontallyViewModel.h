//
//  VideoHorizontallyViewModel.h
//  NBPlayer
//
//  Created by Mac on 2019/9/6.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VideoHorizontallyViewModel : NBViewModel

@property(nonatomic, strong) NSURL *videourl;

-(instancetype)initWithUrl:(NSURL*)url;

@end

NS_ASSUME_NONNULL_END
