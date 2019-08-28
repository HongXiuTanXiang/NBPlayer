//
//  LearnCoobjc.h
//  NBPlayer
//
//  Created by Mac on 2019/7/23.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LearnCoobjc : NSObject

+(instancetype)shared;

-(COChan*)learn_cochan;

-(COPromise*)learn_promise;

-(void)generatorsome;

-(void)testActor;


@end

NS_ASSUME_NONNULL_END
