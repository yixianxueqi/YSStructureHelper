//
//  UIViewController+LifeCycle.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 此类别主要监测控制器的生命周期
 利用三方库Aspects对生命周期方法挂钩，AOP:面向切面，
 达到无继承、无侵入即对该工程下所有UIViewController生效
 */
@interface UIViewController (LifeCycle)

@end
