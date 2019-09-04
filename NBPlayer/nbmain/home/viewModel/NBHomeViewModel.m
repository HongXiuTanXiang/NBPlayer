//
//  NBHomeViewModel.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NBHomeViewModel.h"

@implementation NBHomeViewModel

-(NSArray *)loadDocumentLibraryFile{
    NSString *document = [NBFileManager pathForDocumentsDirectory];
    return [NBFileManager listFilesInDirectoryAtPath:document deep:true];
}

@end
