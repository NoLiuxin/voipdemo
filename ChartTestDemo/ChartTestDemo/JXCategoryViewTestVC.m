//
//  JXCategoryViewTestVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/21.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "JXCategoryViewTestVC.h"
#import "JXCategoryView.h"

#define WindowsSize [UIScreen mainScreen].bounds.size

@interface JXCategoryViewTestVC ()<JXCategoryViewDelegate>

@property (nonatomic, strong) JXCategoryTitleView *categoryView;

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIScrollView *mainScrollView;
@end

@implementation JXCategoryViewTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"JXCategoryViewTestVC";
    self.view.backgroundColor = [UIColor whiteColor];
    self.titles = @[@"呵呵哒", @"曹景坤集合", @"小泽玛利亚",@"诺诺亚索罗",@"乔巴"];
    
    
    /*
     defaultSelectedIndex    默认选中的index，用于初始化时指定选中某个index
     selectedIndex    只读属性，当前选中的index
     cellWidth    cell的宽度，默认：JXCategoryViewAutomaticDimension
     cellSpacing    cell之间的间距，默认20
     cellWidthIncrement    cell宽度的补偿值，默认0
     averageCellSpacingEnabled    当item内容总宽度小于JXCategoryBaseView的宽度，是否将cellSpacing均分。默认为YES。
     contentScrollView    需要关联的contentScrollView，内部监听contentOffset
     
     Cell样式常用属性说明
     属性    说明
     titleColor    titleLabel未选中颜色 默认：[UIColor blackColor]
     titleSelectedColor    titleLabel选中颜色 默认：[UIColor redColor]
     titleFont    titleLabel的字体 默认：[UIFont systemFontOfSize:15]
     titleColorGradientEnabled    title的颜色是否渐变过渡 默认：NO
     titleLabelMaskEnabled    titleLabel是否遮罩过滤 默认：NO
     titleLabelZoomEnabled    titleLabel是否缩放 默认：NO
     titleLabelZoomScale    citleLabel缩放比例 默认：1.2
     imageZoomEnabled    imageView是否缩放 默认：NO
     imageZoomScale    imageView缩放比例 默认：1.2
     separatorLineShowEnabled    cell分割线是否展示 默认：NO (颜色、宽高可以设置)
     JXCategoryTitleImageType    图片所在位置：上面、左边、下面、右边 默认：左边
     */
    self.categoryView = [[JXCategoryTitleView alloc] initWithFrame:CGRectMake(0, 0, WindowsSize.width, 50)];
    self.categoryView.delegate = self;
    self.categoryView.titles = self.titles;
    self.categoryView.backgroundColor = [UIColor whiteColor];
    self.categoryView.titleSelectedColor = [UIColor colorWithRed:105.0/255.0 green:144.0/255.0 blue:239.0/255.0 alpha:1.0f];
    self.categoryView.titleColor = [UIColor blackColor];
    self.categoryView.titleColorGradientEnabled = YES;
    //self.categoryView.cellWidth = JXCategoryViewAutomaticDimension;
    
    /*
     JXCategoryIndicatorComponentView.componentPosition    指示器的位置 默认：Bottom
     JXCategoryIndicatorComponentView.scrollEnabled    手势滚动、点击切换的时候，是否允许滚动，默认YES
     JXCategoryIndicatorLineView.lineStyle    普通、京东、爱奇艺效果 默认：Normal
     JXCategoryIndicatorLineView.lineScrollOffsetX    爱奇艺效果专用，line滚动时x的偏移量，默认为10；
     JXCategoryIndicatorLineView.indicatorLineWidth    默认JXCategoryViewAutomaticDimension（与cellWidth相等）
     JXCategoryIndicatorLineView.indicatorLineViewHeight    默认：3
     JXCategoryIndicatorLineView.indicatorLineViewCornerRadius    默认JXCategoryViewAutomaticDimension （等于self.indicatorLineViewHeight/2）
     JXCategoryIndicatorLineView.indicatorLineViewColor    默认为[UIColor redColor]
     JXCategoryIndicatorTriangleView.triangleViewSize    默认：CGSizeMake(14, 10)
     JXCategoryIndicatorTriangleView.triangleViewColor    默认为[UIColor redColor]
     JXCategoryIndicatorImageView.indicatorImageView    设置image
     JXCategoryIndicatorImageView.indicatorImageViewRollEnabled    是否允许滚动，默认：NO
     JXCategoryIndicatorImageView.indicatorImageViewSize    默认：CGSizeMake(30, 20)
     JXCategoryIndicatorBackgroundView.backgroundViewWidth    默认JXCategoryViewAutomaticDimension（与cellWidth相等）
     JXCategoryIndicatorBackgroundView.backgroundViewWidthIncrement    宽度增量补偿，因为backgroundEllipseLayer一般会比实际内容大一些。默认10
     JXCategoryIndicatorBackgroundView.backgroundViewHeight    默认JXCategoryViewAutomaticDimension（与cell高度相等）
     JXCategoryIndicatorBackgroundView.backgroundViewCornerRadius    默认JXCategoryViewAutomaticDimension(即backgroundViewHeight/2)
     JXCategoryIndicatorBackgroundView.backgroundViewColor    默认为[UIColor redColor]
     JXCategoryIndicatorBallView.ballViewSize    默认：CGSizeMake(15, 15)
     JXCategoryIndicatorBallView.ballScrollOffsetX    小红点的偏移量 默认：20
     JXCategoryIndicatorBallView.ballViewColor    默认为[UIColor redColor]
     */
    //lineView
    JXCategoryIndicatorLineView *lineView = [[JXCategoryIndicatorLineView alloc] init];
    lineView.indicatorLineViewColor = [UIColor purpleColor];
    //lineView.indicatorLineWidth = JXCategoryViewAutomaticDimension;
    lineView.indicatorLineWidth = 30.0f;
    lineView.lineStyle = JXCategoryIndicatorLineStyle_IQIYI;
    
//    //backgroundView
//    JXCategoryIndicatorBackgroundView *backgroundView = [[JXCategoryIndicatorBackgroundView alloc] init];
//    backgroundView.backgroundViewColor = [UIColor redColor];
//    backgroundView.backgroundViewWidth = JXCategoryViewAutomaticDimension;
//    self.categoryView.indicators = @[lineView, backgroundView];
    self.categoryView.indicators = @[lineView];
    [self.view addSubview:self.categoryView];
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 50, WindowsSize.width, WindowsSize.height-64-50)];
    self.mainScrollView.backgroundColor = [UIColor whiteColor];
    self.mainScrollView.contentSize = CGSizeMake(self.titles.count*WindowsSize.width, 0);
    self.mainScrollView.pagingEnabled = YES;
    [self.view addSubview:self.mainScrollView];
    
    self.categoryView.contentScrollView = self.mainScrollView;
    
    for (int i=0; i<self.titles.count; i++) {
        UIView *testView = [[UIView alloc] init];
        testView.frame = CGRectMake(WindowsSize.width*i, 0, WindowsSize.width, self.mainScrollView.frame.size.height);
        switch (i) {
            case 0:
                testView.backgroundColor = [UIColor redColor];
                break;
            case 1:
                testView.backgroundColor = [UIColor yellowColor];
                break;
            case 2:
                testView.backgroundColor = [UIColor blueColor];
                break;
            case 3:
                testView.backgroundColor = [UIColor purpleColor];
                break;
            default:
                break;
        }
        [self.mainScrollView addSubview:testView];
    }
    
}
/**
 点击选择或者滚动选中都会调用该方法，如果外部不关心具体是点击还是滚动选中的，只关心选中这个事件，就实现该方法。
 
 @param categoryView categoryView description
 @param index 选中的index
 */
- (void)categoryView:(JXCategoryBaseView *)categoryView didSelectedItemAtIndex:(NSInteger)index{
    NSLog(@"_________滚动或点击的Index%ld",(long)index);
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
