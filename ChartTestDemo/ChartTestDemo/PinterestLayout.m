//
//  PinterestLayout.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/26.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "PinterestLayout.h"

/** 默认的列数 */
static const NSInteger XMGDefaultColumnCount = 3;
/** 每一列之间的间距 */
static const CGFloat XMGDefaultColumnMargin = 10;
/** 每一行之间的间距 */
static const CGFloat XMGDefaultRowMargin = 10;
/** 边缘间距 */
static const UIEdgeInsets XMGDefaultEdgeInsets = {10, 10, 10, 10};

@interface PinterestLayout()

/** 存放所有cell的布局属性 */
@property (nonatomic, strong) NSMutableArray *attrsArray;
/** 存放所有列的当前高度 */
@property (nonatomic, strong) NSMutableArray *columnHeights;
/** 内容的高度 */
@property (nonatomic, assign) CGFloat contentHeight;

//这里方法为了简化 数据处理(通过getter方法来实现)
- (CGFloat)rowMargin;
- (CGFloat)columnMargin;
- (NSInteger)columnCount;
- (UIEdgeInsets)edgeInsets;
@end
@implementation PinterestLayout

- (NSMutableArray *)attrsArray
{
    if(!_attrsArray){
        _attrsArray=[[NSMutableArray alloc] init];
    }
    return _attrsArray;
}
- (NSMutableArray *)columnHeights
{
    if(!_columnHeights){
        _columnHeights=[[NSMutableArray alloc] init];
    }
    return _columnHeights;
}
#pragma mark - 常见数据处理
- (NSInteger)columnCount{
    //如果delegate方法没有实现的话就使用代理方法 否则就使用默认值 然后通过getter方法来判断 来简化代码
    if ([self.delegate respondsToSelector:@selector(columnCountInWaterflowLayout:)]) {
        return [self.delegate columnCountInWaterflowLayout:self];
    } else {
        return XMGDefaultColumnCount;
    }
}
- (UIEdgeInsets)edgeInsets{
    //如果delegate方法没有实现的话就使用代理方法 否则就使用默认值 然后通过getter方法来判断 来简化代码
    if ([self.delegate respondsToSelector:@selector(edgeInsetsInWaterflowLayout:)]) {
        return [self.delegate edgeInsetsInWaterflowLayout:self];
    } else {
        return XMGDefaultEdgeInsets;
    }
}
- (CGFloat)rowMargin
{
    //如果delegate方法没有实现的话就使用代理方法 否则就使用默认值 然后通过getter方法来判断 来简化代码
    if ([self.delegate respondsToSelector:@selector(rowMarginInWaterflowLayout:)]) {
        return [self.delegate rowMarginInWaterflowLayout:self];
    } else {
        return XMGDefaultRowMargin;
    }
}
- (CGFloat)columnMargin{
    //如果delegate方法没有实现的话就使用代理方法 否则就使用默认值 然后通过getter方法来判断 来简化代码
    if ([self.delegate respondsToSelector:@selector(columnMarginInWaterflowLayout:)]) {
        return [self.delegate columnMarginInWaterflowLayout:self];
    } else {
        return XMGDefaultColumnMargin;
    }
}
/**
 * 初始化
 */
- (void)prepareLayout
{
    [super prepareLayout];
    //先初始化内容的高度为0
    self.contentHeight = 0;
    // 清除以前计算的所有高度
    [self.columnHeights removeAllObjects];
    //先初始化  存放所有列的当前高度 3个值
    for (NSInteger i = 0; i < self.columnCount; i++) {
        [self.columnHeights addObject:@(self.edgeInsets.top)];
    }
    
    // 清除之前所有的布局属性
    [self.attrsArray removeAllObjects];
    // 开始创建每一个cell对应的布局属性
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    for (NSInteger i = 0; i < count; i++) {
        // 创建位置
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        // 获取indexPath位置cell对应的布局属性
        UICollectionViewLayoutAttributes *attrs = [self layoutAttributesForItemAtIndexPath:indexPath];
        [self.attrsArray addObject:attrs];
    }
}
/**
 * 决定cell的排布
 */
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return self.attrsArray;
}

/**
 * 返回indexPath位置cell对应的布局属性
 */
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 创建布局属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    
    // collectionView的宽度
    CGFloat collectionViewW = self.collectionView.frame.size.width;
    
    // 设置布局属性的frame
    CGFloat w = (collectionViewW - self.edgeInsets.left - self.edgeInsets.right - (self.columnCount - 1) * self.columnMargin) / self.columnCount;
    CGFloat h = [self.delegate waterflowLayout:self heightForItemAtIndex:indexPath.item itemWidth:w];
    
    // 找出高度最短的那一列
    //找出来最短后 就把下一个cell 添加到低下
    NSInteger destColumn = 0;
    CGFloat minColumnHeight = [self.columnHeights[0] doubleValue];
    for (NSInteger i = 1; i < self.columnCount; i++) {
        // 取得第i列的高度
        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
        
        if (minColumnHeight > columnHeight) {
            minColumnHeight = columnHeight;
            destColumn = i;
        }
    }
    
    CGFloat x = self.edgeInsets.left + destColumn * (w + self.columnMargin);
    CGFloat y = minColumnHeight;
    if (y != self.edgeInsets.top) {
        y += self.rowMargin;
    }
    attrs.frame = CGRectMake(x, y, w, h);
    
    // 更新最短那列的高度
    self.columnHeights[destColumn] = @(CGRectGetMaxY(attrs.frame));
    
    // 记录内容的高度
    CGFloat columnHeight = [self.columnHeights[destColumn] doubleValue];
    //找出最高的高度
    if (self.contentHeight < columnHeight) {
        self.contentHeight = columnHeight;
    }
    return attrs;
}

/*!
 *  返回值就是这个CollectionView的contensize 因为CollectionView也是ScrollView的子类
 */
- (CGSize)collectionViewContentSize
{
    //    CGFloat maxColumnHeight = [self.columnHeights[0] doubleValue];
    //    for (NSInteger i = 1; i < self.columnCount; i++) {
    //        // 取得第i列的高度
    //        CGFloat columnHeight = [self.columnHeights[i] doubleValue];
    //
    //        if (maxColumnHeight < columnHeight) {
    //            maxColumnHeight = columnHeight;
    //        }
    //    }
    return CGSizeMake(0, self.contentHeight + self.edgeInsets.bottom);
}

@end
