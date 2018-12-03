//
//  JXPagingView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "JXPagingView.h"
@interface JXPagingView()<UITableViewDelegate, UITableViewDataSource,JXPagingListContainerViewDelegate>

@end
@implementation JXPagingView

- (instancetype)init:(id<JXPagingViewDelegate>)delegate{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        self.delegate = delegate;
        [self initializeViews];
    }
    return self;
}

- (void)initializeViews{
    self.mainTableView = [[JXPagingMainTableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.mainTableView.showsVerticalScrollIndicator = NO;
    self.mainTableView.showsHorizontalScrollIndicator = NO;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.tableHeaderView = [self.delegate tableHeaderView:self];
    [self.mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cellID"];
    [self addSubview:self.mainTableView];
    
    self.listContainerView = [[JXPagingListContainerView alloc] init:self];
    self.listContainerView.mainTableView = self.mainTableView;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.mainTableView.frame = self.bounds;
}
- (void)listViewDidScroll:(UIScrollView *)scrollView{
    self.currentScrollingListView = scrollView;
    if (self.mainTableView.contentOffset.y < [self.delegate tableHeaderViewHeight:self]) {
        scrollView.contentOffset = CGPointZero;
        scrollView.showsVerticalScrollIndicator = NO;
    }else{
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate tableHeaderViewHeight:self]);
        scrollView.showsVerticalScrollIndicator = YES;
    }
}
- (void)reloadData{
    [self.mainTableView reloadData];
    [self.listContainerView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.bounds.size.height - [self.delegate heightForHeaderInSection:self];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellID" forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    self.listContainerView.frame = cell.contentView.bounds;
    [cell.contentView addSubview:self.listContainerView];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [self.delegate heightForHeaderInSection:self];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [self.delegate viewForHeaderInSection:self];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.delegate mainTableViewDidScroll:scrollView];
    if (self.currentScrollingListView !=nil && self.currentScrollingListView.contentOffset.y > 0) {
        //mainTableView的header已经滚动不见，开始滚动某一个listView，那么固定mainTableView的contentOffset，让其不动
        self.mainTableView.contentOffset = CGPointMake(0, [self.delegate tableHeaderViewHeight:self]);
    }
    
    if (scrollView.contentOffset.y < [self.delegate tableHeaderViewHeight:self]) {
        for (int i = 0; i < [self.delegate numberOfListViews:self]; i++) {
            UIView<JXPagingViewListViewDelegate> *listView = [self.delegate pagingView:self listViewInRow:i];
            listView.scrollView.contentOffset = CGPointZero;
        }
    }
}

- (NSInteger)numberOfRows:(JXPagingListContainerView *)listContainerView{
    return [self.delegate numberOfListViews:self];
}

- (UIView *)listContainerView:(JXPagingListContainerView *)listContainerView viewForListInRow:(NSInteger)viewForListInRow{
    return [self.delegate pagingView:self listViewInRow:viewForListInRow];
}
@end
