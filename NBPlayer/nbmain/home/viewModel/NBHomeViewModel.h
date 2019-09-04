//
//  NBHomeViewModel.h
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBHomeViewModel : NBViewModel

@property(nonatomic, strong) RACSubject *videsSuj;
@property(nonatomic, strong) NSMutableArray *videoArray;

-(void)loadDocumentLibraryFile;

@end

NS_ASSUME_NONNULL_END
