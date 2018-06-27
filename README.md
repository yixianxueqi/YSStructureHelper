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

* 提示图：UIView+ShowTipView

    对三方MBProgressHUD的封装，提供简便方法供业务方调用。
* Frame：UIView+Frame

	 提供常用坐标属性的快捷方法。
    
    
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

### AppStore相关
UIApplication+AppStore.h
提供三种方法：
1. 从App Store获取app相关信息；
2. 跳转至该app在App Store的详情页；
3. 应用内评价或跳转至app在App Store的评价页。
详情参见示例demo - YSAppInfoDemoViewController.h

### 其它类别

* UIApplication+Info.h

  提供访问App相关信息。例：app名称，版本号等。
  详情参见示例demo - YSDeviceInfoDemoViewController.h

* UIDevice+Info.h

	提供访问设备相关属性。例：电池电量相关，内存相关，存储相关，CPU相关等。
	详情参见示例demo - YSDeviceInfoDemoViewController.h
	
* NSNumber+Format.h
	
	提供数据格式化描述。
	
* NSFileManager+FileAssist.h

	提供偏好文件读写，沙盒目录快速获取以及简单文件操作相关。
	
* UIButton+Touch.h

	调整按钮点击区域。
	
* UIImage+Create.h

	通过颜色、view、layer生成图片。
	
	通过URL加载图片，利用ImageIO库，使其占用内存更低。
	
	调整UIImage尺寸，利用ImageIO库，使其占用内存更低。
	
* UIScrollView+YSEmptyConfig.h

  列表型视图无数据提示。针对三方<DZNEmptyDataSet>的封装。
  方便快捷区分网络错误提示和无内容提示，并加强了可定制型。若有其它需求，可进一步更改此源文件满足需求。
  demo见YSEmptyDemoViewController.h。

	
	
### 宏相关

* YSDefineFunc.h
	
	trash(obj)：异步子线程销毁对象；
	weakObj(obj)/strongObj(obj)：强弱引用对象；
	RGBAColor(r,g,b,a)：三原色颜色；
	XColor(rgbValue,a)：16进制颜色；
	
* YSDefineVariable.h

  kScreenWidth：屏幕宽度
  kScreenHeight：屏幕高度
  kIsiPhoneX：是否是iPhone X
  kNavHeight：导航栏高度
  kTabbarHeight：tabbar高度
  kStateBarHeight：状态栏高度
  

### 输入

* YSTextView.h

	UITextView子类，实现类似textfield的提示文字效果。
	
* YSDefaultTextViewDelegate.h

	UITextViewDelegate协议的实现对象，可设置正则校验、最大数量，以及获取输入回调；用来对输入内容的校验。

* YSDefauleTextFieldDelegate.h
	
	UITextFieldDelegate协议的实现对象，可设置正则校验、最大数量，以及获取输入回调；用来对输入内容的校验。
	
### GCD

* YSTimer.h
 
  GCD方式的定时器实现。
  
  demo见YSGCDDemoViewController.h。
  
* YSGCDGroup.h

  对于dispatch_group_t相关封装，使之使用起来更加方便。
  demo见YSGCDDemoViewController.h。
	
### future
     

