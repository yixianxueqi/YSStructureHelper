//
//  YSLogger.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/6.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

/**
 日志组件
 主要是对三方日志 CocoaLumberjack 的封装
 */

#define log_verbose(...) DDLogVerbose(__VA_ARGS__)
#define log_debug(...) DDLogDebug(__VA_ARGS__)
#define log_info(...) DDLogInfo(__VA_ARGS__)
#define log_warn(...) DDLogWarn(__VA_ARGS__)
#define log_error(...) DDLogError(__VA_ARGS__)

/*
 *  默认调式模式 是DDLogLevelVerbose级别
 *     开发模式 是DDLogLevelInfo级别
 */
#ifdef DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelInfo;
#endif

@protocol YSLoggerRollFileDelegate <NSObject>

@optional
/**
 当文件达到抛出时间后，抛出archive的日志文件路径
 @note: 此处你可以对该日志文件进行处理：比如回传服务器进行日志分析
 @param path 文件路径
 */
- (void)getRollLogFileDidArchivePath:(NSString *)path;

@end

@interface YSLogger : NSObject

@property (nonatomic, weak) id<YSLoggerRollFileDelegate> delegate;

/**
 获取日志单例对象

 @return YSLogger
 */
+ (instancetype)shareLogger;

/**
 设置日志格式

 @param format DDLogFormatter protocol
 */
+ (void)setLogFormat:(id<DDLogFormatter>)format;

/**
 *  设置写入文件的日志等级,同时将符合等级的日志写入文件内
 *
 *  @param level DDLogLevel
 */
+ (void)setFileLogLevel:(DDLogLevel)level;


/**
 获取日志文件所在目录
 @note: 在设置写入文件后可用
 @return NSString
 */
- (NSString *)getLogFileDirectory;

/**
 获取每个日志文件路径
 @note: 在设置写入文件后可用
 @return NSArray<NSString *>
 */
- (NSArray<NSString *> *)getLogFilePath;



@end
