//
//  JXPagingListContainerView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "JXPagingListContainerView.h"
@interface JXPagingListContainerView()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@end
@implementation JXPagingListContainerView


- (instancetype)init:(id<JXPagingListContainerViewDelegate>)delegate{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = delegate;
        [self initializeViews];
    }
    return self;
}
- (void)initializeViews{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    layout.minimumLineSpacing = 0;
    layout.minimumInteritemSpacing = 0;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.pagingEnabled = YES;
    self.collectionView.bounces = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"CollectionViewCellID"];
    [self addSubview:self.collectionView];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}
- (void)reloadData{
    [self.collectionView reloadData];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.delegate numberOfRows:self];
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionViewCellID" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    UIView *listView = [self.delegate listContainerView:self viewForListInRow:indexPath.item];
    listView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:listView];
    
    return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.mainTableView.scrollEnabled = YES;
}
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    self.mainTableView.scrollEnabled = YES;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    self.mainTableView.scrollEnabled = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    self.mainTableView.scrollEnabled = NO;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return self.bounds.size;
}
@end
