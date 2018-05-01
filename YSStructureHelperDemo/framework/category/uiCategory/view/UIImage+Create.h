//
//  UIImage+Create.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/5/1.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Create)

/**
 以颜色生成一张图片
 @note 大小为(1.0, 1.0)

 @param color 颜色
 @return UIImage
 */
+ (UIImage *)getImageFromColor:(UIColor *)color;

/**
 用view生成图片，大小与view大小相同
 @note view及其子视图需布局完毕
 @param view 待生成图片的视图
 @return UIImage
 */
+ (UIImage *)getImageFromView:(UIView *)view;

/**
 用view生成图片
 @note view及其子视图需布局完毕
 @param view 待生成图片的视图
 @param rect 区域,在view内指定区域生成图片，可用于裁剪
 @return UIImage
 */
+ (UIImage *)getImageFromView:(UIView *)view area:(CGRect)rect;

// 同 + (UIImage *)getImageFromView:(UIView *)view;
+ (UIImage *)getImageFromLayer:(CALayer *)layer;
// 同 + (UIImage *)getImageFromView:(UIView *)view area:(CGRect)rect;
+ (UIImage *)getImageFromLayer:(CALayer *)layer area:(CGRect)rect;
@end
