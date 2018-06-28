
//
//  YSAuthorDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/28.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSAuthorDemoViewController.h"
#import "YSAuthorCell.h"

@interface YSAuthorModel ()

@end

@implementation YSAuthorModel

+ (instancetype)createModelWithName:(NSString *)name type:(YSDeviceAuthorType)type {
    
    YSAuthorModel *model = [[YSAuthorModel alloc] init];
    model.authorName = name;
    model.authorType = type;
    return model;
}

- (UIColor *)getAuthorTypeMapColor {
    
    UIColor *color;
    switch (self.authorType) {
        case YSDeviceAuthorType_unknown:
            color = [UIColor lightGrayColor];
            break;
        case YSDeviceAuthorType_allow:
            color = [UIColor greenColor];
            break;
        case YSDeviceAuthorType_denied:
            color = [UIColor redColor];
            break;
        case YSDeviceAuthorType_notSupport:
            color = [UIColor blackColor];
    }
    return color;
}

@end


@interface YSAuthorDemoViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *list;

@end

@implementation YSAuthorDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"权限相关";
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customView];
    [self customDatalist];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
#pragma mark - private
- (void)customView {
    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(0.0);
    }];
}

- (void)customDatalist {
    
    self.list = [NSMutableArray array];
    
    YSAuthorModel *camera = [YSAuthorModel createModelWithName:@"相机权限" type:[YSAuthorCheck checkCameraAuthor]];
    [self.list addObject:camera];
    
    [self.tableView reloadData];
}
#pragma mark - UITableViewDataSource, UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    YSAuthorCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    [cell setModel:self.list[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    
}



#pragma mark - getter/setter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.rowHeight = 44.0;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        [_tableView registerClass:[YSAuthorCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}

@end
