//
//  UIApplication+Info.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/26.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "UIApplication+Info.h"

@implementation UIApplication (Info)

//获取app名称
+ (NSString *)appName {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
}
//  获取Bundle Identifier
+ (NSString *)bundleIdentifier {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
}
//获取app版本
+ (NSString *)appVersion {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
}
//获取app build版本
+ (NSString *)appBuildVersion {
    
    return [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
}


@end
