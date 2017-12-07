//
//  UIView+ShowTipView.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIView+ShowTipView.h"
#import <MBProgressHUD/MBProgressHUD.h>

//文字颜色
#define hudTextColor [UIColor whiteColor]
//弹窗大背景色
#define hudBGColor [UIColor clearColor]
//小弹窗的背景色
#define hudAlertBGColor [UIColor blackColor]

@implementation UIView (ShowTipView)

- (void)showLoading {

    [self hideLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [hudAlertBGColor colorWithAlphaComponent:0.8];
    hud.contentColor = hudTextColor;
    [hud removeFromSuperViewOnHide];
    [hud showAnimated:true];
}

- (void)hideLoading {
    [MBProgressHUD hideHUDForView:self animated:true];
}

- (void)showAutoHideAlertMsg:(NSString *)msg {

    [self showAutoHideAlertMsg:msg offsetY:0.0];
}

- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY {

    [self showAutoHideAlertMsg:msg offsetY:offsetY duration:2.0];
}

- (void)showAutoHideAlertMsg:(NSString *)msg offsetY:(CGFloat)offsetY duration:(NSTimeInterval)seconds {

    [self hideLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [hudAlertBGColor colorWithAlphaComponent:0.8];
    hud.label.text = msg;
    hud.label.textColor = hudTextColor;
    hud.label.numberOfLines = 0;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0.0, offsetY);
    [hud removeFromSuperViewOnHide];
    [hud hideAnimated:true afterDelay:seconds];
}

@end
