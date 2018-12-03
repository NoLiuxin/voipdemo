//
//  JXPagingMainTableView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "JXPagingMainTableView.h"

@implementation JXPagingMainTableView

////是否支持多手势触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
//是否允许多个手势识别器共同识别，一个控件的手势识别后是否阻断手势识别继续向下传播，默认返回NO；如果为YES，响应者链上层对象触发手势识别后，如果下层对象也添加了手势并成功识别也会继续执行，否则上层对象识别后则不再继续传播
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
   
    return [gestureRecognizer isKindOfClass:[UIPanGestureRecognizer classForCoder]]&&[otherGestureRecognizer isKindOfClass:[UIPanGestureRecognizer classForCoder]];
}

@end
