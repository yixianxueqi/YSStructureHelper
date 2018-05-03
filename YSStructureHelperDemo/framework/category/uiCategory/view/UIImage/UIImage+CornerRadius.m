//
//  UIImage+CornerRadius.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/5/3.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIImage+CornerRadius.h"

@implementation UIImage (CornerRadius)

- (UIImage *)getCircleImage {
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGContextAddEllipseInRect(context, rect);
    CGContextClip(context);
    [self drawInRect:rect];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}

- (UIImage *)getCornerRadiusImage:(CGFloat)radius {
    
    return [self getCornerRadiusImageWithCornerType:UIRectCornerAllCorners radius:radius];
}

- (UIImage *)getCornerRadiusImageWithCornerType:(UIRectCorner)cornetType radius:(CGFloat)radius{
    
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:cornetType cornerRadii:CGSizeMake(radius, radius)];
    return [self getImageFromPath:path.CGPath];
}

- (UIImage *)getImageFromPath:(CGPathRef)path {
    
    UIGraphicsBeginImageContextWithOptions(self.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGRect rect = CGRectMake(0.0, 0.0, self.size.width, self.size.height);
    CGContextAddPath(context, path);
    CGContextClip(context);
    [self drawInRect:rect];
    CGContextDrawPath(context, kCGPathStroke);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
