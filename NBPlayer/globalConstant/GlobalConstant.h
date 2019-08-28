//
//  GlobalConstant.h
//  NBPlayer
//
//  Created by Mac on 2019/7/23.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


#ifndef Release

#define NSLog(FORMAT, ...) fprintf(stderr, "--->%s: %d\t%s\n", [[[NSString stringWithUTF8String: __FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat: FORMAT, ## __VA_ARGS__] UTF8String]);


#else

#define NSLog(FORMAT, ...) nil

#endif


@interface GlobalConstant : NSObject

@end

NS_ASSUME_NONNULL_END
