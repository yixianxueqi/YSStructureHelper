//
//  YSDefineVariable.h
//  YSStructureHelperDemo
//
//  Created by Nigel on 2018/6/27.
//  Copyright © 2018年 develop. All rights reserved.
//

#ifndef YSDefineVariable_h
#define YSDefineVariable_h

// 屏幕宽度
#define kScreenWidth ([UIScreen mainScreen].bounds.size.width)
// 屏幕高度
#define kScreenHeight ([UIScreen mainScreen].bounds.size.height)

// 判断是否是iPhone X
#define kIsiPhoneX (kScreenWidth == 375.f && kScreenHeight == 812.f)

// 导航栏高度
#define kNavHeight (kIsiPhoneX ? 88.f : 64.f)
// tabbar高度
#define kTabbarHeight (kIsiPhoneX ? 83.f : 49.f)
// 状态栏高度
#define kStateBarHeight (kIsiPhoneX ? 44.f : 20.f)




#endif /* YSDefineVariable_h */
