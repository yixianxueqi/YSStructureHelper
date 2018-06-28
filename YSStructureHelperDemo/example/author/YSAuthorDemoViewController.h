//
//  YSAuthorDemoViewController.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/28.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YSAuthorCheck.h"

@interface YSAuthorModel: NSObject

@property (nonatomic, copy) NSString *authorName;
@property (nonatomic, assign) YSDeviceAuthorType authorType;

+ (instancetype)createModelWithName:(NSString *)name type:(YSDeviceAuthorType)type;
- (UIColor *)getAuthorTypeMapColor;

@end

@interface YSAuthorDemoViewController : UIViewController

@end
