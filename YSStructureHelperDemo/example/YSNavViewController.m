//
//  YSNavViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/8.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNavViewController.h"

@interface YSNavViewController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate>

@end

@implementation YSNavViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationBar.translucent = false;
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [self setAppearance];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {

    if(self.viewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"<" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
        [viewController hidesBottomBarWhenPushed];
    }
    [super pushViewController:viewController animated:true];
}

#pragma mark - public
#pragma mark - incident
#pragma mark - private

- (void)setAppearance {

    self.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationBar setTitleTextAttributes:@{NSFontAttributeName: [UIFont systemFontOfSize:21.0],
                                                 NSForegroundColorAttributeName: [UIColor blackColor]
                                                 }];
}

- (void)goBack {
    [self popViewControllerAnimated: true];
}
#pragma mark - delegate
#pragma mark - UIGestureRecognizerDelegate
#pragma mark - getter/setter
@end




