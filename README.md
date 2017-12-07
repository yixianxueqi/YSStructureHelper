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
        

### 生命周期监测
为解决继承带来的侵入，采用了aop的方式对相关生命周期的方法进行挂钩，达到监测生命周期的方案。
本方案采用Aspects进行hook方法，通过类别UIViewController+LifeCycle的方式，在+ (void)load方法时机对控制器相关方法进行挂钩。

```
  [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"%@ viewWillAppear",[aspectInfo.instance class]);
    } error:nil];

    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSLog(@"%@ viewWillDisappear", [aspectInfo.instance class]);
    } error:nil];

    [UIViewController aspect_hookSelector:NSSelectorFromString(@"dealloc") withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> aspectInfo) {
        NSLog(@"%@ dealloc", [aspectInfo.instance class]);
    } error:nil];
```
采用这种面向切面的方式，无侵入，只要导入该工程内，则自动获得生命周期监测方法。

### UIView
为避免继承带来的基类臃肿问题（因为在项目开发中，对基类的维护不到位，总会导致有东西就塞到基类，导致基类臃肿不堪，维护困难）,采用类别的方式为原有类进行方法扩充，也可采用关联的方式增加属性。

* 提示图：
    对三方MBProgressHUD的封装，提供简便方法供业务方调用。
    
### future
     

