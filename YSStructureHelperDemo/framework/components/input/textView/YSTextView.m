//
//  YSTextView.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSTextView.h"

@interface YSTextView()

@property (nonatomic, strong) UILabel *placeHoldLabel;

@end

@implementation YSTextView

#pragma mark - lifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customView];
    }
    return self;
}

#pragma mark - public
- (void)setPlaceHold:(NSString *)placeHold color:(UIColor *)color{
    self.placeHoldLabel.text = placeHold;
    self.placeHoldLabel.textColor = color;
}
#pragma mark - private
- (void)customView {
    
    [self addSubview:self.placeHoldLabel];
    [self setValue:self.placeHoldLabel forKey:@"_placeholderLabel"];
}
#pragma mark - getter/setter
- (UILabel *)placeHoldLabel {
    if (!_placeHoldLabel) {
        _placeHoldLabel = [[UILabel alloc] init];
        _placeHoldLabel.textColor = [UIColor lightTextColor];
        _placeHoldLabel.numberOfLines = 0;
        [_placeHoldLabel sizeToFit];
    }
    return _placeHoldLabel;
}
- (void)setFont:(UIFont *)font {
    [super setFont:font];
    self.placeHoldLabel.font = font;
}
@end
