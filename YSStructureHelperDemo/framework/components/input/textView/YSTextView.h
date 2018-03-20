//
//  YSTextView.h
//  YSStructureHelperDemo
//
//  Created by 君若见故 on 2018/3/20.
//  Copyright © 2018年 develop. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 自定义textView，实现类似textField提示文字功能
 */
@interface YSTextView : UITextView

/**
 设置提示文字
 @note 字体大小随textView本身的font属性；避免偏移。
 @param placeHold 提示内容
 @param color 文字颜色
 */
- (void)setPlaceHold:(NSString *)placeHold color:(UIColor *)color;

@end
