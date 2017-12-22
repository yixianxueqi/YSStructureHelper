//
//  UIView+Frame.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

+ (CGFloat)screenWidth;
+ (CGFloat)screenHeight;

- (CGFloat)x;
- (void)setX:(CGFloat)x;

- (CGFloat)y;
- (void)setY:(CGFloat)y;

- (CGFloat)width;
- (void)setWidth:(CGFloat)width;

- (CGFloat)height;
- (void)setHeight:(CGFloat)height;

- (CGFloat)maxX;
- (CGFloat)maxY;

- (CGFloat)midX;
- (CGFloat)midY;

- (CGFloat)minX;
- (CGFloat)minY;

@end
