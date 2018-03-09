//
//  YSFPSMonitor.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/9.
//  Copyright © 2018年 develop. All rights reserved.
//

#import "YSFPSMonitor.h"

@interface YSFPSMonitor()

@property (nonatomic, strong) UILabel *displayLabel;
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, assign) NSTimeInterval lastTime;

@end

@implementation YSFPSMonitor

#pragma mark - public

static YSFPSMonitor *monitor;
+ (instancetype)defaultFPSMonitor {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        monitor = [[self alloc] init];
    });
    return monitor;
}

- (void)start {
    
    if (self.link == nil) {
        [self initializeTimer];
    }
    [self.displayLabel setHidden:false];
    [self.link setPaused:false];
}

- (void)stop {
    
    [self.displayLabel setHidden:true];
    [self.link setPaused:true];
    [self.link invalidate];
    self.link = nil;
}

#pragma mark - lifeCycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self customDisplayView];
    }
    return self;
}

- (void)dealloc {
    NSLog(@"%@ dealloc...", NSStringFromClass(self.class));
}

#pragma mark - private

- (void)customDisplayView {
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    CGRect frame = CGRectMake(screenSize.width - 100.0, screenSize.height - 50, 80, 30);
    self.displayLabel = [[UILabel alloc] initWithFrame: frame];
    self.displayLabel.layer.cornerRadius = 5;
    self.displayLabel.clipsToBounds = YES;
    self.displayLabel.textAlignment = NSTextAlignmentCenter;
    self.displayLabel.font = [UIFont systemFontOfSize:14.0];
    self.displayLabel.userInteractionEnabled = NO;
    self.displayLabel.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.66];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.displayLabel];
    [self initializeTimer];
}

- (void)initializeTimer {
    
    self.link = [CADisplayLink displayLinkWithTarget:self selector:@selector(tick:)];
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    [self.link setPaused:true];
}

- (void)tick:(CADisplayLink *)link {
    
    if (self.lastTime == 0) {
        self.lastTime = link.timestamp;
        return;
    }
    self.count += 1;
    NSTimeInterval delta = link.timestamp - self.lastTime;
    if (delta >= 1) {
        self.lastTime = link.timestamp;
        float fps = self.count / delta;
        self.count = 0;
        [self updateDisplayLabelText:fps];
    }
}

- (void)updateDisplayLabelText: (float)fps {
    
    CGFloat progress = fps / 60.0;
    UIColor *color = [UIColor colorWithHue:0.27 * (progress - 0.2) saturation:1 brightness:0.9 alpha:1];
    self.displayLabel.text = [NSString stringWithFormat:@"%d FPS",(int)round(fps)];
    self.displayLabel.textColor = color;
}

@end
