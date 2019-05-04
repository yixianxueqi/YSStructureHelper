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
    YSEmptyType_None = 0,   //无提示图
    YSEmptyType_badNetWork, //无网络
    YSEmptyType_noData,     //无数据
    
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

@property (nonatomic, assign) CGFloat verticalOffset;
@property (nonatomic, strong) UIColor *bgColor;

// button
@property (nonatomic, assign) CGSize btnSize;
@property (nonatomic, strong) UIImage *btnBGImage;
@property (nonatomic, assign) BOOL showInNoData;
@property (nonatomic, assign) BOOL showInBadNetwork;

// noData
@property (nonatomic, strong) UIImage *noDataTipImage;
@property (nonatomic, copy) NSMutableAttributedString *noDataTitleStr;
@property (nonatomic, copy) NSMutableAttributedString *noDataDesStr;
@property (nonatomic, copy) NSMutableAttributedString *noDataBtnAttrStr;

// badNetwork
@property (nonatomic, strong) UIImage *badNetworkTipImage;
@property (nonatomic, copy) NSMutableAttributedString *badNetworkTitleStr;
@property (nonatomic, copy) NSMutableAttributedString *badNetworkDesStr;
@property (nonatomic, copy) NSMutableAttributedString *badNetworkBtnAttrStr;


// 配置无数据提示
- (void)deployEmptyTipConfig;

@end
