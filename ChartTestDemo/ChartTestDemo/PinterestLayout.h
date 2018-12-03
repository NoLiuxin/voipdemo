//
//  PinterestLayout.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/26.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
//前置声明
@class PinterestLayout;
//代理
@protocol PinterestLayoutDelegate <NSObject>

@required
//必须实现的代理方法
- (CGFloat)waterflowLayout:(PinterestLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth;
//可实现可不实现的代理方法 这个是通过代理调用的接口  也可以 通过set方法来实现接口
@optional
- (CGFloat)columnCountInWaterflowLayout:(PinterestLayout *)waterflowLayout;
- (CGFloat)columnMarginInWaterflowLayout:(PinterestLayout *)waterflowLayout;
- (CGFloat)rowMarginInWaterflowLayout:(PinterestLayout *)waterflowLayout;
- (UIEdgeInsets)edgeInsetsInWaterflowLayout:(PinterestLayout *)waterflowLayout;
@end
NS_ASSUME_NONNULL_BEGIN

@interface PinterestLayout : UICollectionViewFlowLayout

@property (nonatomic, weak) id<PinterestLayoutDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
