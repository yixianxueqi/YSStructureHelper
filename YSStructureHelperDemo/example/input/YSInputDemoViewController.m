//
//  YSInputDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSInputDemoViewController.h"
#import "YSDefauleTextFieldDelegate.h"
#import "YSTextView.h"
#import "YSDefaultTextViewDelegate.h"

@interface YSInputDemoViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) YSDefauleTextFieldDelegate *tfDelegate;

@property (nonatomic, strong) YSTextView *textView;
@property (nonatomic, strong) YSDefaultTextViewDelegate *tvDelegate;

@end

@implementation YSInputDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"输入校验";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customView];
}
#pragma mark - public
#pragma mark - incident
#pragma mark - private
- (void)customView {
    
    [self customTextField];
    [self customTextView];
}

- (void)customTextField {
    
    self.textField = [[UITextField alloc] init];
    [self.view addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(64.0);
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
        make.height.mas_equalTo(30.0);
    }];
    self.textField.borderStyle = UITextBorderStyleRoundedRect;
    self.tfDelegate = [[YSDefauleTextFieldDelegate alloc] init];
    self.tfDelegate.maxLength = 10;
    self.tfDelegate.rule = @"^[a-zA-Z0-9_]{0,10}$";
    self.textField.delegate = self.tfDelegate;
    self.tfDelegate.textChangeBlock = ^(NSString *text){
        log_debug(@"%ld, %@",text.length, text);
    };
}

- (void)customTextView {
    
    self.textView = [[YSTextView alloc] init];
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.topMargin.equalTo(self.textField.mas_bottom).offset(20.0);
        make.left.mas_equalTo(20.0);
        make.right.mas_equalTo(-20.0);
        make.height.mas_equalTo(100.0);
    }];
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    self.textView.font = [UIFont systemFontOfSize:14.0];
    [self.textView setPlaceHold:@"请输入..." color:[UIColor darkTextColor]];
    self.tvDelegate = [[YSDefaultTextViewDelegate alloc] init];
    self.tvDelegate.maxLength = 10;
    self.tvDelegate.rule = @"^[a-zA-Z0-9_]{0,10}$";
    self.textView.delegate = self.tvDelegate;
    self.tvDelegate.textChangeBlock = ^(NSString *text){
        log_debug(@"%ld, %@",text.length, text);
    };
}
#pragma mark - delegate
#pragma mark - getter/setter

@end
