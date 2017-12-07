//
//  YSLogDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSLogDemoViewController.h"
#import "YSLogDetailViewController.h"

@interface YSLogDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;

@end

@implementation YSLogDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"查看日志";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customTabelView];
    [self getData];
}

- (void)dealloc {
    log_info(@"%@ %s", NSStringFromClass(self.class), __FUNCTION__);
}

#pragma mark - public
#pragma mark - incident
#pragma mark - private
//布局tableview
- (void)customTabelView {

    [self.view addSubview: self.tableView];
    UIView *superView = self.view;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(superView);
    }];
}

//获取日志文件数据
- (void)getData {

    self.list = [[YSLogger shareLogger] getLogFilePath];
    [self.tableView reloadData];
}
#pragma mark - delegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:11.0];
    }
    NSString *path = self.list[indexPath.row];
    cell.textLabel.text = [path lastPathComponent];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *path = self.list[indexPath.row];
    YSLogDetailViewController *logDetailVC = [[YSLogDetailViewController alloc] init];
    logDetailVC.path = path;
    [self.navigationController pushViewController:logDetailVC animated:true];

}
#pragma mark - getter/setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.rowHeight = 44.0;
        _tableView.tableFooterView = [[UIView alloc] init];
    }
    return _tableView;
}
@end
