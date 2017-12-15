//
//  YSNetworkDemoViewController.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/12.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSNetworkDemoViewController.h"
#import "YSNetWork.h"

#define getParams @{@"strDate": @"2015-05-25", @"strRow": @"1"}
#define postParams @{@"foo": @[@(1), @(2), @(3)], @"bar": @{@"baz": @"qux"}}

static NSString * const getUrl = @"https://httpbin.org/get";
static NSString * const postUrl = @"https://httpbin.org/post";
static NSString * const downloadUrl = @"http://farm3.staticflickr.com/2831/9823890176_82b4165653_b_d.jpg";
static NSString * const uploadUrl = @"https://httpbin.org/post";

@interface YSNetworkDemoViewController ()

@property (nonatomic, strong) UIProgressView *progress;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) YSNetWork *network;

@end

@implementation YSNetworkDemoViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"网络";
    self.view.backgroundColor = [UIColor whiteColor];
    //注册网络监听通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(networkStatusChangedNotificationHandle:) name:YSNetworkStatusChangedNotification object:nil];

    [self customView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    //app刚启动就检测网络会是默认值，在一定间隔后才准确获取
    //或者可以延时启动网络监测
    //本demo放在app一启动就检测网络状态
    log_info(@"network Reachable: %d", [[UIApplication sharedApplication] reachable]);
    log_info(@"network status: %ld", (long)[[UIApplication sharedApplication] currentStatus]);
    //检测是否可以访问指定域名
    __weak typeof(self) weakSelf = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication] isReachableHostname:@"www.baidu.com" successBlock:^{
            __strong __typeof(self) strongSelf = weakSelf;
            log_debug(@"可以访问到www.baidu.com");
            [strongSelf.view showAutoHideAlertMsg:@"可以访问到www.baidu.com"];
        } failureBlock:^{
            __strong __typeof(self) strongSelf = weakSelf;
            log_debug(@"无法访问到www.baidu.com,请检查网络链接");
            [strongSelf.view showAutoHideAlertMsg:@"无法访问到www.baidu.com,请检查网络链接"];
        }];
    });

    [self.view showAutoHideAlertMsg:[NSString stringWithFormat:@"%@",[self networkStatusDescripton:[[UIApplication sharedApplication] currentStatus]]]];
}

-(void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:YSNetworkStatusChangedNotification object:nil];
}

#pragma mark - public

#pragma makr - http
- (void)getHttp {

    log_info(@"HEADERS: %@", [self.network getAllHeaders]);
    log_info(@"AcceptContentType: %@", [self.network getAllresponseAcceptableContentType]);
    __weak typeof(self) weakSelf = self;
    [self.network GET:getUrl parameters:getParams cachePolicy:YSNetworkCachePolicy_cache progress:^(NSProgress *progress) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.progress.progress = progress.fractionCompleted;
    } success:^(id responseObj) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.textView.text = [NSString stringWithFormat:@"SUCCESS:\n%@", responseObj];
    } failure:^(NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.textView.text = [NSString stringWithFormat:@"FAILURE:\n%@", error.localizedDescription];
    }];
}

- (void)postHttp {

    log_info(@"HEADERS: %@", [self.network getAllHeaders]);
    log_info(@"AcceptContentType: %@", [self.network getAllresponseAcceptableContentType]);
    __weak typeof(self) weakSelf = self;
    [self.network POST:postUrl parameters:postParams cachePolicy:YSNetworkCachePolicy_cacheWithLimitTime progress:^(NSProgress *progress) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.progress.progress = progress.fractionCompleted;
    } success:^(id responseObj) {
        __strong __typeof(self) strongSelf = weakSelf;
        log_debug(@"请求结果");
        strongSelf.textView.text = [NSString stringWithFormat:@"SUCCESS:\n%@", responseObj];
    } failure:^(NSError *error) {
        __strong __typeof(self) strongSelf = weakSelf;
        strongSelf.textView.text = [NSString stringWithFormat:@"FAILURE:\n%@", error.localizedDescription];
    }];
}

- (void)downloadHttp {

}

- (void)uploadHttp {

}

#pragma mark - incident
//网络变化通知处理
- (void)networkStatusChangedNotificationHandle:(NSNotification *)notify {

    log_info(@"network status change notification: %@",notify);
    YSNetworkStatus status = (YSNetworkStatus)((NSNumber *)notify.userInfo[YSNetworkStatusItem]).integerValue;
    [self.view showAutoHideAlertMsg:[self networkStatusDescripton:status]];
}

//点击网络请求类型按钮
- (void)clickHttpTypeBtn:(UIButton *)btn {

    self.textView.text = @"loading...";
    NSInteger index = btn.tag - 9000;
    if(0 == index) {
        //get
        [self getHttp];
    } else if(1 == index) {
        //post
        [self postHttp];
    } else if(2 == index) {
        //download
        [self downloadHttp];
    } else if (3 == index) {
        //upload
        [self uploadHttp];
    }
}

#pragma mark - private
//网络切换描述
- (NSString *)networkStatusDescripton: (YSNetworkStatus)status {

    NSString *desc = @"";
    switch (status) {
        case NetworkStatusUnknown:
            desc = @"未知网络";
            break;
        case NetworkStatusNotReachable:
            desc = @"网络不可用";
            break;
        case NetworkStatusReachableViaWWAN:
            desc = @"运营商网络";
            break;
        case NetworkStatusReachableViaWiFi:
            desc = @"WiFi环境";
            break;
    }
    return desc;
}

//布局视图
- (void)customView {

    NSArray *list = @[@"Get", @"Post", @"Download", @"Upload"];
    __block UIButton *lastBtn = nil;
    UIView *superView = self.view;
    [list enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.tag = 9000 + idx;
        [btn setTitle:obj forState:UIControlStateNormal];
        [btn sizeToFit];
        [btn addTarget:self action:@selector(clickHttpTypeBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        [btn mas_makeConstraints:^(MASConstraintMaker *make) {
            if(lastBtn) {
                make.top.mas_equalTo(lastBtn.mas_bottom).offset(10.0);
            } else {
                make.top.mas_equalTo(superView).offset(30.0);
            }
            make.centerX.mas_equalTo(superView);
        }];
        lastBtn = btn;
    }];

    self.progress = [[UIProgressView alloc] init];
    self.progress.trackTintColor = [UIColor lightGrayColor];
    self.progress.tintColor = [UIColor greenColor];
    self.progress.progress = 0.0;
    [self.view addSubview:self.progress];
    [self.progress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(superView).offset(30.0);
        make.right.mas_equalTo(superView).offset(-30.0);
        make.top.mas_equalTo(lastBtn.mas_bottom).offset(20.0);
        make.height.mas_equalTo(@(2.5));
    }];

    self.textView = [[UITextView alloc] init];
    self.textView.layer.borderColor = [UIColor blackColor].CGColor;
    self.textView.layer.borderWidth = 0.5;
    [self.view addSubview:self.textView];
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.progress.mas_bottom).offset(20.0);
        make.left.mas_equalTo(superView).offset(30.0);
        make.right.mas_equalTo(superView).offset(-30.0);
        make.bottom.mas_equalTo(superView).offset(-20.0);
    }];
}
#pragma mark - delegate
#pragma mark - getter/setter
- (YSNetWork *)network {
    if(!_network) {
        _network = [YSNetWork defaultNetwork];
    }
    return _network;
}

@end

