//
//  UIImage+Create.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/5/1.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIImage+Create.h"

@implementation UIImage (Create)

+ (UIImage *)getImageFromColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0, 0.0, 1.0, 1.0);
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)getImageFromView:(UIView *)view {
    
    return [self getImageFromLayer:view.layer];
}

+ (UIImage *)getImageFromView:(UIView *)view area:(CGRect)rect {
    
    return [self getImageFromLayer:view.layer area:rect];
}

+ (UIImage *)getImageFromLayer:(CALayer *)layer {
    
    return [self getImageFromLayer:layer area:layer.bounds];
}

+ (UIImage *)getImageFromLayer:(CALayer *)layer area:(CGRect)rect {
    
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [layer renderInContext:context];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
