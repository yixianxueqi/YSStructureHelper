//
//  UIScrollView+YSEmptyConfig.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIScrollView+YSEmptyConfig.h"
#import <objc/runtime.h>

static NSString *noDataMsg = @"当前暂无任何内容";
static NSString *noDataImg = @"Blank_page_No_Data";
static NSString *noDataDescMsg = @"请先登录或浏览其它模块内容";
static NSString *badNetworkMsg = @"当前网络不给力";
static NSString *badNetworkImg = @"Blank_page_Network_error";
static NSString *badNetworkDescMsg = @"请检查您的网络，或点击重试";

@implementation UIScrollView (YSEmptyConfig)

#pragma mark - public
- (void)deployEmptyTipConfig {
    
    self.emptyDataSetSource = self;
    self.emptyDataSetDelegate = self;
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
}
#pragma mark - incident
#pragma mark - private
- (NSString *)getNoDataMessage {
    
    return [[self class] stringIsEmpty:self.noDataTipMsg] ? noDataMsg : self.noDataTipMsg;
}

- (NSString *)getNoDataDescMessage {
    
    return [[self class] stringIsEmpty:self.noDataTipDescMsg] ? noDataDescMsg : self.noDataTipDescMsg;
}

- (NSString *)getNoDataTipImgName {
    
    return [[self class] stringIsEmpty:self.noDataTipImg] ? noDataImg : self.noDataTipImg;
}

- (NSString *)getBadNetworkTipImgName {
    
    return [[self class] stringIsEmpty:self.badNetworkTipImg] ? badNetworkImg : self.badNetworkTipImg ;
}

+ (BOOL)stringIsEmpty:(NSString *)str {
    
    return (str == nil || str.length <= 0);
}

#pragma mark - DZNEmptyDataSetSource
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *text;
    switch (self.emptyType) {
        case YSEmptyType_badNetWork:
            text = badNetworkMsg;
            break;
        case YSEmptyType_noData:
            text = [self getNoDataMessage];
            break;
        default: text = @"";
            break;
    }
    return [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:21.0f]}];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text;
    switch (self.emptyType) {
        case YSEmptyType_badNetWork:
            text = badNetworkDescMsg;
            break;
        case YSEmptyType_noData:
            text = [self getNoDataDescMessage];
            break;
        default: text = @"";
            break;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
    return attributedString;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text;
    switch (self.emptyType) {
        case YSEmptyType_badNetWork:
            text = @"";
            break;
        case YSEmptyType_noData:
            text = self.nodataBtnTitle ? : @"";
            break;
        default: text = @"";
            break;
    }
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor], NSFontAttributeName: [UIFont systemFontOfSize:15.0]}];
    return attributedString;
}

- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state {
    
    if (self.nodataBtnTitle.length > 0) {
        return [UIImage imageNamed:@"follow_btn_go"];
    } else {
        return nil;
    }
}

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSString *imgName;
    switch (self.emptyType) {
        case YSEmptyType_badNetWork:
            imgName = [self getBadNetworkTipImgName];
            break;
        case YSEmptyType_noData:
            imgName = [self getNoDataTipImgName];
            break;
        default: imgName = @"";
            break;
    }
    return [UIImage imageNamed:imgName];
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
    return -49.0;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 0.0f;
}

#pragma mark - DZNEmptyDataSetDelegate
- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
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
    if (self.emptyType == YSEmptyType_badNetWork && self.emptyDataTapHandle) {
        self.emptyDataTapHandle();
    }
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button {
    
    if (self.emptyDataBtnClickHandle) {
        self.emptyDataBtnClickHandle();
    }
}

- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
    
    // 解决第一次加载时背景色问题方案
    if (!self.emptyDataSetVisible) {
        self.bgColor = [UIColor whiteColor];
    } else {
        self.bgColor = [UIColor whiteColor];
    }
    
    /*
     问题：由于MJRefresh导致的scrollview出现偏移，致使提示图向上便宜54.0（mjRefresh高度）
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
        CGFloat space = (screenSize.width - 114.5) * 0.5;
        for (NSLayoutConstraint *constraint in button.superview.constraints) {
            if (constraint.firstItem == button && constraint.firstAttribute == NSLayoutAttributeLeading) {
                constraint.constant = space;
            } else if (constraint.secondItem == button && constraint.secondAttribute == NSLayoutAttributeTrailing) {
                constraint.constant = space;
            }
        }
        // 调整高度
        for (NSLayoutConstraint *constraint in button.constraints) {
            if (constraint.firstItem == button && constraint.firstAttribute == NSLayoutAttributeHeight) {
                constraint.constant = 32.0;
            }
        }
    }
}


#pragma mark -getter/setter

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

- (void)setBgColor:(UIColor *)bgColor {
    
    objc_setAssociatedObject(self, @selector(bgColor), bgColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)bgColor {
    
    return (UIColor *)objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataTipMsg:(NSString *)noDataTipMsg {
    
    objc_setAssociatedObject(self, @selector(noDataTipMsg), noDataTipMsg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataTipMsg {
    
    return (NSString *)objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataTipDescMsg:(NSString *)noDataTipDescMsg {
    
    objc_setAssociatedObject(self, @selector(noDataTipDescMsg), noDataTipDescMsg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataTipDescMsg {
    
    return (NSString *)objc_getAssociatedObject(self, _cmd);
}

- (void)setNoDataTipImg:(NSString *)noDataTipImg {
    
    objc_setAssociatedObject(self, @selector(noDataTipImg), noDataTipImg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)noDataTipImg {
    
    return (NSString *)objc_getAssociatedObject(self, _cmd);
}

- (void)setBadNetworkTipImg:(NSString *)badNetworkTipImg {
    
    objc_setAssociatedObject(self, @selector(badNetworkTipImg), badNetworkTipImg, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)badNetworkTipImg {
    
    return (NSString *)objc_getAssociatedObject(self, _cmd);
}

- (void)setNodataBtnTitle:(NSString *)nodataBtnTitle {
    
    objc_setAssociatedObject(self, @selector(nodataBtnTitle), nodataBtnTitle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)nodataBtnTitle {
    
    return (NSString *)objc_getAssociatedObject(self, _cmd);
}

- (void)setEmptyDataBtnClickHandle:(void (^)(void))emptyDataBtnClickHandle {
    
    objc_setAssociatedObject(self, @selector(emptyDataBtnClickHandle), emptyDataBtnClickHandle, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(void))emptyDataBtnClickHandle {
    
    return objc_getAssociatedObject(self, _cmd);
}

@end
