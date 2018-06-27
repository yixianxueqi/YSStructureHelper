//
//  Header.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2017/12/7.
//  Copyright © 2017年 develop. All rights reserved.
//

/*
  设置全局先引入文件
 */
#ifndef Header_h
#define Header_h

#import "componentsServiceHeader.h"
#import "thirdPartHeader.h"


//替换系统的NSLog()
#if DEBUG
#define NSLog(...) log_info(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#endif /* Header_h */
