//
//  TestListBaseView.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/14.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JXPagingView.h"
@class TestListBaseView;

@protocol TestListBaseViewDelegate <NSObject>

- (void)listViewDidScroll:(UIScrollView *)scrollView;

- (void)testDidSelectRowAtIndexPath:(NSIndexPath *)indexPath;

@end;
@interface TestListBaseView : UIView<JXPagingViewListViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray<NSString *>* dataSource;
@property (nonatomic, weak) id<TestListBaseViewDelegate> delegate;
@property (nonatomic, strong) UIScrollView *scrollView;
@end
