//
//  UIButton+Touch.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/5/1.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIButton+Touch.h"
#import <objc/runtime.h>

static char allInset;

@implementation UIButton (Touch)

- (void)setOutsideAreaLength:(CGFloat)length {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(-length, -length, length, length);
    [self setOutsideArea:inset];
}

- (void)setOutsideArea:(UIEdgeInsets)insets {
    
    NSValue *value = [NSValue valueWithUIEdgeInsets:insets];
    objc_setAssociatedObject(self, &allInset, value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CGRect)getOutSideArea {
    
    NSValue *value = objc_getAssociatedObject(self, &allInset);
    if (value) {
        UIEdgeInsets insets = value.UIEdgeInsetsValue;
        CGRect rect = self.bounds;
        return CGRectMake(rect.origin.x + insets.left, rect.origin.y + insets.top, rect.size.width + insets.right - insets.left, rect.size.height + insets.bottom - insets.top);
    } else {
        return self.bounds;
    }
}

- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event {
    
    CGRect rect = [self getOutSideArea];
    if (CGRectEqualToRect(rect, self.bounds))
    {
        return [super hitTest:point withEvent:event];
    }
    return CGRectContainsPoint(rect, point) ? self : nil;
}

@end
