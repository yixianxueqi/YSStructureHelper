//
//  YSAuthorCell.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/28.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSAuthorCell.h"
#import "YSAuthorDemoViewController.h"
#import "UIImage+Create.h"

@interface YSAuthorCell ()

@property (nonatomic, strong) UIImageView *badgeImgView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) YSAuthorModel *authorModel;

@end

@implementation YSAuthorCell

#pragma mark - lifeCycle
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self customView];
    }
    return self;
}
#pragma mark - public
- (void)setModel:(YSAuthorModel *)model {
    
    self.authorModel = model;
    [self updateView];
    
}
#pragma mark - incident
#pragma mark - private

- (void)customView {
    
    [self.contentView addSubview:self.badgeImgView];
    [self.badgeImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(0.0);
        make.left.mas_equalTo(20.0);
        make.size.mas_equalTo(CGSizeMake(10.0, 10.0));
    }];
    
    [self.contentView addSubview:self.label];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.badgeImgView.mas_right).offset(10.0);
        make.centerY.mas_equalTo(0.0);
        make.right.mas_equalTo(-20.0);
    }];
}

- (void)updateView {
    
    self.label.text = self.authorModel.authorName;
    self.badgeImgView.image = [UIImage getImageFromColor:[self.authorModel getAuthorTypeMapColor]];
}
#pragma mark - delegate
#pragma mark - getter/setter

- (UIImageView *)badgeImgView {
    if (!_badgeImgView) {
        _badgeImgView = [[UIImageView alloc] init];
        _badgeImgView.layer.cornerRadius = 5.0;
        _badgeImgView.layer.masksToBounds = true;
    }
    return _badgeImgView;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.textColor = [UIColor blackColor];
        _label.font = [UIFont systemFontOfSize:15.0];
        _label.textAlignment = NSTextAlignmentLeft;
    }
    return _label;
}

@end
