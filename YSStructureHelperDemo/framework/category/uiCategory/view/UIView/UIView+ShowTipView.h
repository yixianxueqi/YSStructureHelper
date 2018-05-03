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

/**
 展示弹窗，默认视图中心，2s后自动隐藏

 @param msg 要展示的信息内容
 */
- (void)showAutoHideAlertMsg:(NSString *)msg;

/**
 展示弹窗，默认视图中心+偏移值，2s后自动隐藏

 @param msg 要展示的信息内容
 @param offsetY 偏移值
 */
- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY;

/**
 展示弹窗，默认视图中心+偏移值，指定时间间隔后自动隐藏

 @param msg 要展示的信息内容
 @param offsetY 偏移值
 @param seconds 时间间隔
 */
- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY duration:(NSTimeInterval)seconds;

@end
