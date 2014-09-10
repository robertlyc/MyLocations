//
//  UIImage+Resize.m
//  MyLocations
//
//  Created by RoBeRt on 14-9-10.
//  Copyright (c) 2014年 SpringShine. All rights reserved.
//

#import "UIImage+Resize.h"

@implementation UIImage (Resize)

- (UIImage *)resizedImageWithBounds:(CGSize)bound {
    CGFloat horizontalRatio = bound.width / self.size.width;
    CGFloat verticalRatio = bound.height / self.size.height;
    CGFloat ratio = MIN(horizontalRatio, verticalRatio);
    CGSize newSize = CGSizeMake(self.size.width * ratio, self.size.height * ratio);
    UIGraphicsBeginImageContextWithOptions(newSize, YES, 0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
