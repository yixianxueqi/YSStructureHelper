//
//  YSTestModel.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/19.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSTestModel.h"

@implementation YSTestModel

- (void)say {
    log_debug(@"name: %@",self.name);
}

- (void)dealloc
{
    log_debug(@"YSTestModel dealloc..");
}

@end
