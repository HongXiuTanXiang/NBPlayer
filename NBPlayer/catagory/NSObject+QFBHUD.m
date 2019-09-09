//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import "NSObject+QFBHUD.h"
#import "LEEAlert.h"
#import "SVProgressHUD.h"
#import "NSString+isNullString.h"

@implementation NSObject (QFBHUD)

- (void)showWithStatus:(NSString *)aText {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:aText];
}

- (void)showErrorText:(NSString *)aText {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showErrorWithStatus:aText];
}

- (void)showSuccessText:(NSString *)aText {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showSuccessWithStatus:aText];
}

- (void)showInfoWithStatus:(NSString *)aText {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showInfoWithStatus:aText];
}

- (void)showLoading {
    [SVProgressHUD show];
}

- (void)dismissLoading {
    [SVProgressHUD dismiss];
}

- (void)dismissLoadingDelay:(NSTimeInterval)delay {
    [SVProgressHUD dismissWithDelay:delay];
}

- (void)showText:(NSString *)aText {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeNone];
    [SVProgressHUD showImage:[UIImage imageNamed:@""] status:aText];
}

- (void)showBundleProgress:(float)progress staus:(NSString *)status {
    [SVProgressHUD showProgress:progress status:status];
}



- (void)showActionSheetTitle:(NSString *)title actions:(NSArray<NSString *> *)actions callBack:(void (^)(NSInteger, NSString *))callBack {

    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    __weak typeof(alertVC) weakAlert = alertVC;
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *addAction = [UIAlertAction actionWithTitle:obj style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            if (callBack) {
                callBack([weakAlert.actions indexOfObject:action], action.title);
            }
        }];
        [alertVC addAction:addAction];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alertVC addAction:cancel];
    
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

-(void)showAlertTitle: (NSString*)title
              content: (NSString*)content
               cancle: (NSString*)cancle
                 sure: (NSString*)sure
         cancleAction: (void(^)(void))cancleBlock sureAction: (void(^)(void))sureBlock{
    
    if ([NSString isNullString:title]) {
        title = @"";
    }
    
    if ([NSString isNullString:content]) {
        content = @"";
    }
    
    if ([NSString isNullString:cancle]) {
        cancle = @"取消";
    }
    
    if ([NSString isNullString:sure]) {
        sure = @"确定";
    }
    
    
    
    UIColor *oringeColor = [UIColor colorWithHexString:@"#FFEFD5"];
    
    [LEEAlert alert].config
    .LeeAddTitle(^(UILabel *label) {
        
        label.text = title;
        
        label.textColor = [UIColor nbBlack];
    })
    .LeeAddContent(^(UILabel *label) {
        
        label.text = content;
        
        label.textColor = [UIColor colorWithHexString:@"#FF1493" alpha:0.8];
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeCancel;
        
        action.title = cancle;
        
        action.titleColor = [UIColor nbDarkGray];
        
        action.backgroundColor = [UIColor whiteColor];
        
        action.clickBlock = ^{
            if (cancleBlock) {
                cancleBlock();
            }
        };
    })
    .LeeAddAction(^(LEEAction *action) {
        
        action.type = LEEActionTypeDefault;
        
        action.title = sure;
        
        action.titleColor = [UIColor nbOringe];
        
        action.backgroundColor = [UIColor nbWhite];
        
        action.clickBlock = ^{
            if (sureBlock) {
                sureBlock();
            }
        };
    })
    .LeeHeaderColor(oringeColor)
    .LeeShow();
    
}


+(void)openQFAppSetting{
    CGFloat systemVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (systemVersion >= 8.0 && systemVersion < 10.0) {  // iOS8.0 和 iOS9.0
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [[UIApplication sharedApplication] openURL:url];
        }
        
    }else if (systemVersion >= 10.0) {  // iOS10.0及以后
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:^(BOOL success) {
                }];
            }
        }
    }
}

@end
