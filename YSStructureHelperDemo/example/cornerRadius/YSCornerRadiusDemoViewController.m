//
//  YSCornerRadiusDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/5/3.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSCornerRadiusDemoViewController.h"
#import "UIImage+CornerRadius.h"

@interface YSCornerRadiusDemoViewController ()

@end

@implementation YSCornerRadiusDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self customImage];
}

#pragma mark - public
#pragma mark - http
#pragma mark - incident
#pragma mark - private
- (void)customImage {
    
    NSMutableArray<UIImageView *> *imgViewList = [NSMutableArray array];
    for (int i = 0; i < 3; i++) {
        UIImageView *imgView = [self getImgView];
        [self.view addSubview:imgView];
        [imgViewList addObject:imgView];
    }
    [imgViewList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedItemLength:80.0 leadSpacing:20.0 tailSpacing:20.0];
    [imgViewList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(49.0);
        make.size.mas_equalTo(CGSizeMake(80.0, 80.0));
    }];
    UIImage *img = [UIImage imageNamed:@"picture2"];
    UIImage *circleImg = [img getCircleImage];
    imgViewList[0].image = circleImg;
    UIImage *cornerImg1 = [img getCornerRadiusImage:30.0];
    imgViewList[1].image = cornerImg1;
    UIImage *cornerImg2 = [img getCornerRadiusImageWithCornerType:UIRectCornerTopLeft|UIRectCornerBottomRight radius:30.0];
    imgViewList[2].image = cornerImg2;
}

- (UIImageView *)getImgView {
    
    UIImageView *imgView = [[UIImageView alloc] init];
//    imgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    imgView.layer.borderWidth = 1.0;
    imgView.contentMode = UIViewContentModeScaleAspectFit;
    return imgView;
}
#pragma mark - delegate
#pragma mark - getter/setter

@end
