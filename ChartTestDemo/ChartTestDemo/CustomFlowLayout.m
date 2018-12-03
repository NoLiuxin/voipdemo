//
//  CustomFlowLayout.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/25.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#define COLS 4.0f
#import "CustomFlowLayout.h"

@interface CustomFlowLayout()

@property(nonatomic,strong)NSMutableArray * attrsArr;
@end
@implementation CustomFlowLayout
-(NSMutableArray *)attrsArr
{
    if(!_attrsArr){
        _attrsArr=[[NSMutableArray alloc] init];
    }
    return _attrsArr;
}
- (instancetype)init{
    self = [super init];
    if (self) {
        self.minimumLineSpacing = 0.0f;
        //设置列与列之间的间距最小距离
        //self.minimumInteritemSpacing = 0.0f;
        //设置每个item的大小
        self.itemSize = CGSizeMake(120, 180);
        //设置每个Item的估计大小，一般不需要设置
        //testLayout.estimatedItemSize = CGSizeMake(10, 10);
        //设置布局方向
        self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        self.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    }
    return self;
}
//-(void)prepareLayout
//{
//    [super prepareLayout];
//    [self.attrsArr removeAllObjects];
//    [self creatAttrs];
//}
//-(void)creatAttrs{
//    //计算出每组有多少个
//    NSInteger  count=[self.collectionView numberOfItemsInSection:0];
//    /**
//     * 因为不是继承流水布局 UICollectionViewFlowLayout
//     * 所以我们需要自己创建 UICollectionViewLayoutAttributes
//     */
//    //如果是多组的话  需要2层循环
//    for (int i=0; i<count; i++) {
//        //创建UICollectionViewLayoutAttributes
//        NSIndexPath * indexPath = [NSIndexPath indexPathForItem:i inSection:0];
//        //这里需要 告诉 UICollectionViewLayoutAttributes 是哪里的attrs
//        UICollectionViewLayoutAttributes * attrs=[self layoutAttributesForItemAtIndexPath:indexPath];
//        [self.attrsArr addObject:attrs];
//    }
//}
//
//-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
//{
//    //TODO:  特别注意 在这个方法里 可以边滑动边刷新（添加） attrs 一劳永逸 如果只需要添加一次的话  可以把这些 prepareLayout方法中去
//    return self.attrsArr;
//}
//
//#pragma mark ---- 这个方法需要返回indexPath位置对应cell的布局属性
///**
// *  //TODO:  这个方法主要用于 切换布局的时候 如果不适用该方法 就不会切换布局的时候会报错
// *   reason: 'no UICollectionViewLayoutAttributes instance for -layoutAttributesForItemAtIndexPath: <NSIndexPath: 0xc000000000400016> {length = 2, path = 0 - 2}'
// */
//-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    //TODO: 主要是返回每个indexPath的attrs
//
//    //创建UICollectionViewLayoutAttributes
//    //这里需要 告诉 UICollectionViewLayoutAttributes 是哪里的attrs
//    //计算出每组有多少个
//    NSInteger  count=[self.collectionView numberOfItemsInSection:0];
//    //角度
//    CGFloat angle = 2* M_PI /count *indexPath.item;
//    //设置半径
//    CGFloat radius=100;
//    //CollectionView的圆心的位置
//    CGFloat Ox = self.collectionView.frame.size.width/2;
//    CGFloat Oy = self.collectionView.frame.size.height/2;
//    UICollectionViewLayoutAttributes * attrs=[UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
//    attrs.center =  CGPointMake(Ox+radius*sin(angle), Oy+radius*cos(angle));
//    if (count==1) {
//        attrs.size=CGSizeMake(200, 200);
//    }else{
//        attrs.size=CGSizeMake(50, 50);
//    }
//    return attrs;
//}
///**
// *  只要手一松开就会调用
// *  这个方法的返回值，就决定了CollectionView停止滚动时的偏移量
// *  proposedContentOffset这个是最终的 偏移量的值 但是实际的情况还是要根据返回值来定
// *  velocity  是滚动速率  有个x和y 如果x有值 说明x上有速度
// *  如果y有值 说明y上又速度 还可以通过x或者y的正负来判断是左还是右（上还是下滑动）  有时候会有用
// */
-(CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity{
    //计算出 最终显示的矩形框
    CGRect rect;
    rect.origin.x = proposedContentOffset.x;
    rect.origin.y = 0;
    rect.size = self.collectionView.frame.size;

    NSArray * array = [super layoutAttributesForElementsInRect:rect];

    NSLog(@"__________HUADONG OffSetX:%f",proposedContentOffset.x);
    // 计算CollectionView最中心点的x值 这里要求 最终的 要考虑惯性
    CGFloat centerX = 120.0f + proposedContentOffset.x;
    //存放的最小间距
    CGFloat minDelta = MAXFLOAT;
    for (UICollectionViewLayoutAttributes * attrs in array) {

        NSLog(@"===========Attrs centerX:%f",attrs.frame.origin.x-centerX);
        //整数绝对值
        if (ABS(minDelta)>ABS(attrs.frame.origin.x-centerX)) {
            minDelta = attrs.frame.origin.x - centerX;
        }
    }
    // 修改原有的偏移量
    proposedContentOffset.x += minDelta;
    //如果返回的时zero 那个滑动停止后 就会立刻回到原地
    return proposedContentOffset;
}

/**
 *  这个方法的返回值是一个数组(数组里存放在rect范围内所有元素的布局属性)
 *  这个方法的返回值  决定了rect范围内所有元素的排布（frame）
 */
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{   //获得super已经计算好的布局属性 只有线性布局才能使用
    NSArray * array = [super layoutAttributesForElementsInRect:rect];
    //计算CollectionView最中心的x值
//#warning 特别注意：
    CGFloat centetX = self.collectionView.contentOffset.x + self.collectionView.frame.size.width/2;
    for (UICollectionViewLayoutAttributes * attrs in array) {
        //CGFloat scale = arc4random_uniform(100)/100.0;
        //attrs.indexPath.item 表示 这个attrs对应的cell的位置
        NSLog(@" 第%zdcell--距离：%.1f",attrs.indexPath.item ,attrs.center.x - centetX);
        //cell的中心点x 和CollectionView最中心点的x值
        CGFloat delta = ABS(attrs.center.x - centetX);
        //根据间距值  计算cell的缩放的比例
        //这里scale 必须要 小于1
        CGFloat scale = 1 - delta/self.collectionView.frame.size.width;
        //设置缩放比例
        attrs.transform=CGAffineTransformMakeScale(scale, scale);
        attrs.alpha = scale;
    }
    return array;
}

/*!
 *  多次调用 只要滑出范围就会 调用
 *  当CollectionView的显示范围发生改变的时候，是否重新发生布局
 *  一旦重新刷新 布局，就会重新调用
 *  1.layoutAttributesForElementsInRect：方法
 *  2.preparelayout方法
 */
-(BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

@end
