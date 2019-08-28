//
//  UIViewController+ViewModel.h
//  NBPlayer
//
//  Created by yushang on 2019/7/21.
//  Copyright © 2019 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NBViewModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ViewModel)

@property (strong ,nonatomic) NBViewModel *vmodel;

- (instancetype)initwithViewModel: (NBViewModel*)vmodel;

@end

NS_ASSUME_NONNULL_END
