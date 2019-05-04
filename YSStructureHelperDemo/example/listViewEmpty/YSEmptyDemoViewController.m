//
//  YSEmptyDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSEmptyDemoViewController.h"
#import "UIScrollView+YSEmptyConfig.h"
#import <MJRefresh/MJRefresh.h>

@interface YSEmptyDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;
@property (nonatomic, strong) NSArray *list;

@end

@implementation YSEmptyDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"无数据提示";
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    [self.view addSubview:self.tableview];
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0.0);
    }];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"random" style:UIBarButtonItemStylePlain target:self action:@selector(refreshData)];
    [self addTableRefresh];
    [self configEmptyTip];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.tableview.mj_header beginRefreshing];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
#pragma mark - private
- (void)refreshData {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int random = arc4random_uniform(2) % 2;
        if (random == 0) {
            self.list = @[];
            int ranDom = arc4random_uniform(2) % 3;
            if (ranDom == 0) {
                self.tableview.emptyType = YSEmptyType_noData;
            } else if (ranDom == 1) {
                self.tableview.emptyType = YSEmptyType_badNetWork;
            } else {
                self.tableview.emptyType = YSEmptyType_None;
            }
        } else {
            self.list = @[@"a", @"b", @"c"];
        }
        if ([self.tableview.mj_header isRefreshing]) {
            [self.tableview.mj_header endRefreshing];
        }
        [self.tableview reloadData];
    });
}

- (void)addTableRefresh {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
    self.tableview.mj_header = header;
}

- (void)configEmptyTip {
    
    [self configEmptyNodata];
    [self configEmptyBadnetwork];
    weakObj(self);
    self.tableview.emptyDataTapHandle = ^{
        if (weakself.tableview.emptyType == YSEmptyType_badNetWork) {
            NSLog(@"tap handle...");
            [weakself.tableview.mj_header beginRefreshing];
        }
    };
    self.tableview.emptyDataBtnClickHandle = ^{
        NSLog(@"btn click handle");
        [weakself.tableview.mj_header beginRefreshing];
    };
}

- (void)configEmptyNodata {
    
    self.tableview.bgColor = [UIColor whiteColor];
    self.tableview.verticalOffset = -49.0;
    self.tableview.showInNoData = false;
    self.tableview.noDataTipImage = [UIImage imageNamed:@"Blank_page_No_Data"];
    self.tableview.noDataTitleStr = [[NSMutableAttributedString alloc] initWithString:@"当前暂无任何内容" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:21.0]}];
    self.tableview.noDataDesStr = [[NSMutableAttributedString alloc] initWithString:@"请先登录或浏览其它模块内容" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
}

- (void)configEmptyBadnetwork {
    
    self.tableview.bgColor = [UIColor whiteColor];
    self.tableview.verticalOffset = -49.0;
    self.tableview.showInBadNetwork = true;
    self.tableview.btnSize = CGSizeMake(115.0, 32.0);
    self.tableview.btnBGImage = [UIImage imageNamed:@"follow_btn_go"];
    self.tableview.badNetworkBtnAttrStr = [[NSMutableAttributedString alloc] initWithString:@"重试" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0], NSForegroundColorAttributeName: [UIColor whiteColor]}];
    self.tableview.badNetworkTipImage = [UIImage imageNamed:@"Blank_page_Network_error"];
    self.tableview.badNetworkTitleStr = [[NSMutableAttributedString alloc] initWithString:@"当前网络不给力" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:21.0]}];
    self.tableview.badNetworkDesStr = [[NSMutableAttributedString alloc] initWithString:@"请检查您的网络，或点击重试" attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:17.0]}];
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = self.list[indexPath.row];
    return cell;
}

#pragma mark - getter/setter
- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.backgroundColor = [UIColor whiteColor];
        _tableview.delegate = self;
        _tableview.dataSource = self;
        [_tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
        _tableview.tableFooterView = [[UIView alloc] init];
        [_tableview deployEmptyTipConfig];
    }
    return _tableview;
}

@end
