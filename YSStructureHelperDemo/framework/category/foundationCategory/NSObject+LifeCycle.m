//
//  NSObject+LifeCycle.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "NSObject+LifeCycle.h"
#import <Aspects/Aspects.h>

@implementation NSObject (LifeCycle)

+ (void)load {

    [NSObject aspect_hookSelector:@selector(dealloc) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"%@ dealloc", [aspectInfo.instance class]);
    } error:nil];
}

@end
