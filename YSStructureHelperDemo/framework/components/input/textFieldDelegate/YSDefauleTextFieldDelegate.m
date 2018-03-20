//
//  YSDefauleTextFieldDelegate.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSDefauleTextFieldDelegate.h"

@implementation YSDefauleTextFieldDelegate

#pragma makr - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return true;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSMutableString *str = [NSMutableString stringWithString:textField.text];
    [str insertString:string atIndex:range.location];
    if (self.rule.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.rule];
        BOOL flag = [predicate evaluateWithObject: str];
        if (flag) {
            self.textChangeBlock(str);
        }
        return flag;
    }
    if (self.maxLength > 0) {
        BOOL flag = str.length <= self.maxLength;
        if (flag) {
            self.textChangeBlock(str);
        }
        return flag;
    }
    return true;
}


@end
