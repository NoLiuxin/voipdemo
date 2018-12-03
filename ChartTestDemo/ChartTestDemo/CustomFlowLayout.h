//
//  CustomFlowLayout.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/25.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomFlowLayout;

NS_ASSUME_NONNULL_BEGIN
@protocol CustomFlowLayoutDelegate <NSObject>

- (CGFloat)waterFlowLayout:(CustomFlowLayout *)waterFlowLayout indexPath:(NSIndexPath *)indexPath;

@end;
@interface CustomFlowLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<CustomFlowLayoutDelegate> delegate;

/// 布局frame数组
@property (nonatomic, strong) NSMutableArray<UICollectionViewLayoutAttributes *> *layoutAttributeArray;

/// 每列的高度
@property (nonatomic, strong) NSMutableArray *yArray;
@end

NS_ASSUME_NONNULL_END
