//
//  UIViewController+LifeCycle.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "UIViewController+LifeCycle.h"
#import <Aspects/Aspects.h>

@implementation UIViewController (LifeCycle)

+ (void)load {

    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"%@ viewWillAppear",[aspectInfo.instance class]);
    } error:nil];

    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"%@ viewWillDisappear", [aspectInfo.instance class]);
    } error:nil];
}

@end
