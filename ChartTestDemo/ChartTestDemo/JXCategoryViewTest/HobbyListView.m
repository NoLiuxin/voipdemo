//
//  HobbyListView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/14.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "HobbyListView.h"

@implementation HobbyListView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.dataSource = @[@"吃烤肉", @"吃鸡腿肉", @"吃牛肉", @"各种肉"];
    }
    return self;
}

@end
