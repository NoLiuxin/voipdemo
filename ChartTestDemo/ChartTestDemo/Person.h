//
//  Person.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/8.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject<NSCoding>

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) int age;
@property (nonatomic, strong) NSString *clothing;
@property (nonatomic, assign) BOOL isBig;
@property (nonatomic, assign) float stature;
@property (nonatomic, assign) NSInteger income;
@end
