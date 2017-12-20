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
    
    
### HTTP

网络层以AFNetworking为核心，在此基础上添加了一些额外功能进行再封装而成。主要分为以下几点：
1.网络状态监测
2.网络数据缓存
3.POST/GE请求
4.流数据处理UPLOAD/DOWNLOAD
5.网络错误统一解析

* 网络状态监测 - UIApplication+NetworkStatus.h
网络状态是手机系统管理，但对于应用可设置是否允许访问移动网络和WIFI网络；因此，将对网络状态的监测以类别的提供属性方法的形式附加在UIApplication对象，使用时如下：

```
[[UIApplication sharedApplication] currentStatus]
```

获取网络状态。
也可以监听通知“YSNetworkStatusChangedNotification”实时获取网络状态的变化。
使用时需注意，在应用刚启动时监测获取是不准确的，应该延迟启动监测网络状态或稍后获取网络状态。

* 网络数据缓存 - YSNetworkCache.h
缓存的核心是以YYCache为内核，达到内存缓存和硬盘缓存。
缓存主要针对与POST/GET请求的缓存，缓存策略如下：

```
// 缓存策略
typedef NS_ENUM(NSInteger, YSNetworkCachePolicy) {

    /*
     总是使用缓存数据，无则请求数据
     */
    YSNetworkCachePolicy_cache = 1,
    /*
     优先使用缓存，其次去请求数据。
     若缓存存在，会返回两次数据，第一次为缓存数据，第二次为请求数据
     若缓存不存在，则只会返回一次数据，为请求数据
     */
    YSNetworkCachePolicy_cacheAndRequest,
    /*
     使用有限制的缓存，在一定时间内使用缓存数据，超出时间则是发起新的请求。
     例：在60s内重复请求同一接口，则使用缓存数据，超出60s后，则发起新的请求去请求数据，并更新缓存
     */
    YSNetworkCachePolicy_cacheWithLimitTime,
    /*
     总是发起请求
     */
    YSNetworkCachePolicy_request,
    /*
     无缓存策略
     */
    YSNetworkCachePolicy_none,
};
```
在请求时，选择合适的缓存策略为参数即可。

* POST/GE请求 - YSNetWork.h
    demo见YSNetworkDemoViewController。
    
* 流数据处理UPLOAD/DOWNLOAD - YSStreamNetwork.h
    demo见YSNetworkDemoViewController。
    
* 网络错误统一解析 - YSNetworkCache.h
    此处对常见网络错误进行了解析，转化为更加通俗易懂的描述。因为此处脱离了业务，所以仅仅只是示范性略大。
    可以修改此处，结合自身业务再定制为自身业务规则，使之适用于业务处理。

### future
     

