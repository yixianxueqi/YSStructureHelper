//
//  YSImageDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/5/1.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSImageDemoViewController.h"
#import "UIImage+Create.h"
#import "UIButton+Touch.h"

@interface YSImageDemoViewController ()

@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIImageView *showImgView;

@end

@implementation YSImageDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"图片相关";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customView];
}
#pragma mark - public
#pragma makr - http
#pragma mark - incident
- (void)clickBtn:(UIButton *)btn {
    
    NSInteger index = btn.tag - 9800;
    if (index == 0) {
        //
        [self testColorImg];
    } else {
        //
        [self testViewImg];
    }
}
#pragma mark - private
- (void)customView {
    
    NSArray *list = @[@"颜色图片", @"view图片"];
    NSMutableArray *btnList = [NSMutableArray array];
    NSInteger count = 9800;
    for (NSString *title in list) {
        UIButton *btn = [self createItemBtnWithTitle:title];
        [btnList addObject:btn];
        [self.view addSubview:btn];
        btn.tag = count;
        count++;
    }
    [btnList mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:20.0 leadSpacing:20.0 tailSpacing:20.0];
    [btnList mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(49.0);
        make.size.mas_equalTo(CGSizeMake(70.0, 25.0));
    }];
    
    [self.view addSubview:self.showImgView];
    [self.showImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view.mas_centerY);
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
        make.bottom.mas_equalTo(-20.0);
    }];
}

- (void)testColorImg {
 
    UIImage *image = [UIImage getImageFromColor:[UIColor redColor]];
    self.showImgView.image = image;
}

- (void)testViewImg {
    
    self.topView.frame = CGRectMake(0.0, 0.0, 100.0, 200.0);
    [self.topView layoutIfNeeded];
    UIImage *img = [UIImage getImageFromView:self.topView];
//    UIImage *img = [UIImage getImageFromView:self.topView area:CGRectMake(0.0, 0.0, 100.0, 100.0)];
//    UIImage *img = [UIImage getImageFromLayer:self.topView.layer];
//    UIImage *img = [UIImage getImageFromLayer:self.topView.layer area:CGRectMake(0.0, 0.0, 100.0, 100.0)];
    self.showImgView.image = img;
}

- (UIButton *)createItemBtnWithTitle:(NSString *)title {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(clickBtn:) forControlEvents:UIControlEventTouchUpInside];
    btn.layer.borderColor = [UIColor redColor].CGColor;
    btn.layer.borderWidth = 1.0;
    [btn setOutsideAreaLength:10.0];
    return btn;
}
#pragma mark - delegate
#pragma mark - getter/setter
- (UIView *)topView {
    if (!_topView) {
        _topView = [[UIView alloc] init];
        _topView.backgroundColor = [UIColor yellowColor];
        
        UILabel *label = [[UILabel alloc] init];
        label.text = @"测试";
        label.textColor = [UIColor blackColor];
        label.backgroundColor = [UIColor greenColor];
        [_topView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10.0);
            make.centerX.mas_equalTo(0.0);
        }];
        
        UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"picture2"]];
        [_topView addSubview:imgView];
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(label.mas_bottom).offset(10.0);
            make.size.mas_equalTo(CGSizeMake(100.0, 100.0));
            make.centerX.mas_equalTo(0.0);
        }];
    }
    return _topView;
}

- (UIImageView *)showImgView {
    if (!_showImgView) {
        _showImgView = [[UIImageView alloc] init];
        _showImgView.contentMode = UIViewContentModeScaleAspectFit;
        _showImgView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _showImgView.layer.borderWidth = 1.0;
    }
    return _showImgView;
}

@end
