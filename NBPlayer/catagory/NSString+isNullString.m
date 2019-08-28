//
//  NSString+isNullString.m
//  QFBAPP
//
//  Created by yushang on 2019/5/21.
//  Copyright © 2019 YIXun. All rights reserved.
//

#import "NSString+isNullString.h"

@implementation NSString (isNullString)

+ (BOOL)isNullString:(NSString*)string {
    if ([string isEqual:@"NULL"] || [string isKindOfClass:[NSNull class]] || [string isEqual:[NSNull null]] || [string isEqual:NULL] || [[string class] isSubclassOfClass:[NSNull class]] || string == nil || string == NULL || [string isKindOfClass:[NSNull class]] || [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]==0 || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"]) {
        return YES;
    } else {
        return NO;
    }
}

- (NSString *)urlTranscoding{
    
    NSString *encodeStr = @"";
    
    if ([NSString isNullString:self]) {
        return encodeStr;
    }
    
    NSString *tmpStr = self;
    
    if (![self containsString:@"http"]) {
        tmpStr = [NSString stringWithFormat:@"http://%@",self];
    }
    
    NSURL *url = [NSURL URLWithString:tmpStr];
    
    if (url) {
        encodeStr = tmpStr;
    } else {
        //针对中文和`%^{}\"[]|\\<> 进行转义，#作为H5路由标志，不处理
        encodeStr = [tmpStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet characterSetWithCharactersInString:@"#`^{}\"[]|\\<> "].invertedSet];
        
        url = [NSURL URLWithString:encodeStr];
        if (!url) {
            NSCharacterSet *encodeUrlSet = [NSCharacterSet URLQueryAllowedCharacterSet];
            encodeStr = [tmpStr stringByAddingPercentEncodingWithAllowedCharacters:encodeUrlSet];
        }
    }
   

    return encodeStr;
}

@end
