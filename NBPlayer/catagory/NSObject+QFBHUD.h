//
//  NBHomeViewController.m
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSObject (QFBHUD)

/**
 *  显示纯文本 加一个转圈
 *
 *  @param aText 要显示的文本
 */
- (void)showWithStatus:(NSString *)aText;

/**
 *  显示错误信息
 *
 *  @param aText 错误信息文本
 */
- (void)showErrorText:(NSString *)aText;

/**
 *  显示成功信息
 *
 *  @param aText 成功信息文本
 */
- (void)showSuccessText:(NSString *)aText;

/**
 *  显示图片显示感叹号等待框信息
 *
 *  @param aText 信息文本
 */
- (void)showInfoWithStatus:(NSString *)aText;

/**
 *  只显示一个加载框
 */
- (void)showLoading;

/**
 *  隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
- (void)dismissLoading;

/**
 *  等待delay之后隐藏加载框（所有类型的加载框 都可以通过这个方法 隐藏）
 */
- (void)dismissLoadingDelay:(NSTimeInterval)delay;

/**
 *  显示图文提示
 *
 *  @param aText 要显示的文本
 */
- (void)showText:(NSString*)aText;

/**
 *  显示下载进度
 *
 *  @param progress 要显示的下载进度
 */
- (void)showBundleProgress:(float) progress staus:(NSString *) status;

/** 弹出系统弹框 */
- (void)showActionSheetTitle:(NSString *)title actions:(NSArray <NSString *>*)actions callBack:(void(^)(NSInteger idx, NSString *title))callBack;

-(void)showAlertTitle: (NSString*)title
              content: (NSString*)content
               cancle: (NSString*)cancle
                 sure: (NSString*)sure
         cancleAction: (void(^)(void))cancleBlock sureAction: (void(^)(void))sureBlock;

/**打开APP设置*/
+(void)openQFAppSetting;

@end
