//
//  YSShowTipDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSShowTipDemoViewController.h"

@interface YSShowTipDemoViewController ()

@property (nonatomic, strong) UIView *topLeftView;
@property (nonatomic, strong) UIView *topRightView;
@property (nonatomic, strong) UIView *bottomView;

@end

@implementation YSShowTipDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"展示弹窗";
    [self customView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear: animated];

    [self.topLeftView showLoading];
    [self.topRightView showAutoHideAlertMsg:@"111" offsetY:50.0 duration:5.0];
    [self.bottomView showAutoHideAlertMsg:@"233"];
}

#pragma mark - public
#pragma mark - incident
#pragma mark - private
- (void)customView {

    [self.view addSubview: self.topLeftView];
    [self.view addSubview: self.topRightView];
    [self.view addSubview: self.bottomView];
    UIView *superView = self.view;
    CGSize size = [[UIScreen mainScreen] bounds].size;
    [self.topLeftView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(superView);
        make.right.equalTo(self.topRightView.mas_left);
        make.height.equalTo(@(size.width));
        make.size.equalTo(self.topRightView);
    }];
    [self.topRightView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(superView);
    }];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topLeftView.mas_bottom);
        make.bottom.equalTo(superView);
        make.left.right.equalTo(superView);
    }];
}
#pragma mark - delegate
#pragma mark - getter/setter
- (UIView *)topLeftView {
    if (!_topLeftView) {
        _topLeftView = [[UIView alloc] init];
        _topLeftView.backgroundColor = [UIColor yellowColor];
    }
    return _topLeftView;
}

- (UIView *)topRightView {
    if (!_topRightView) {
        _topRightView = [[UIView alloc] init];
        _topRightView.backgroundColor = [UIColor greenColor];
    }
    return _topRightView;
}

- (UIView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        _bottomView.backgroundColor = [UIColor redColor];
    }
    return _bottomView;
}


@end
