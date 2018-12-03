//
//  TestProtocol.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/6/14.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TestProtocol <NSObject>
//默认就是required;
@required
- (void)requiredMethod;

@optional
- (void)optionalMethod;
@end
