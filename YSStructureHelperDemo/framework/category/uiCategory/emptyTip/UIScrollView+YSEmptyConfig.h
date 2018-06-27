//
//  UIScrollView+YSEmptyConfig.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>

// 类型
typedef NS_ENUM(NSUInteger, YSEmptyType) {
    YSEmptyType_badNetWork = 1, //网络
    YSEmptyType_noData          //无数据
};

/**
 适用于UITableView及UICollectionView的提示图。
 对于DZNEmptyDataSet的封装。
 对于额外需求可修改该源文件实现。
 */
@interface UIScrollView (YSEmptyConfig) <DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>

// 类型
@property (nonatomic, assign) YSEmptyType emptyType;
// 点击回调
@property (nonatomic, copy) void(^emptyDataTapHandle)(void);
// 按钮点击回调
@property (nonatomic, copy) void(^emptyDataBtnClickHandle)(void);
// 背景色,在无提示图未加载出来的背景色（第一次出现），加载默认后为白色
// 在.m文件emptyDataSetWillAppear方法内可修改，不建议外部设置
@property (nonatomic, strong) UIColor *bgColor;
// 无数据提示标题
@property (nonatomic, copy) NSString *noDataTipMsg;
// 无数据提示描述
@property (nonatomic, copy) NSString *noDataTipDescMsg;
// 无数据提示图
@property (nonatomic, copy) NSString *noDataTipImg;
// 无网络提示图
@property (nonatomic, copy) NSString *badNetworkTipImg;
// 按钮标题
@property (nonatomic, copy) NSString *nodataBtnTitle;

// 配置无数据提示
- (void)deployEmptyTipConfig;

@end
