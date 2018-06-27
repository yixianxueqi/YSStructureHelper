//
//  YSEmptyDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSEmptyDemoViewController.h"
#import "UIScrollView+YSEmptyConfig.h"

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self refreshData];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
#pragma mark - private
- (void)refreshData {
    
    int random = arc4random_uniform(2) % 2;
    if (random == 0) {
        self.list = @[];
        int ranDom = arc4random_uniform(2) % 2;
        ranDom == 0 ? [self configEmptyNodata] : [self configEmptyBadnetwork];
    } else {
        self.list = @[@"a", @"b", @"c"];
    }
    [self.tableview reloadData];
}

- (void)configEmptyNodata {
    
    self.tableview.emptyType = YSEmptyType_noData;
//    self.tableview.noDataTipMsg = @"no data";
//    self.tableview.noDataTipDescMsg = @"no data desc";
    self.tableview.nodataBtnTitle = @"点击重试";
}

- (void)configEmptyBadnetwork {
    
    self.tableview.emptyType = YSEmptyType_badNetWork;
//    self.tableview.noDataTipMsg = @"bad network";
//    self.tableview.noDataTipDescMsg = @"bad network desc";
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
        weakObj(self);
        _tableview.emptyDataTapHandle = ^{
            strongObj(self);
            [self.view showAutoHideAlertMsg:@"emptyDataTapHandle"];
            [self refreshData];
        };
        _tableview.emptyDataBtnClickHandle = ^{
            strongObj(self);
            [self.view showAutoHideAlertMsg:@"emptyDataBtnClickHandle"];
            [self refreshData];
        };
    }
    return _tableview;
}

@end
