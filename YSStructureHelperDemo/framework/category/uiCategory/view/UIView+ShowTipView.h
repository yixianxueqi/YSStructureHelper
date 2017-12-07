//
//  UIView+ShowTipView.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 此类别为该视图提供弹窗
 */
@interface UIView (ShowTipView)

- (void)showLoading;
- (void)hideLoading;
- (void)showAutoHideAlertMsg:(NSString *)msg;
- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY;
- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY duration:(NSTimeInterval)seconds;

@end
