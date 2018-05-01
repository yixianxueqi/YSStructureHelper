//
//  UIButton+Touch.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/5/1.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 坐标计算，皆是以bounds去计算
 */

@interface UIButton (Touch)

/**
 扩大按钮点击区域
 @note 区域变化为:left-length, right-length, right+length, bottom+length
 @param length CGFloat
 */
- (void)setOutsideAreaLength:(CGFloat)length;

/**
 扩大按钮点击区域
 @note 区域变化为:
        x: x+insets.left,
        y: y+insets.top,
        w: w+insets.right-insets.left,
        h: h+insets.bottom-insets.top
 @param insets UIEdgeInsets
 */
- (void)setOutsideArea:(UIEdgeInsets)insets;

/**
 获取点击区域
 @note 若没扩大，则取自身bounds,
       否则取扩大后的bounds
 @return CGRect
 */
- (CGRect)getOutSideArea;

@end
