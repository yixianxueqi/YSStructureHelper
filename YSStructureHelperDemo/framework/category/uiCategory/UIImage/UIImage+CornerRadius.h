//
//  UIImage+CornerRadius.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/5/3.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (CornerRadius)

/**
 获得圆形图片

 @return UIImage
 */
- (UIImage *)getCircleImage;

/**
 获得圆角图片

 @param radius 圆角半径
 @return UIImage
 */
- (UIImage *)getCornerRadiusImage:(CGFloat)radius;

/**
 获得指定圆角图片

 @param cornetType 指定位置圆角
 @param radius 圆角半径
 @return UIImage
 */
- (UIImage *)getCornerRadiusImageWithCornerType:(UIRectCorner)cornetType radius:(CGFloat)radius;

/**
 获得指定形状的图片

 @param path 形状路径
 @return UIImage
 */
- (UIImage *)getImageFromPath:(CGPathRef)path;

@end
