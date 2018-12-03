//
//  PagingViewTableHeaderView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "PagingViewTableHeaderView.h"

@implementation PagingViewTableHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"lufei.jpg"]];
        self.imageView.clipsToBounds = YES;
        self.imageView.frame = frame;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:self.imageView];
        
        self.imageViewFrame = self.imageView.frame;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, frame.size.height - 30, 200, 30)];
        label.font = [UIFont systemFontOfSize:20];
        label.text = @"Monkey·D·路飞";
        label.textColor = [UIColor redColor];
        [self addSubview:label];
    }
    
    return self;
}

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY{
    CGRect frame = self.imageViewFrame;
    frame.size.height -= contentOffsetY;
    frame.origin.y = contentOffsetY;
    self.imageView.frame = frame;
}

@end
