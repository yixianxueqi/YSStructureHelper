//
//  YSDeviceInfoDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSDeviceInfoDemoViewController.h"
#import "UIDevice+Info.h"
#import "UIApplication+Info.h"
#import <YYKit/UIDevice+YYAdd.h>

static NSString * const titleKey = @"titleKey";
static NSString * const valueInfo = @"valueInfo";

@interface YSDeviceInfoDemoViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *list;

@end

@implementation YSDeviceInfoDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设备及App信息";
    
    double memorySize = [UIDevice getTotalMemorySize] / 1024.0 / 1024.0;
    double availabelMemorySize = [UIDevice getAvailableMemorySize] / 1024.0 / 1024.0;
    double appMemorySize = [UIDevice getCurrentAppMemorySize] / 1024.0 / 1024.0;
    double diskSize = [UIDevice getTotalDiskSize] / 1024.0 / 1024.0 / 1024.0;
    double diskFreeSize = [UIDevice getDiskFreeSize] / 1024.0 / 1024.0 / 1024.0;
    double diskUseSize = [UIDevice getDiskUseSize] / 1024.0 / 1024.0 / 1024.0;
    self.list = @[@{titleKey: @"App名称", valueInfo: [UIApplication appName]},
                  @{titleKey: @"Bundle Identifier", valueInfo: [UIApplication bundleIdentifier]},
                  @{titleKey: @"版本", valueInfo: [UIApplication appVersion]},
                  @{titleKey: @"Build版本号", valueInfo: [UIApplication appBuildVersion]},
                  @{titleKey: @"设备序列号", valueInfo: [UIDevice deviceSerialNum]},
                  @{titleKey: @"UUID", valueInfo: [UIDevice uuid]},
                  @{titleKey: @"设备别名", valueInfo: [UIDevice deviceNameDefineByUser]},
                  @{titleKey: @"设备类型", valueInfo: [UIDevice deviceName]},
                  @{titleKey: @"系统版本", valueInfo: [UIDevice deviceSystemVersion]},
                  @{titleKey: @"设备型号", valueInfo: [UIDevice deviceModel]},
                  @{titleKey: @"设备区域型号", valueInfo: [UIDevice deviceLocalModel]},
                  @{titleKey: @"运营商信息", valueInfo: [UIDevice operatorInfo]},
                  @{titleKey: @"电池状态", valueInfo: [NSString stringWithFormat:@"%ld", (long)[UIDevice batteryState]]},
                  @{titleKey: @"电量等级", valueInfo: [NSString stringWithFormat:@"%f", [UIDevice batteryLevel]]},
                  @{titleKey: @"精准电池电量", valueInfo: [NSString stringWithFormat:@"%f", [UIDevice getCurrentBatteryLevel]]},
                  @{titleKey: @"IP地址", valueInfo: [UIDevice getDeviceIPAdress]},
                  @{titleKey: @"内存大小", valueInfo: [NSString stringWithFormat:@"%.2f M", memorySize]},
                  @{titleKey: @"剩余内存大小", valueInfo: [NSString stringWithFormat:@"%.2f M", availabelMemorySize]},
                  @{titleKey: @"APP占用内存大小", valueInfo: [NSString stringWithFormat:@"%.2f M", appMemorySize]},
                  @{titleKey: @"存储大小", valueInfo: [NSString stringWithFormat:@"%.3f G", diskSize]},
                  @{titleKey: @"已使用存储大小", valueInfo: [NSString stringWithFormat:@"%.3f G", diskUseSize]},
                  @{titleKey: @"剩余存储大小", valueInfo: [NSString stringWithFormat:@"%.3f G", diskFreeSize]},
                  @{titleKey: @"CPU核心数量", valueInfo: [NSString stringWithFormat:@"%ld", [UIDevice cpuProcessorCount]]},
                  @{titleKey: @"CPU使用率", valueInfo: [NSString stringWithFormat:@"%.2f", [UIDevice cpuUsage]]}];
    [self.view addSubview: self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}


#pragma mark - public
#pragma makr - http
#pragma mark - incident
#pragma mark - private
#pragma mark - delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier: @"cell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15.0];
        cell.detailTextLabel.font = [UIFont systemFontOfSize:11.0];
    }
    NSDictionary *dic = self.list[indexPath.row];
    cell.textLabel.text = dic[titleKey];
    cell.detailTextLabel.text = dic[valueInfo];
    return cell;
}

#pragma mark - getter/setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 49.0;
    }
    return _tableView;
}

@end








