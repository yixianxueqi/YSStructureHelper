//
//  YSAppInfoDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSAppInfoDemoViewController.h"
#import "UIApplication+AppInfo.h"

static NSString * const appID = @"414478124";

@interface YSAppInfoDemoViewController ()

@end

@implementation YSAppInfoDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"App信息";
    [self customView];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
- (void)clickButton:(UIButton *)btn {

    NSInteger tag = btn.tag - 9000;
    if (tag == 0) {
        //获取信息
        [self getAppInfo];
    } else if (tag == 1) {
        //进入AppStore
        [self entryAppStore];
    } else if (tag == 2) {
        //评价
        [self judgeScoreApp];
    } else if (tag == 3) {
        //清空评价内置记录
        [self clearAppJudgeScoreRecord];
    }
}
#pragma mark - private
- (void)customView {

    NSArray *list = @[@"获取信息", @"进入AppStore", @"评价", @"清空评价内置记录"];
    __block UIButton *lastBtn = nil;
    [list enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
        [btn sizeToFit];
        btn.tag = 9000 + idx;
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.view);
            if (lastBtn) {
                make.top.mas_equalTo(lastBtn.mas_bottom).offset(20.0);
            } else {
                make.top.mas_equalTo(@(30.0));
            }
            lastBtn = btn;
        }];
    }];
}

- (void)getAppInfo {

    [UIApplication getAppInfoFromAppStoreWithAppID:appID resultBlock:^(NSDictionary *dic) {
        if ([dic[@"isSuccess"] boolValue]) {
            log_info(@"%@", dic[@"result"]);
        } else {
            log_error(@"%@", dic[@"result"]);
        }
    }];
}

- (void)entryAppStore {

    [UIApplication entryAppStoreWithAppID:appID];
}

- (void)judgeScoreApp {

    [UIApplication judgeScoreForAppWithAppID:appID];
}

- (void)clearAppJudgeScoreRecord {

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"YSAppRequestJudge"];
}

#pragma mark - delegate
#pragma mark - getter/setter

@end












