//
//  TestCollectionViewVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/9/25.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#define WindowsSizeBounds [UIScreen mainScreen].bounds.size

#define MainWindows [[[UIApplication sharedApplication] delegate] window]

#import "TestCollectionViewVC.h"
#import "TestCollectionViewCell.h"
#import "CustomFlowLayout.h"
#import "PinterestLayout.h"

@interface TestCollectionViewVC ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,PinterestLayoutDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *testCollectionView;

@property (nonatomic, strong) NSMutableArray *dataArr;
@end

@implementation TestCollectionViewVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];

    self.dataArr = [[NSMutableArray alloc] initWithObjects:@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2",@"2", nil];
//    PinterestLayout *testLayout = [[PinterestLayout alloc] init];
//    testLayout.delegate = self;
    CustomFlowLayout *testLayout = [[CustomFlowLayout alloc] init];
//    //设置行与行之间的间距最小距离
//    testLayout.minimumLineSpacing = 5.0f;
//    //设置列与列之间的间距最小距离
//    testLayout.minimumInteritemSpacing = 0.0f;
//    //设置每个item的大小
//    testLayout.itemSize = CGSizeMake(120, 120);
//    //设置每个Item的估计大小，一般不需要设置
//    //testLayout.estimatedItemSize = CGSizeMake(10, 10);
//    //设置布局方向
//    testLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    
//    typedef NS_ENUM(NSInteger, UICollectionViewScrollDirection) {
//
//        UICollectionViewScrollDirectionVertical,//水平布局
//
//        UICollectionViewScrollDirectionHorizontal//垂直布局
//
//    };
    
//    设置头视图尺寸大小
//
//    @property (nonatomic) CGSize headerReferenceSize;
//
//    设置尾视图尺寸大小
//
//    @property (nonatomic) CGSize footerReferenceSize;
    
//    设置分区的EdgeInset
//
//    @property (nonatomic) UIEdgeInsets sectionInset;
//    这个属性可以设置分区的偏移量，例如我们在刚才的例子中添加如下设置：
//
//    layout.sectionInset = UIEdgeInsetsMake(20, 20, 20, 20);
    
//    下面这两个方法设置分区的头视图和尾视图是否始终固定在屏幕上边和下边
//
//    @property (nonatomic) BOOL sectionHeadersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);
//
//    @property (nonatomic) BOOL sectionFootersPinToVisibleBounds NS_AVAILABLE_IOS(9_0);
    
    
    self.testCollectionView.collectionViewLayout = testLayout;
    self.testCollectionView.delegate = self;
    self.testCollectionView.dataSource = self;
    
    [self.testCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([TestCollectionViewCell class]) bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"TestCollectionViewCellID"];
    [self.view addSubview:self.testCollectionView];
}
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    [self.navigationController setNavigationBarHidden:YES animated:YES];
//}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    if (self.navigationController.navigationBar.translucent) {
        [self.navigationController.navigationBar setBackgroundColor:[UIColor purpleColor]];
    }else{
        //UIBarMetricsDefault 缺省值 UIBarMetricsCompact 横屏样式  UIBarMetricsDefaultPrompt和UIBarMetricsCompactPrompt是有promt的两种样式
        [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    //是指透明，就好比我们可以透过一面干净的玻璃清楚的看到外面的风景。
    self.navigationController.navigationBar.translucent = YES;
    //是指不透明，就好比我们透过一个堵石墙是看不见任何外面的东西，眼前看到的只有这面墙。
    self.navigationController.navigationBar.opaque = YES;
    
    //那么 edgesForExtendedLayout 是为了解决 UIViewController 与 UINavigationController 的对齐问题，它会影响 UIViewController 的实际大小，例如 edgesForExtendedLayout 的值为 UIRectEdgeAll 时，UIViewController 会占据整个屏幕的大小。
    //self.navigationController.edgesForExtendedLayout = UIRectEdgeAll;
    //当 UIView 是一个 UIScrollView 类或者子类时，automaticallyAdjustsScrollViewInsets 是为了调整这个 UIScrollView 与 UINavigationController 的对齐问题，这个属性并不会调整 UIViewController 的大小。
    //对于 UIView 是一个 UIScrollView 类或者子类且导航栏的背景色是不透明的状态时，我们会发现使用 edgesForExtendedLayout 来调整 UIViewController 的大小是无效的，这时候你必须使用 extendedLayoutIncludesOpaqueBars 来调整 UIViewController 的大小，可以认为 extendedLayoutIncludesOpaqueBars 是基于 automaticallyAdjustsScrollViewInsets 诞生的，这也是为什么经常会看到这两个 API 会同时使用。
//    if (@available(iOS 11.0, *)) {
//        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
//    } else {
//        self.automaticallyAdjustsScrollViewInsets = NO;
//    }
    
    self.navigationController.navigationBar.backIndicatorImage = [UIImage imageNamed:@"backArrow"];
    self.navigationController.navigationBar.backIndicatorTransitionMaskImage = [UIImage imageNamed:@"backArrowMask"];

}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArr.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TestCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TestCollectionViewCellID" forIndexPath:indexPath];
    
    return cell;
}
#pragma mark ----  点击item的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    [self.dataArr removeObjectAtIndex:indexPath.item];
//    //TODO:  这个方法 特别注意 删除item的方法
//    [self.testCollectionView deleteItemsAtIndexPaths:@[indexPath]];
}

- (CGFloat)waterflowLayout:(PinterestLayout *)waterflowLayout heightForItemAtIndex:(NSUInteger)index itemWidth:(CGFloat)itemWidth{
    return 100 + (arc4random() % 150);
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
