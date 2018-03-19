//
//  YSDefineFuncDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/19.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSDefineFuncDemoViewController.h"
#import "YSTestModel.h"

@interface YSDefineFuncDemoViewController ()

@property (nonatomic, strong) YSTestModel *testModel;
@property (nonatomic, copy) void(^testBlock)(void);

@end

@implementation YSDefineFuncDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"宏函数检验";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self testTrash];
    [self testRetainCycle];
    [self testColor];
}
#pragma mark - public
#pragma mark - incident
#pragma mark - private
// 测试子线程释放对象
- (void)testTrash {
    
    self.testModel = [[YSTestModel alloc] init];
    self.testModel.name = @"test";
    trash(self.testModel);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.testModel say];
    });
}

// 测试强弱引用
- (void)testRetainCycle {

    weakObj(self);
    self.testBlock = ^{
        strongObj(self);
        self.view.alpha = 1.0;
    };
}

// 测试颜色
- (void)testColor {
    
    UIView *view1 = [[UIView alloc] init];
    [self.view addSubview:view1];
    view1.backgroundColor = RGBAColor(252, 98, 93, 1.0);
    
    UIView *view2 = [[UIView alloc] init];
    [self.view addSubview:view2];
    view2.backgroundColor = XColor(0xff5d1e, 1.0);
    
    NSArray *viewList = @[view1, view2];
    [viewList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20.0 leadSpacing:20.0 tailSpacing:20.0];
    [viewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(@64.0);
        make.height.mas_equalTo(@100.0);
    }];
}

#pragma mark - delegate
#pragma mark - getter/setter


@end
