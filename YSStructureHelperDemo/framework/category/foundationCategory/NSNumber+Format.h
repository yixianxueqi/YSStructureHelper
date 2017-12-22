//
//  NSNumber+Format.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSNumber (Format)


/**
 返回格式化金钱字符串

 @return 00,000.00
 */
- (NSString *)moneyFormat;


/**
 返回用科学计数法表示大小的字符串
 例：121212.12 to 12.12E+04
 @return 12.12E+04
 */
- (NSString *)scienceFormat;


/**
 返回格式化百分数

 @return 0.00%
 */
- (NSString *)percentFormat;

@end
