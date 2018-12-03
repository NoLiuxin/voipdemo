//
//  JXPagingView.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagingMainTableView.h"
#import "JXPagingListContainerView.h"
#import "PagingViewTableHeaderView.h"

@class JXPagingView;

@protocol JXPagingViewListViewDelegate <NSObject>

@property (nonatomic, strong) UIScrollView *scrollView;
@end
@protocol JXPagingViewDelegate <NSObject>

/// tableHeaderView的高度
///
/// - Parameter pagingView: JXPagingViewView
/// - Returns: height
- (CGFloat)tableHeaderViewHeight:(JXPagingView *)pagingView;

/// 返回tableHeaderView
///
/// - Parameter pagingView: JXPagingViewView
/// - Returns: view
- (UIView *)tableHeaderView:(JXPagingView *)pagingView;

/// 返回悬浮HeaderView的高度。
///
/// - Parameter pagingView: JXPagingViewView
/// - Returns: height
- (CGFloat)heightForHeaderInSection:(JXPagingView *)pagingView;


/// 返回悬浮HeaderView。我用的是自己封装的JXCategoryView（Github:https://github.com/pujiaxin33/JXCategoryView），你也可以选择其他的三方库或者自己写
///
/// - Parameter pagingView: JXPagingViewView
/// - Returns: view
- (UIView *)viewForHeaderInSection:(JXPagingView *)pagingView;


/// 底部listView的条数
///
/// - Parameter pagingView: JXPagingViewView
/// - Returns: count
- (NSInteger)numberOfListViews:(JXPagingView *)pagingView;


/// 返回对应index的listView，需要是UIView的子类，且要遵循JXPagingViewListViewDelegate。
/// 这里要求返回一个UIView而不是一个UIScrollView，因为listView可能并不只是一个单纯的UITableView或UICollectionView，可能还会有其他的子视图。
///
/// - Parameters:
///   - pagingView: JXPagingViewView
///   - row: row
/// - Returns: view
- (UIView<JXPagingViewListViewDelegate> *)pagingView:(JXPagingView *)pagingView listViewInRow:(NSInteger)listViewInRow;


/// mainTableView的滚动回调，用于实现头图跟随缩放
//
/// - Parameter scrollView: JXPagingViewMainTableView
- (void)mainTableViewDidScroll:(UIScrollView *)scrollView;
@end

@interface JXPagingView : UIView

@property (nonatomic, weak) id<JXPagingViewDelegate> delegate;
@property (nonatomic, strong) JXPagingMainTableView *mainTableView;
@property (nonatomic, strong) JXPagingListContainerView *listContainerView;
@property (nonatomic, strong) UIScrollView *currentScrollingListView;

- (instancetype)init:(id<JXPagingViewDelegate>)delegate;

- (void)listViewDidScroll:(UIScrollView *)scrollView;

- (void)reloadData;
@end
