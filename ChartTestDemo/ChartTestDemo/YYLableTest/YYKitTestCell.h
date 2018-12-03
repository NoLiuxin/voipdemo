//
//  YYKitTestCell.h
//  ChartTestDemo
//
//  Created by 刘新 on 2018/6/1.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YYKit/YYKit.h>
#import "TestListLayout.h"

@class YYKitTestCell;

@interface WBStatusProfileView : UIView
@property (nonatomic, strong) UIImageView *avatarView; ///< 头像
@property (nonatomic, strong) YYLabel *nameLabel;
@property (nonatomic, strong) YYLabel *sourceLabel;
@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *arrowButton;
@property (nonatomic, strong) UIButton *followButton;
@property (nonatomic, weak) YYKitTestCell *cell;
@end

@interface WBStatusToolbarView : UIView
@property (nonatomic, strong) UIButton *repostButton;
@property (nonatomic, strong) UIButton *commentButton;
@property (nonatomic, strong) UIButton *likeButton;

@property (nonatomic, strong) UIImageView *repostImageView;
@property (nonatomic, strong) UIImageView *commentImageView;
@property (nonatomic, strong) UIImageView *likeImageView;

@property (nonatomic, strong) YYLabel *repostLabel;
@property (nonatomic, strong) YYLabel *commentLabel;
@property (nonatomic, strong) YYLabel *likeLabel;

@property (nonatomic, strong) CAGradientLayer *line1;
@property (nonatomic, strong) CAGradientLayer *line2;
@property (nonatomic, strong) CALayer *topLine;
@property (nonatomic, strong) CALayer *bottomLine;
@property (nonatomic, weak) YYKitTestCell *cell;

- (void)setWithLayout:(TestListLayout *)layout;

@end

@interface WBStatusView : UIView

@property (nonatomic, strong) UIView *contentView;              // 容器
@property (nonatomic, strong) WBStatusProfileView *profileView; // 用户资料
@property (nonatomic, strong) YYLabel *textLabel;               // 文本
@property (nonatomic, strong) NSArray<UIView *> *picViews;      // 图片
@property (nonatomic, strong) WBStatusToolbarView *toolbarView; // 工具栏
@property (nonatomic, strong) UIButton *menuButton;             // 菜单按钮
@property (nonatomic, strong) UIButton *followButton;           // 关注按钮

@property (nonatomic, strong) TestListLayout *layout;
@property (nonatomic, weak) YYKitTestCell *cell;
@end

@protocol WBStatusCellDelegate;
@interface YYKitTestCell : UITableViewCell
@property (nonatomic, weak) id<WBStatusCellDelegate> delegate;
@property (nonatomic, strong) WBStatusView *statusView;
- (void)setLayout:(TestListLayout *)layout;
@end

@protocol WBStatusCellDelegate <NSObject>
@optional
/// 点击了 Cell
- (void)cellDidClick:(YYKitTestCell *)cell;
/// 点击了Cell菜单
- (void)cellDidClickMenu:(YYKitTestCell *)cell;
/// 点击了关注
- (void)cellDidClickFollow:(YYKitTestCell *)cell;
/// 点击了转发
- (void)cellDidClickRepost:(YYKitTestCell *)cell;
/// 点击了评论
- (void)cellDidClickComment:(YYKitTestCell *)cell;
/// 点击了赞
- (void)cellDidClickLike:(YYKitTestCell *)cell;
/// 点击了用户
- (void)cell:(YYKitTestCell *)cell;
/// 点击了图片
- (void)cell:(YYKitTestCell *)cell didClickImageAtIndex:(NSUInteger)index;
@end
