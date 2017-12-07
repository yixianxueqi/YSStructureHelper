//
//  UIView+ShowTipView.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIView+ShowTipView.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIView (ShowTipView)

- (void)showLoading {

    [self hideLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.animationType = MBProgressHUDAnimationFade;
    [hud removeFromSuperViewOnHide];
    [hud showAnimated:true];
}

- (void)hideLoading {
    [MBProgressHUD hideHUDForView:self animated:true];
}

- (void)showAutoHideAlertMsg:(NSString *)msg {

    [self hideLoading];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self animated:true];
    hud.mode = MBProgressHUDModeText;
    hud.animationType = MBProgressHUDAnimationFade;
    hud.detailsLabel.text = msg;
    hud.margin = 10.f;
    hud.offset = CGPointMake(0, 100.0);
    [hud removeFromSuperViewOnHide];
    [hud hideAnimated:true afterDelay:2.0];
}

@end
