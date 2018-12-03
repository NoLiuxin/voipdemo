//
//  PagingViewTableHeaderView.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PagingViewTableHeaderView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) CGRect imageViewFrame;

- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;
@end
