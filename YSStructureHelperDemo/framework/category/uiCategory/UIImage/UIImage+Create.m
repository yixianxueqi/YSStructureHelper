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

#pragma mark - 根据视图生成图片

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

#pragma mark - 加载图片

+ (UIImage *)getImageFromURl:(NSURL *)url {
    
    return [self getImageFromURL:url scale:1.0];
}

+ (UIImage *)getImageFromURL:(NSURL *)url scale:(CGFloat)scale {
    
    CFURLRef cfurl = CFBridgingRetain(url);
    CFStringRef optionKeys[1];
    CFTypeRef optionValues[4];
    optionKeys[0] = kCGImageSourceShouldCache;
    optionValues[0] = (CFTypeRef)kCFBooleanFalse;
    CFDictionaryRef sourceOption = CFDictionaryCreate(kCFAllocatorDefault, (const void **)optionKeys, (const void **)optionValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(cfurl, sourceOption);
    CFRelease(sourceOption);
    if (!imageSource) {
        NSLog(@"imageSource is Null!");
        return nil;
    }
    //获取原图片属性
    CFDictionaryRef property = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil);
    NSDictionary *propertys = CFBridgingRelease(property);
    CGFloat height = [propertys[@"PixelHeight"] integerValue];
    CGFloat width = [propertys[@"PixelWidth"] integerValue];
    int imageSize = (int)MAX(height * scale, width * scale);
    CFStringRef keys[5];
    CFTypeRef values[5];
    //创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
    keys[0] = kCGImageSourceThumbnailMaxPixelSize;
    CFNumberRef thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    values[0] = (CFTypeRef)thumbnailSize;
    keys[1] = kCGImageSourceCreateThumbnailFromImageAlways;
    values[1] = (CFTypeRef)kCFBooleanTrue;
    keys[2] = kCGImageSourceCreateThumbnailWithTransform;
    values[2] = (CFTypeRef)kCFBooleanTrue;
    keys[3] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    values[3] = (CFTypeRef)kCFBooleanTrue;
    keys[4] = kCGImageSourceShouldCacheImmediately;
    values[4] = (CFTypeRef)kCFBooleanTrue;
    
    CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, (const void **)keys, (const void **)values, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageRef thumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    UIImage *resultImg = [UIImage imageWithCGImage:thumbnailImage];
    
    CFRelease(cfurl);
    CFRelease(thumbnailSize);
    CFRelease(options);
    CFRelease(imageSource);
    CFRelease(thumbnailImage);
    
    return resultImg;
}

+ (UIImage *)getImageFromURL:(NSURL *)url maxPixelSize:(NSUInteger)maxLength {
    
    CFURLRef cfurl = CFBridgingRetain(url);
    CFStringRef optionKeys[1];
    CFTypeRef optionValues[4];
    optionKeys[0] = kCGImageSourceShouldCache;
    optionValues[0] = (CFTypeRef)kCFBooleanFalse;
    CFDictionaryRef sourceOption = CFDictionaryCreate(kCFAllocatorDefault, (const void **)optionKeys, (const void **)optionValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageSourceRef imageSource = CGImageSourceCreateWithURL(cfurl, sourceOption);
    CFRelease(sourceOption);
    if (!imageSource) {
        NSLog(@"imageSource is Null!");
        return nil;
    }
    int imageSize = (int)maxLength;
    CFStringRef keys[5];
    CFTypeRef values[5];
    //创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
    keys[0] = kCGImageSourceThumbnailMaxPixelSize;
    CFNumberRef thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    values[0] = (CFTypeRef)thumbnailSize;
    keys[1] = kCGImageSourceCreateThumbnailFromImageAlways;
    values[1] = (CFTypeRef)kCFBooleanTrue;
    keys[2] = kCGImageSourceCreateThumbnailWithTransform;
    values[2] = (CFTypeRef)kCFBooleanTrue;
    keys[3] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    values[3] = (CFTypeRef)kCFBooleanTrue;
    keys[4] = kCGImageSourceShouldCacheImmediately;
    values[4] = (CFTypeRef)kCFBooleanTrue;
    
    CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, (const void **)keys, (const void **)values, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageRef thumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    UIImage *resultImg = [UIImage imageWithCGImage:thumbnailImage];
    
    CFRelease(cfurl);
    CFRelease(thumbnailSize);
    CFRelease(options);
    CFRelease(imageSource);
    CFRelease(thumbnailImage);
    
    return resultImg;
}

#pragma mark - 修改图片

- (UIImage *)resizeScaleImage:(CGFloat)scale {
    
    CGSize imgSize = self.size;
    CGSize targetSize = CGSizeMake(imgSize.width * scale, imgSize.height * scale);
    NSData *imageData = UIImageJPEGRepresentation(self, 1.0);
    CFDataRef data = (__bridge CFDataRef)imageData;
    
    CFStringRef optionKeys[1];
    CFTypeRef optionValues[4];
    optionKeys[0] = kCGImageSourceShouldCache;
    optionValues[0] = (CFTypeRef)kCFBooleanFalse;
    CFDictionaryRef sourceOption = CFDictionaryCreate(kCFAllocatorDefault, (const void **)optionKeys, (const void **)optionValues, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageSourceRef imageSource = CGImageSourceCreateWithData(data, sourceOption);
    CFRelease(sourceOption);
    if (!imageSource) {
        NSLog(@"imageSource is Null!");
        return nil;
    }
    //获取原图片属性
    int imageSize = (int)MAX(targetSize.height, targetSize.width);
    CFStringRef keys[5];
    CFTypeRef values[5];
    //创建缩略图等比缩放大小，会根据长宽值比较大的作为imageSize进行缩放
    keys[0] = kCGImageSourceThumbnailMaxPixelSize;
    CFNumberRef thumbnailSize = CFNumberCreate(NULL, kCFNumberIntType, &imageSize);
    values[0] = (CFTypeRef)thumbnailSize;
    keys[1] = kCGImageSourceCreateThumbnailFromImageAlways;
    values[1] = (CFTypeRef)kCFBooleanTrue;
    keys[2] = kCGImageSourceCreateThumbnailWithTransform;
    values[2] = (CFTypeRef)kCFBooleanTrue;
    keys[3] = kCGImageSourceCreateThumbnailFromImageIfAbsent;
    values[3] = (CFTypeRef)kCFBooleanTrue;
    keys[4] = kCGImageSourceShouldCacheImmediately;
    values[4] = (CFTypeRef)kCFBooleanTrue;
    
    CFDictionaryRef options = CFDictionaryCreate(kCFAllocatorDefault, (const void **)keys, (const void **)values, 4, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    CGImageRef thumbnailImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options);
    UIImage *resultImg = [UIImage imageWithCGImage:thumbnailImage];
    
    CFRelease(thumbnailSize);
    CFRelease(options);
    CFRelease(imageSource);
    CFRelease(thumbnailImage);
    
    return resultImg;
}

@end
