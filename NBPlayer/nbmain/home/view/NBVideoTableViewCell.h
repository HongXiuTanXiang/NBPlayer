//
//  NBVideoTableViewCell.h
//  
//
//  Created by Mac on 2019/9/4.
//

#import <UIKit/UIKit.h>
#import "VideoMessage.h"

NS_ASSUME_NONNULL_BEGIN

@interface NBVideoTableViewCell : UITableViewCell

-(void)updateCell:(VideoMessage*)vmsg;

@end

NS_ASSUME_NONNULL_END
