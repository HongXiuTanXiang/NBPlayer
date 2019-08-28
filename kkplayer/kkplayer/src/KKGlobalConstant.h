//
//  KKGlobalConstant.h
//  kkplayer
//
//  Created by Mac on 2019/8/28.
//  Copyright © 2019 Mac. All rights reserved.
//
/*
 总结:
 1: $(PROJECT_DIR)只作用到progect根目录
 2: 引入第三方的.a库时候,需要在Header Search Path里指名第三方库的头文件
 3: .a文件一般都会直接被引用进来,如果有必要,设置一下 Library Search Path
 */

#import <Foundation/Foundation.h>
#import "avformat.h"

NS_ASSUME_NONNULL_BEGIN

@interface KKGlobalConstant : NSObject

@end

NS_ASSUME_NONNULL_END
