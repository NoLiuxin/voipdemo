//
//  TestListBaseView.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/14.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "TestListBaseView.h"

@interface TestListBaseView()<UITableViewDelegate, UITableViewDataSource>

@end
@implementation TestListBaseView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        self.tableView.backgroundColor = [UIColor whiteColor];
        self.tableView.tableFooterView = [UIView new];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        [self.tableView registerClass:[UITableViewCell classForCoder] forCellReuseIdentifier:@"cell"];
        [self addSubview:self.tableView];
    }
    
    return self;
}
- (void)layoutSubviews{
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.dataSource[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate testDidSelectRowAtIndexPath:indexPath];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.delegate listViewDidScroll:scrollView];
}
- (UIScrollView *)scrollView{
    return self.tableView;
}
@end
