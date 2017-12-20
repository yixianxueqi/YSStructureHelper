//
//  ViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/6.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "ViewController.h"
#import "YSLogger.h"

static NSString * const DicTitleKey = @"title";
static NSString * const DicVCKey = @"viewController";

@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *vcList;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    log_debug(@"%@", NSHomeDirectory());
    [self customTabelView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
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

#pragma mark - delegate
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.vcList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    }
    NSDictionary *dic = self.vcList[indexPath.row];
    cell.textLabel.text = dic[DicTitleKey];
    return cell;
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *vcStr = self.vcList[indexPath.row][DicVCKey];
    UIViewController *viewController = (UIViewController *)[[NSClassFromString(vcStr) alloc] init];
    [self.navigationController pushViewController:viewController animated:true];
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

- (NSArray *)vcList {
    if (!_vcList) {
        _vcList = @[@{DicTitleKey: @"查看日志", DicVCKey: @"YSLogDemoViewController"},
                    @{DicTitleKey: @"查看弹窗", DicVCKey: @"YSShowTipDemoViewController"},
                    @{DicTitleKey: @"网络", DicVCKey: @"YSNetworkDemoViewController"},
                    @{DicTitleKey: @"app信息", DicVCKey: @"YSAppInfoDemoViewController"}];
    }
    return _vcList;
}

@end
