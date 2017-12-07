//
//  YSLogger.m
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/6.
//  Copyright © 2017年 develop. All rights reserved.
//

#import "YSLogger.h"
#import "YSLogFormat.h"

typedef void(^archiveLogFileBlock)(NSString *);

@interface YSLogFileManager: DDLogFileManagerDefault

@property (nonatomic, copy) archiveLogFileBlock archiveBlock;

@end

@implementation YSLogFileManager

- (void)didRollAndArchiveLogFile:(NSString *)logFilePath {

    if (self.archiveBlock) {
        self.archiveBlock(logFilePath);
    }
}

@end


@interface YSLogger()

@property (nonatomic, weak) id <DDLogFileManager> fileManager;

@end

@implementation YSLogger

#pragma mark - life cycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
#ifdef DEBUG
        [DDLog addLogger:[DDTTYLogger sharedInstance]]; // TTY = Xcode console
#endif
        [DDLog addLogger:[DDASLLogger sharedInstance]]; // ASL = Apple System Logs
    }
    return self;
}

static YSLogger *logger = nil;

#pragma mark - public
+ (instancetype)shareLogger {

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        logger = [[self alloc] init];
        [self setLogFormat:[[YSLogFormat alloc] init]];
        [logger catchCrash];
    });
    return logger;
}

+ (void)setLogFormat:(id<DDLogFormatter>)format {

    for (DDAbstractLogger *log in [DDLog allLoggers]) {
        [log setLogFormatter:format];
    }
}

+ (void)setFileLogLevel:(DDLogLevel)level {

    YSLogFileManager *logFileManager = [[YSLogFileManager alloc] init];
    DDFileLogger *fileLogger = [[DDFileLogger alloc] initWithLogFileManager: logFileManager]; // File Logger
    fileLogger.rollingFrequency = 60 * 60 * 24 * 7; // 24 hour rolling * 7
    fileLogger.logFileManager.maximumNumberOfLogFiles = 7; //日志最多个数7
    [fileLogger setLogFormatter:[[[DDLog allLoggers] firstObject] logFormatter]];
    //默认将info等级的写入文件
    [DDLog addLogger:fileLogger withLevel:level];
    logger.fileManager = logFileManager;
    logFileManager.archiveBlock = ^(NSString *path){
        if (logger.delegate && [logger.delegate respondsToSelector:@selector(getRollLogFileDidArchivePath:)]) {
            [logger.delegate getRollLogFileDidArchivePath: path];
        }
    };
}

- (NSString *)getLogFileDirectory {

    return self.fileManager.logsDirectory;
}

- (NSArray<NSString *> *)getLogFilePath {

    return self.fileManager.sortedLogFilePaths;
}

#pragma mark - private
/**
 *  启动获取崩溃信息
 */
- (void)catchCrash {

    NSSetUncaughtExceptionHandler(&uncaughtExceptionHandler);
}

void uncaughtExceptionHandler(NSException *exception) {

    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    //异常原因
    NSString *reason = [exception reason];
    //异常名称
    NSString *name = [exception name];
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason：%@\nException name：%@\nException stack：%@",name, reason, stackArray];
    log_error(exceptionInfo);
}

@end


