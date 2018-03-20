//
//  YSTextViewDefaultDelegate.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSDefaultTextViewDelegate.h"

@implementation YSDefaultTextViewDelegate

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    NSMutableString *str = [NSMutableString stringWithString:textView.text];
    [str insertString:text atIndex:range.location];
    if (self.rule.length > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", self.rule];
        return [predicate evaluateWithObject: str];
        
    }
    if (self.maxLength > 0) {
        return str.length <= self.maxLength;
    }
    return true;
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.textChangeBlock(textView.text);
}

@end
