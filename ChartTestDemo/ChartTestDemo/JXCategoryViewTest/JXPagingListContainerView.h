//
//  JXPagingListContainerView.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagingMainTableView.h"
@class JXPagingListContainerView;

@protocol JXPagingListContainerViewDelegate <NSObject>
- (NSInteger)numberOfRows:(JXPagingListContainerView *)listContainerView;

- (UIView *)listContainerView:(JXPagingListContainerView *)listContainerView viewForListInRow:(NSInteger)viewForListInRow;

@end;
@interface JXPagingListContainerView : UIView

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, weak) id<JXPagingListContainerViewDelegate> delegate;
@property (nonatomic, strong) JXPagingMainTableView *mainTableView;

- (instancetype)init:(id<JXPagingListContainerViewDelegate>)delegate;
- (void)reloadData;
@end
