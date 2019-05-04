//
//  UIScrollView+YSEmptyConfig.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIScrollView+YSEmptyConfig.h"
#import <objc/runtime.h>

@implementation UIScrollView (YSEmptyConfig)

#pragma mark - public
- (void)deployEmptyTipConfig {
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    self.emptyType = YSEmptyType_None;
}
#pragma mark - incident
#pragma mark - private
- (NSAttributedString *)getAttrTitle {
    
    switch (self.emptyType) {
        case YSEmptyType_noData:{
            return self.noDataTitleStr;
        }break;
        case YSEmptyType_badNetWork:{
            return self.badNetworkTitleStr;
        }break;
        default:
            return nil;
            break;
    }
}

- (NSAttributedString *)getAttrDescription {
    
    switch (self.emptyType) {
        case YSEmptyType_noData:{
            return self.noDataDesStr;
        }break;
        case YSEmptyType_badNetWork:{
            return self.badNetworkDesStr;
        }break;
        default:
            return nil;
            break;
    }
}

- (NSAttributedString *)getAttrButtonTitle {
    
    if ([self btnShouldShow]) {
        switch (self.emptyType) {
            case YSEmptyType_noData:{
                return self.noDataBtnAttrStr;
            }break;
            case YSEmptyType_badNetWork:{
                return self.badNetworkBtnAttrStr;
            }break;
            default:
                return nil;
                break;
        }
    }
    return nil;
}

- (UIImage *)getBtnBGImage {
    
    if ([self btnShouldShow]) {
        return self.btnBGImage;
    }
    return nil;
}

- (UIImage *)getTipImage {
    
    switch (self.emptyType) {
        case YSEmptyType_noData:{
            return self.noDataTipImage;
        }break;
        case YSEmptyType_badNetWork:{
            return self.badNetworkTipImage;
        }break;
        default:
            return nil;
            break;
    }
}

- (BOOL)btnShouldShow {
    
    switch (self.emptyType) {
        case YSEmptyType_noData:{
            return self.showInNoData;
        }break;
        case YSEmptyType_badNetWork:{
            return self.showInBadNetwork;
        }break;
        default:
            return false;
            break;
    }
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [self getAttrTitle];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    return [self getAttrDescription];
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    return [self getAttrButtonTitle];
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {

    return [self getBtnBGImage];
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [self getTipImage];
}

- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}

- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView {
    
    return self.bgColor;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    return self.verticalOffset;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return (self.emptyType != YSEmptyType_None);
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL) emptyDataSetShouldAllowImageViewAnimate:(UIScrollView *)scrollView
{
    return YES;
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    if (self.emptyDataTapHandle) {
        self.emptyDataTapHandle();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    if (self.emptyDataBtnClickHandle) {
        self.emptyDataBtnClickHandle();
    }
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {

    /*
     问题：由于MJRefresh导致的scrollview出现偏移，致使提示图向上偏移54.0（mjRefresh高度）
     解决：在提示图即将出现时，将scrollview偏移恢复正常，则提示图显示正常
     */
    Class targetCls = NSClassFromString(@"DZNEmptyDataSetView");
    for (UIView *view in scrollView.subviews) {
        if ([view isKindOfClass: targetCls]) {
            view.frame = CGRectMake(0.0, 0.0, scrollView.bounds.size.width, scrollView.bounds.size.height);
        }
    }
}

- (void)emptyDataSetDidAppear:(UIScrollView *)scrollView {
    
    // 调整按钮大小
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    UIButton *button = [scrollView valueForKeyPath:@"emptyDataSetView.button"];
    if ([button isKindOfClass:[UIButton class]]) {
        // 调整宽度
        CGFloat space = (screenSize.width - self.btnSize.width) * 0.5;
        for (NSLayoutConstraint *constraint in button.superview.constraints) {
            if (constraint.firstItem == button && constraint.firstAttribute == NSLayoutAttributeLeading) {
                constraint.constant = space;
            } else if (constraint.secondItem == button && constraint.secondAttribute == NSLayoutAttributeTrailing) {
                constraint.constant = space;
            }
        }
        // 调整高度
        CGFloat height = self.btnSize.height;
        for (NSLayoutConstraint *constraint in button.constraints) {
            if (constraint.firstItem == button && constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = height;
            }
        }
    }
}


#pragma mark - getter/setter

- (void)setEmptyType:(YSEmptyType)emptyType {
    
    objc_setAssociatedObject(self, @selector(emptyType), @(emptyType), OBJC_ASSOCIATION_ASSIGN);
    // 设置状态后，立即刷新无数据提示
    if ([self respondsToSelector:@selector(reloadEmptyDataSet)]) {
        [self performSelector:@selector(reloadEmptyDataSet)];
    }
}
- (YSEmptyType)emptyType {
    
    return (YSEmptyType)[objc_getAssociatedObject(self, _cmd) integerValue];
}

- (void)setEmptyDataTapHandle:(void (^)(void))emptyDataTapHandle {
    objc_setAssociatedObject(self, @selector(emptyDataTapHandle), emptyDataTapHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))emptyDataTapHandle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyDataBtnClickHandle:(void (^)(void))emptyDataBtnClickHandle {
    objc_setAssociatedObject(self, @selector(emptyDataBtnClickHandle), emptyDataBtnClickHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (void (^)(void))emptyDataBtnClickHandle {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBgColor:(UIColor *)bgColor {
    objc_setAssociatedObject(self, @selector(bgColor), bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIColor *)bgColor {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setVerticalOffset:(CGFloat)verticalOffset {
    objc_setAssociatedObject(self, @selector(verticalOffset), @(verticalOffset), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGFloat)verticalOffset {
    return [objc_getAssociatedObject(self, _cmd) floatValue];
}

- (void)setBtnSize:(CGSize)btnSize {
    objc_setAssociatedObject(self, @selector(btnSize), [NSValue valueWithCGSize:btnSize], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CGSize)btnSize {
    return [objc_getAssociatedObject(self, _cmd) CGSizeValue];
}


- (void)setBtnBGImage:(UIImage *)btnBGImage {
    objc_setAssociatedObject(self, @selector(btnBGImage), btnBGImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)btnBGImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setShowInNoData:(BOOL)showInNoData {
    objc_setAssociatedObject(self, @selector(showInNoData), @(showInNoData), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)showInNoData {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setShowInBadNetwork:(BOOL)showInBadNetwork {
    objc_setAssociatedObject(self, @selector(showInBadNetwork), @(showInBadNetwork), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (BOOL)showInBadNetwork {
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setNoDataTipImage:(UIImage *)noDataTipImage {
    objc_setAssociatedObject(self, @selector(noDataTipImage), noDataTipImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (UIImage *)noDataTipImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataTitleStr:(NSMutableAttributedString *)noDataTitleStr {
    objc_setAssociatedObject(self, @selector(noDataTitleStr), noDataTitleStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)noDataTitleStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataDesStr:(NSMutableAttributedString *)noDataDesStr {
    objc_setAssociatedObject(self, @selector(noDataDesStr), noDataDesStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)noDataDesStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataBtnAttrStr:(NSMutableAttributedString *)noDataBtnAttrStr {
    objc_setAssociatedObject(self, @selector(noDataBtnAttrStr), noDataBtnAttrStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)noDataBtnAttrStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadNetworkTipImage:(UIImage *)badNetworkTipImage {
    objc_setAssociatedObject(self, @selector(badNetworkTipImage), badNetworkTipImage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)badNetworkTipImage {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadNetworkTitleStr:(NSMutableAttributedString *)badNetworkTitleStr {
    objc_setAssociatedObject(self, @selector(badNetworkTitleStr), badNetworkTitleStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)badNetworkTitleStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadNetworkDesStr:(NSMutableAttributedString *)badNetworkDesStr {
    objc_setAssociatedObject(self, @selector(badNetworkDesStr), badNetworkDesStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)badNetworkDesStr {
    return objc_getAssociatedObject(self, _cmd);
}

- (void)setBadNetworkBtnAttrStr:(NSMutableAttributedString *)badNetworkBtnAttrStr {
    objc_setAssociatedObject(self, @selector(badNetworkBtnAttrStr), badNetworkBtnAttrStr, OBJC_ASSOCIATION_COPY_NONATOMIC);
}
- (NSMutableAttributedString *)badNetworkBtnAttrStr {
    return objc_getAssociatedObject(self, _cmd);
}


@end
