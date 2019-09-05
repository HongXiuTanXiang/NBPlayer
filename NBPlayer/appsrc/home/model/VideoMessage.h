//
//  VideoMessage.h
//  NBPlayer
//
//  Created by Mac on 2019/9/5.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface VideoMessage : NSObject
@property(nonatomic, strong) NSString *name;
@property(nonatomic, strong) NSString *timeLength;
@property(nonatomic, strong) NSString *editTime;
@property(nonatomic, strong) NSString *filePath;
@end

NS_ASSUME_NONNULL_END
