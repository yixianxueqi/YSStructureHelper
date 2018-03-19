//
//  YSDefineFunc.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/19.
//  Copyright © 2018年 develop. All rights reserved.
//

#ifndef YSDefineFunc_h
#define YSDefineFunc_h

/**
 将对象放入子线程异步销毁
 @note 该函数只是避免待销毁对象过大而阻塞主线程，因此放置在异步子线程内销毁；
       请确保待销毁对象的强引用只有此处，若仍有其它强引用存在，则无效。
 @param obj 待销毁对象
 @return nil
 */
#define trash(obj) \
dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{\
    (obj) = nil;\
})

/*
 强弱引用，常用来解决block循环引用问题
 例：weakObj(self);
    block = ^(){
        strongObj(self);
    }
 */
//弱引用
#define weakObj(obj) __weak typeof(obj) weak##obj = obj
//强引用
#define strongObj(obj) __strong typeof(obj) obj = weak##obj


/*
    颜色相关
 */
//设置颜色
#define RGBAColor(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]
//设置16进制颜色
#define XColor(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]


#endif /* YSDefineFunc_h */
