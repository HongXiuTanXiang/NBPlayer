//
//  LearnCoobjc.m
//  NBPlayer
//
//  Created by Mac on 2019/7/23.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "LearnCoobjc.h"

@interface LearnCoobjc()

@property(nonatomic, strong) COActor *firstActor;
@property(nonatomic, strong) COActor *secondActor;

@end

@implementation LearnCoobjc

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        _firstActor = co_actor_onqueue(dispatch_get_global_queue(0, 0), ^(COActorChan * _Nonnull channel) {
            [self resoveTheFirstChannel:channel];
        });
        
        _secondActor = co_actor_onqueue(dispatch_get_global_queue(0, 0), ^(COActorChan * _Nonnull channel) {
            [self resoveTheSecondChannel:channel];
        });
    }
    return self;
}

+(instancetype)shared{
    static LearnCoobjc * learn_coobjc = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        learn_coobjc = [[LearnCoobjc alloc]init];
    });
    return learn_coobjc;
}



-(void)resoveTheFirstChannel: (COActorChan * ) channel{
    for (COActorMessage *message in channel) {
        NSLog(@"%@",message.type);
        message.complete(message.type);
    }
}



-(void)resoveTheSecondChannel: (COActorChan * ) channel{
    for (COActorMessage *message in channel) {
        NSLog(@"%@",message.type);
        message.complete(message.type);
    }
}

-(COChan*)learn_cochan{
    COChan *chan = [COChan chan];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        sleep(4);
        [chan send_nonblock:@"fuck"];
    });
    return chan;
}

-(COPromise*)learn_promise{
    return [COPromise promise:^(COPromiseFulfill  _Nonnull fullfill, COPromiseReject  _Nonnull reject) {
        
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            sleep(3);
            long rand = random();
            if (rand % 2) {
                fullfill(@"success");
            } else {
                NSError *myerror = [NSError errorWithDomain:@"falure" code:1000086 userInfo:nil];
                reject(myerror);
            }
        });
        
        
    } onQueue:dispatch_get_global_queue(0, 0)];
}




-(void)generatorsome{
    COGenerator *gen = co_sequence(^{
        while (co_isActive()) {
            int random = arc4random();
            NSString *sometext = [NSString stringWithFormat:@"来点数字=%d",random];
            // 需要生产的数据,yield_val,出让控制权,其实就是内部先调用了send来阻塞
            // 等待receive接收
            yield_val(sometext);
        }
    });
    
    co_launch(^{
        for (int i = 0 ;i < 2 ; i++) {
            // 当调用next, gen才去执行co_sequence中的产生数据的地方,必须放在协程里执行
            // 否则无法接收不到数据
            NSString *sometext = [gen next];
            NSLog(@"%@",sometext);
        }
        [gen cancel];
    });
    
}

-(void)testActor{
    co_launch(^{
        //sendMessage 返回的就是个promise,
        //COActor 不能用懒加载生成,其实他就是一条协程
        await([self.firstActor sendMessage:@"come from firstactor"]);
        await([self.secondActor sendMessage:@"come from secondactor"]);
    });

    
}



@end
