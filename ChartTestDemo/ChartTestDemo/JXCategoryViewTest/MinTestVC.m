//
//  MinTestVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/13.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "MinTestVC.h"
#import "JXCategoryView.h"
#import "JXPagingView.h"
#import "PagingViewTableHeaderView.h"
#import "TestListBaseView.h"
#import "PowerListView.h"
#import "HobbyListView.h"
#import "PartnerListView.h"
#import "JXCategoryViewTestVC.h"
#import "TestCollectionViewVC.h"

static const CGFloat JXTableHeaderViewHeight = 200;
static const CGFloat JXheightForHeaderInSection = 50;

@interface MinTestVC ()<TestListBaseViewDelegate,JXPagingViewDelegate>

@property (nonatomic, strong) JXPagingView *pagingView;
@property (nonatomic, strong) PagingViewTableHeaderView *userHeaderView;
@property (nonatomic, strong) JXCategoryTitleView *categoryView;
@property (nonatomic, strong) NSArray<TestListBaseView *> *listViewArray;
@property (nonatomic, strong) NSArray *titles;
@end

@implementation MinTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.titles = @[@"能力", @"爱好", @"队友"];
    self.title = @"个人中心";
    self.navigationController.navigationBar.translucent = NO;
    
    PowerListView *powerListView = [[PowerListView alloc] init];
    powerListView.delegate = self;
    
    HobbyListView *hobbyListView = [[HobbyListView alloc] init];
    hobbyListView.delegate = self;
    
    PartnerListView *partnerListView = [[PartnerListView alloc] init];
    partnerListView.delegate = self;
    
    self.listViewArray = @[powerListView, hobbyListView, partnerListView];
    
    self.userHeaderView = [[PagingViewTableHeaderView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXTableHeaderViewHeight)];
    
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, JXheightForHeaderInSection)];
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105.0/255.0 green:144.0/255.0 blue:239.0/255.0 alpha:1.0f];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineWidth = 30.0f;
    lineView.indicatorLineViewColor = [UIColor colorWithRed:105.0/255.0 green:144.0/255.0 blue:239.0/255.0 alpha:1.0f];
    self.categoryView.indicators = @[lineView];
    
    CGFloat lineHeight = 1.0f/[UIScreen mainScreen].scale;
    CALayer *lineLayer = [CALayer new];
    lineLayer.backgroundColor = [UIColor lightGrayColor].CGColor;
    lineLayer.frame = CGRectMake(0, self.categoryView.bounds.size.height - lineHeight, self.categoryView.bounds.size.width, lineHeight);
    [self.categoryView.layer addSublayer:lineLayer];
    
    self.pagingView = [[JXPagingView alloc] init:self];
    [self.view addSubview:self.pagingView];
    
    self.categoryView.contentScrollView = self.pagingView.listContainerView.collectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    self.pagingView.frame = self.view.bounds;
}
#pragma JXPagingViewDelegate
- (void)listViewDidScroll:(UIScrollView *)scrollView {
    [self.pagingView listViewDidScroll:scrollView];
}

- (void)testDidSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TestCollectionViewVC *testVC = [[TestCollectionViewVC alloc] init];
    [self.navigationController pushViewController:testVC animated:YES];
    
//    JXCategoryViewTestVC *testVC = [[JXCategoryViewTestVC alloc] init];
//    [self.navigationController pushViewController:testVC animated:YES];
}


#pragma TestListBaseViewDelegate
- (CGFloat)heightForHeaderInSection:(JXPagingView *)pagingView {
    return JXheightForHeaderInSection;
}

- (void)mainTableViewDidScroll:(UIScrollView *)scrollView {
    [self.userHeaderView scrollViewDidScroll:scrollView.contentOffset.y];
}

- (NSInteger)numberOfListViews:(JXPagingView *)pagingView {
    return self.titles.count;
}

- (UIView<JXPagingViewListViewDelegate> *)pagingView:(JXPagingView *)pagingView listViewInRow:(NSInteger)listViewInRow {
    return self.listViewArray[listViewInRow];
}

- (UIView *)tableHeaderView:(JXPagingView *)pagingView {
    return self.userHeaderView;
}

- (CGFloat)tableHeaderViewHeight:(JXPagingView *)pagingView {
    return JXTableHeaderViewHeight;
}

- (UIView *)viewForHeaderInSection:(JXPagingView *)pagingView {
    return self.categoryView;
}




@end
