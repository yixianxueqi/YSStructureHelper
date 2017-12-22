//
//  UIView+Frame.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

+ (CGFloat)screenWidth {

    return [[UIScreen mainScreen] bounds].size.width;
}

+ (CGFloat)screenHeight {

    return [[UIScreen mainScreen] bounds].size.height;
}

- (CGFloat)x {

    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x {

    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y {

    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y {

    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width {

    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {

    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {

    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {

    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)maxX {

    return CGRectGetMaxX(self.frame);
}

- (CGFloat)maxY {

    return CGRectGetMaxY(self.frame);
}

- (CGFloat)midX {

    return CGRectGetMidX(self.frame);
}

- (CGFloat)midY {

    return CGRectGetMidY(self.frame);
}

- (CGFloat)minX {

    return CGRectGetMinX(self.frame);
}

- (CGFloat)minY {

    return CGRectGetMinY(self.frame);
}

@end



