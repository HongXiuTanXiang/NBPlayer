//
//  NSString+isNullString.h
//  QFBAPP
//
//  Created by yushang on 2019/5/21.
//  Copyright © 2019 YIXun. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (isNullString)

+ (BOOL)isNullString:(NSString*)string;

- (NSString *)urlTranscoding;

@end

NS_ASSUME_NONNULL_END
