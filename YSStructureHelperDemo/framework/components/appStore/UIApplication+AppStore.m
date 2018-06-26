//
//  UIApplication+AppStore.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIApplication+AppStore.h"
#import <StoreKit/StoreKit.h>

static NSString * const queryInfoUrl = @"https://itunes.apple.com/lookup?id=%@";
static NSString * const entryApp = @"itms-apps://itunes.apple.com/app/id%@";
static NSString * const judgeApp = @"itms-apps://itunes.apple.com/app/id%@?action=write-review";

static NSString * const resultIsSuccessKey = @"isSuccess";
static NSString * const resultKey = @"result";

//记录使用次数相关
static NSString * const appRequestJudge = @"YSAppRequestJudge";
static NSString * const requestTimeStamp = @"YSRequestTimeStamp";
static NSString * const requestSum = @"YSRequestSum";


@implementation UIApplication (AppStore)

+ (void)getAppInfoFromAppStoreWithAppID:(NSString *)appID
                            resultBlock:(void (^)(NSDictionary *))resultBlock {

    NSString *urlStr = [NSString stringWithFormat:queryInfoUrl, appID];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 30.0;
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                NSError *error = [NSError errorWithDomain:@"YSAppInfoDomain" code:-1 userInfo:@{NSLocalizedDescriptionKey: @"获取app信息失败"}];
                resultBlock(@{resultIsSuccessKey:@(false),
                              resultKey: error});
            });
        } else {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSDictionary *info;
            if ([dic[@"resultCount"] integerValue] > 0) {
                info = [dic[@"results"] firstObject];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                resultBlock(@{resultIsSuccessKey: @(true),
                              resultKey: info});
            });
        }
    }];
    [dataTask resume];
}

+ (void)entryAppStoreWithAppID:(NSString *)appID {

    NSString *urlStr = [NSString stringWithFormat:entryApp, appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

+ (void)judgeScoreForAppWithAppID:(NSString *)appID {


    if (@available(iOS 10.3, *)) {
        BOOL isAvailabel = [self checkSKStoreReviewControllerSum];
        if (isAvailabel) {
            [[UIApplication sharedApplication].keyWindow endEditing:YES];
            [SKStoreReviewController requestReview];
            [self updateSKStoreReviewControllerSum];
            return;
        }
    }
    NSString *urlStr = [NSString stringWithFormat:judgeApp,appID];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:nil];
}

/**
 检测 次数限制
 一年内仅三次机会，在可用范围内则返回true
 超出三次机会且在一年内，返回false
 超出三次机会且在一年后，则清空记录，重新计算，返回true
 @return Bool
 */
+ (BOOL)checkSKStoreReviewControllerSum {

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:appRequestJudge];
    NSInteger sum = [dic[requestSum] integerValue];
    NSTimeInterval time = [dic[requestTimeStamp] doubleValue];
    if (sum < 3) {
        return true;
    } else {
        NSTimeInterval current = [[NSDate date] timeIntervalSince1970];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSRange range = [calendar rangeOfUnit:NSCalendarUnitSecond inUnit:NSCalendarUnitYear forDate:[NSDate date]];
        if (current - time > range.length) {
            [[NSUserDefaults standardUserDefaults] setObject:@{requestTimeStamp: @(current), requestSum: @(0)} forKey:appRequestJudge];
            return true;
        }
    }
    return false;
}

/**
 更新记录信息
 若果是该年内第一次记录，则更新时间戳信息，否则只是打开次数+1
 */
+ (void)updateSKStoreReviewControllerSum {

    NSDictionary *dic = [[NSUserDefaults standardUserDefaults] objectForKey:appRequestJudge];
    NSInteger sum = [dic[requestSum] integerValue];
    NSTimeInterval time = [dic[requestTimeStamp] doubleValue];
    if (sum == 0) {
        time = [[NSDate date] timeIntervalSince1970];
    }
    [[NSUserDefaults standardUserDefaults] setObject:@{requestTimeStamp: @(time), requestSum: @(sum + 1)} forKey:appRequestJudge];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end




