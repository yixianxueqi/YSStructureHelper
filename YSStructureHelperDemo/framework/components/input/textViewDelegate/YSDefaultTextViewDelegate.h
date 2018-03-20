//
//  YSTextViewDefaultDelegate.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YSDefaultTextViewDelegate : NSObject<UITextViewDelegate>

// 正则表达式 校验文字合法性
@property (nonatomic, copy) NSString *rule;
/*
 最大字数限制，当存在正则rule校验时，优先以正则校验为准。
 */
@property (nonatomic, assign) NSUInteger maxLength;
//文字内容变化回调
@property (nonatomic, copy) void(^textChangeBlock)(NSString *);

@end
