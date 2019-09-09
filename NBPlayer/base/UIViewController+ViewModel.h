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

typedef void (^PopBackBlock)(id _Nullable arg1);

@interface UIViewController (ViewModel)

@property (strong ,nonatomic) NBViewModel *vmodel;

@property(nonatomic, strong) PopBackBlock popBackBlock;

- (instancetype)initwithViewModel: (NBViewModel*)vmodel;




@end

NS_ASSUME_NONNULL_END
