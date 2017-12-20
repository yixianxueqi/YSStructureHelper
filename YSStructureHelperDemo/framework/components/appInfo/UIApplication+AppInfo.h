//
//  UIApplication+AppInfo.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (AppInfo)


/**
 获取app信息从AppStore

 @param appID 编号
 @param resultBlock 结果回调
 内容格式如下：
  @{@"isSuccess": @(Bool),
       @"result": obj}
  若成功，则obj为字典信息；若失败，则为错误信息NSError
 */
+ (void)getAppInfoFromAppStoreWithAppID:(NSString *)appID
                            resultBlock:(void(^)(NSDictionary *dic))resultBlock;


/**
 进入App在AppStore页面

 @param appID 编号
 */
+ (void)entryAppStoreWithAppID:(NSString *)appID;


/**
 给应用评分

 @note 10.3+以后的系统可以当前应用内评分，之前系统则跳转至appStore页去评价
       应用内评分一年仅三次机会，超过次数后，依然跳转至appStore页去评价，等时间过后恢复应用内评分
 @param appID 编号
 */
+ (void)judgeScoreForAppWithAppID:(NSString *)appID;


@end
