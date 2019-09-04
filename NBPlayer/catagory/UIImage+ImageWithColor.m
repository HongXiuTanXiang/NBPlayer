//mxclmade

#import "UIImage+ImageWithColor.h"

static NSCache *imageCache;

@implementation UIImage (WithColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imageCache = [[NSCache alloc] init];
    });
    
    UIImage *image = [imageCache objectForKey:color];
    if (image) {
        return image;
    }
    
    image = [self imageWithColor:color size:CGSizeMake(1,1)];
    [imageCache setObject:image forKey:color];
    
    return image;
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}


- (UIImage *)imageWithScale:(CGFloat)scale{
    
    UIGraphicsBeginImageContext(CGSizeMake(self.size.width * scale, self.size.height * scale));
    [self drawInRect:CGRectMake(0, 0, self.size.width * scale, self.size.height * scale)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

- (UIImage *)scaleToWidth:(CGFloat)width isOrigin: (BOOL)isOrigin{
    
    CGFloat sourceWidth = self.size.width;
    CGFloat sourceHeight = self.size.height;
    
    CGFloat imgWidth = 0;
    CGFloat imgHeight = 0;
    UIImage *image = [UIImage new];
    
    if (isOrigin == YES) { // 选择的是原图
        if (MIN(sourceWidth, sourceHeight) < 1024) { // 最小边小于600
            if (sourceHeight >= sourceWidth) {
                imgHeight = (width / self.size.width) * self.size.height;
                imgWidth = width;
            } else {
                imgHeight = width;
                imgWidth = imgHeight * (self.size.width/self.size.height);
            }
            // 初始化要画的大小
            CGRect  rect = CGRectMake(0, 0, imgWidth, imgHeight);
            // 1. 开启图形上下文
            UIGraphicsBeginImageContext(rect.size);
            // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
            [self drawInRect:rect];
            // 3. 取到图片
            image = UIGraphicsGetImageFromCurrentImageContext();
            // 4. 关闭上下文
            UIGraphicsEndImageContext();
        } else {
            return self;
        }
        
    } else { //选择的非原图
        if (sourceHeight >= sourceWidth) {
            imgHeight = (width / self.size.width) * self.size.height;
            imgWidth = width;
        } else {
            imgHeight = width;
            imgWidth = imgHeight * (self.size.width/self.size.height);
        }
        
        // 初始化要画的大小
        CGRect  rect = CGRectMake(0, 0, imgWidth, imgHeight);
        // 1. 开启图形上下文
        UIGraphicsBeginImageContext(rect.size);
        // 2. 画到上下文中 (会把当前image里面的所有内容都画到上下文)
        [self drawInRect:rect];
        // 3. 取到图片
        image = UIGraphicsGetImageFromCurrentImageContext();
        // 4. 关闭上下文
        UIGraphicsEndImageContext();
    }
    
    // 5. 返回
    return image;
}


@end
