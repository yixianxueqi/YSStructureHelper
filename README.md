[![Build Status](https://travis-ci.org/yixianxueqi/YSStructureHelper.svg?branch=master)](https://travis-ci.org/yixianxueqi/YSStructureHelper)

# YSStructureHelper

### 日志

首先添加了日志组件，作为通用基础功能组件，放在header.h文件全局引入。
该日志组件是基于CocoaLumberjack2.3.0版本封装，其中加入了崩溃日志捕获功能。
YSLogger为单例对象，初始化了日志功能，YSLogFormat是对日志输出格式进行了自定义。
可根据个人需求更改相应日志设置。

* 使用

    初始化: 
    
    ```
    YSLogger *logger = [YSLogger shareLogger];
    [YSLogger setFileLogLevel: ddLogLevel];
    ```
    可实现YSLoggerRollFileDelegate协议，当日志被抛出时可做处理.
    
    ```
    @interface AppDelegate()<YSLoggerRollFileDelegate>
    ...
    - (void)getRollLogFileDidArchivePath:(NSString *)path {
    //获取抛出的日志文件，可在此处理
    log_info(@"roll: %@",path);
    }
    ```

* 打印
    
    ```
    log_verbose(@"111");
    log_debug(@"222");
    log_info(@"333");
    log_warn(@"444");
    log_error(@"555");
    ```
    
* 注意
        目前默认为一周抛出一次，最多存在7个文件
        默认开发模式写入文件的等级为：verbose
        默认线上写入文件等级为：info
        可修改。
        

### future
     

