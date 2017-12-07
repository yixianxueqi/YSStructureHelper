//
//  YSLogDetailViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSLogDetailViewController.h"

@interface YSLogDetailViewController ()

@property (nonatomic, strong) UITextView *textView;

@end

@implementation YSLogDetailViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"日志详情";
    self.view.backgroundColor = [UIColor whiteColor];
    [self customTextView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.path.length > 0) {
        [self getContentStrFromFilePath];
    }
    [self setContentForTextView];
    self.textView.contentOffset = CGPointZero;
}

#pragma mark - public
#pragma mark - incident
#pragma mark - private
//布局textView
- (void)customTextView {

    [self.view addSubview: self.textView];
    UIView *superView = self.view;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(superView);
    }];
}

//如果是路径，则获取文件内容
- (void)getContentStrFromFilePath {

    self.content = [NSString stringWithContentsOfFile:self.path encoding:NSUTF8StringEncoding error:nil];
}

//为textView设置内容
- (void)setContentForTextView {
    self.textView.text = self.content;
}

#pragma mark - delegate
#pragma mark - getter/setter
- (UITextView *)textView {
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.editable = false;
        _textView.font = [UIFont systemFontOfSize:12.0];
    }
    return _textView;
}

@end
