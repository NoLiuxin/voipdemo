//
//  Person.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/8.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "Person.h"

@implementation Person
//归档（序列化）
- (void)encodeWithCoder:(NSCoder *)aCoder{
    
    [aCoder encodeInteger:self.age forKey:@"age"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
    [aCoder encodeObject:self.clothing forKey:@"clothing"];
    [aCoder encodeBool:self.isBig forKey:@"isBig"];
    [aCoder encodeFloat:self.stature forKey:@"stature"];
    [aCoder encodeInteger:self.income forKey:@"income"];
}
//反归档（反序列化）
- (nullable instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super init];
    if (self != nil) {
        self.age = [aDecoder decodeIntForKey:@"age"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        self.clothing = [aDecoder decodeObjectForKey:@"clothing"];
        self.isBig = [aDecoder decodeBoolForKey:@"isBig"];
        self.stature = [aDecoder decodeFloatForKey:@"stature"];
        self.income = [aDecoder decodeIntForKey:@"income"];
    }
    return self;
}
@end
