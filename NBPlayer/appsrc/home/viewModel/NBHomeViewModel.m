//
//  NBHomeViewModel.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBHomeViewModel.h"
#import "VideoMessage.h"
#import <AVFoundation/AVFoundation.h>

@interface NBHomeViewModel()
@property(nonatomic, strong) NSString *docoumentPath;

@end

@implementation NBHomeViewModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _videsSuj = [RACSubject subject];
        _docoumentPath = [NBFileManager pathForDocumentsDirectory];
    }
    return self;
}

-(NSMutableArray *)videoArray{
    if (!_videoArray) {
        _videoArray = [NSMutableArray array];
    }
    return _videoArray;
}

-(void)loadDocumentLibraryFile{
    
    NSArray *files = [NBFileManager listFilesInDirectoryAtPath:_docoumentPath deep:true];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        for (NSString *file in files) {
            VideoMessage *vmsg = [[VideoMessage alloc]init];
            vmsg.filePath = file;
            vmsg.name = [file lastPathComponent];
            
            NSURL *url = [NSURL URLWithString:file];
            AVURLAsset *videoAss = [[AVURLAsset alloc]initWithURL:url options:nil];
            if (!videoAss) {
                continue;
            }
            AVURLAsset * asset = [AVURLAsset assetWithURL:[NSURL fileURLWithPath:file]];
            CMTime   time = [asset duration];
            int seconds = ceil(time.value/time.timescale);
            
            int minute = (int)seconds/60;
            int second = (int)seconds%60;
            vmsg.timeLength = [NSString stringWithFormat:@"时长: %d:%d",minute,second];
            
            NSDictionary *fileAttrs=[[NSFileManager defaultManager] attributesOfItemAtPath:file error:nil];
            
            NSDate *date = [fileAttrs valueForKey:NSFileCreationDate];
            NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
            fmt.dateFormat = @"yyyy-MM-dd";
            NSString *dateStr = [fmt stringFromDate:date];
            vmsg.editTime = [NSString stringWithFormat:@"创建日期: %@",dateStr];
            [self.videoArray addObject:vmsg];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.videsSuj sendNext:self.videoArray];
        });
    });
    
}

@end
