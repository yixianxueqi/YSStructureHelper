//
//  NSNumber+Format.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/20.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "NSNumber+Format.h"

@implementation NSNumber (Format)

- (NSString *)moneyFormat {

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init] ;
    [numberFormatter setPositiveFormat:@"###,##0.00;"];
    NSString *formattedNumberString = [numberFormatter stringFromNumber:self];
    return formattedNumberString;
}

- (NSString *)scienceFormat {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"00.00E+00"];
    NSString *convertNumber = [formatter stringFromNumber:self];
    return convertNumber;
}

- (NSString *)percentFormat {

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setPositiveFormat:@"0.00%"];
    NSString *convertNumber = [formatter stringFromNumber:self];
    return convertNumber;
}

@end
