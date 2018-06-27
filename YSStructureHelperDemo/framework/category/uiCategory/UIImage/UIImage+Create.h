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

#pragma mark - 根据视图生成图片

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


#pragma mark - 加载图片

/**
 通过ImageIO根据URL获取图片
 @note 通过imageIO加载图片，减少内存消耗
 https://www.jianshu.com/p/a6c673678f36
 测试：iPhone7 11.2.6系统下，Xcode9.4
 本地文件148KB的jpg图片：
 通过[UIImage imageWithContentsOfFile:path]加载内存占用为15.7MB左右，
 通过ImageIO加载，内存占用为13.2MB左右
 对比sdwebImage：
 加载本地图片4张：
 通过SDWebImage，内存占用为15MB左右
 通过ImageIO加载，内存占用为14MB左右
 加载网络图片：
 通过SDWebImage，内存占用为14MB左右
 通过ImageIO加载，内存占用为14.5MB左右
 @param url 图片url
 @return UIImage
 */
+ (UIImage *)getImageFromURl:(NSURL *)url ;

/**
 通过ImageIO根据URL获取图片
 
 @param url 图片url
 @param scale 缩放比例
 @return UIImage
 */
+ (UIImage *)getImageFromURL:(NSURL *)url scale:(CGFloat)scale;


/**
 通过ImageIO根据URL获取图片
 
 @param url 图片url
 @param maxLength 最大长度，创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
 @return UIImage
 */
+ (UIImage *)getImageFromURL:(NSURL *)url maxPixelSize:(NSUInteger)maxLength;

#pragma mark - 修改图片

/**
 修改图片尺寸
 
 @param scale 比例
 @return UIImage
 */
- (UIImage *)resizeScaleImage:(CGFloat)scale;

@end
