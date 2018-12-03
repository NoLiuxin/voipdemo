//
//  TestEmptyDataSetVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/22.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "TestEmptyDataSetVC.h"
#import <DZNEmptyDataSet/UIScrollView+EmptyDataSet.h>
#import "YYKitTestListVC.h"

static  NSString *const rsa_public_key = @"-----BEGIN PUBLIC KEY-----\
MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDIlylEsP3EP+oAGk5sqopYkb5K\
DDstRMYKMSRP7T56ML4lwCNqhUmJgTtN3RqeZjxhtqtYk6gii2zqC3125GEeBbCq\
Wn7MeJumP/epZVjr24ReYnB5POtPytnyKS7S0qWmV1yUVcNAjxkTpD87vMQ9zN3p\
ZynpNZzDPio7rbIg3wIDAQAB\
-----END PUBLIC KEY-----";

static  NSString *const rsa_private_key = @"-----BEGIN RSA PRIVATE KEY-----\
MIICXgIBAAKBgQDIlylEsP3EP+oAGk5sqopYkb5KDDstRMYKMSRP7T56ML4lwCNq\
hUmJgTtN3RqeZjxhtqtYk6gii2zqC3125GEeBbCqWn7MeJumP/epZVjr24ReYnB5\
POtPytnyKS7S0qWmV1yUVcNAjxkTpD87vMQ9zN3pZynpNZzDPio7rbIg3wIDAQAB\
AoGBALZdJzm6J5wJ93XMdMw6Z7iKGBQ99nb7dYjCkJ7Rs+Fm+xhbDFfFgcuvX/k0\
MQUdMXwslK7c3xk45PYLKC+1BcykpbZPhpVRdJMTbIP/Ktv5fOhNAGx/z1TTvdAj\
Wx9FF7IvfZdAYtiP+BJXrwGkHWXOyAqhDVfg7BsTFrLieT4RAkEA/2bHvZG1qBpp\
I5MbQjaiIIRKqnCvSlwHPgzcllqMGO4I+pxEvbR81jWkAS1lpBRTLfygnsOCBtJM\
yHtItTP9uwJBAMkPf7eWRLXoywcQ9FibEbFWdyJEpfd+MFRrGunbD+z66UCZ0Zvz\
MYf9indMeHowkv64ekz8DudY2iCIy6A/pS0CQFHjjYWNs5YLqcxbPXE0fTU51Yri\
iIGqEjRmAVBABg10PPLFqhC9Tw2Ls2MhQCak0aq8BnABNa6kPTRGuyBGZEMCQQC7\
b5943rWfgC4FoGCqWaXc1OarI6Q1XYZgrJiien4WRrM8biliYQ1D4bE8FiYagz4G\
CKS7MCAUvFhdDCoIckzhAkEA30mCRWtbog0TnnmrcqFBuXADwghQqkIHsYYlqArM\
iPFKiyhcJv407paPnl4nKeF81eTCtR8dHoxUYmH0MjrpRw==\
-----END RSA PRIVATE KEY-----";

@interface TestEmptyDataSetVC ()<UITableViewDataSource,UITableViewDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>
{
    NSInteger inrRow;
}
@property (weak, nonatomic) IBOutlet UITableView *emptyDataSetTableView;
@property (nonatomic, strong) NSArray *testDataArray;
@property (nonatomic, assign) BOOL isLoding;
@end

@implementation TestEmptyDataSetVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"EmptyDataSet";
    self.emptyDataSetTableView.delegate = self;
    self.emptyDataSetTableView.dataSource = self;
    self.emptyDataSetTableView.tableFooterView = [UIView new];
    _emptyDataSetTableView.emptyDataSetSource = self;
    _emptyDataSetTableView.emptyDataSetDelegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *rightItem = nil;
    rightItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(shuffle:)];
    self.navigationItem.rightBarButtonItem = rightItem;
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)shuffle:(id)sender{
    self.isLoding = YES;
    [self.emptyDataSetTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLoding = NO;
        [self.emptyDataSetTableView reloadData];
    });
}
- (NSArray *)testDataArray{
    if (_testDataArray==nil) {
        _testDataArray = @[@{@"title":@"Airbnb",@"subTitle":@"Airbnb, Inc."},@{@"title":@"AppStore",@"subTitle":@"Apple, Inc."},@{@"title":@"Camera",@"subTitle":@"Apple, Inc."},@{@"title":@"Dropbox",@"subTitle":@"Dropbox, Inc."},@{@"title":@"Facebook",@"subTitle":@"Facebook, Inc."}];
    }
    return _testDataArray;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //return 0;
    if (self.isLoding) {
        return 0;
    }
    return self.testDataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cellID";
    cellID = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellID];
    }
    NSDictionary *dataDic = self.testDataArray[indexPath.row];
    cell.textLabel.text = dataDic[@"title"];
    cell.detailTextLabel.text = dataDic[@"subTitle"];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    YYKitTestListVC *yYKitTestListVC = [[YYKitTestListVC alloc] init];
    [self.navigationController pushViewController:yYKitTestListVC animated:YES];
}
#pragma mark - DZNEmptyDataSetSource Methods
- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = @"No Application Found";
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0, attributedString.length)];
    return attributedString;
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView
{
    NSString *text = [NSString stringWithFormat:@"There are no empty dataset examples for \"%@\".", @"😝😝😝"];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
    
    [attributedString addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:17.0] range:NSMakeRange(0, text.length)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor lightGrayColor] range:NSMakeRange(0, text.length)];
    return attributedString;
}

- (NSAttributedString *)buttonTitleForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *text = @"Search on the App Store";
    UIFont *font = [UIFont systemFontOfSize:16.0];
    UIColor *textColor = [UIColor blueColor];
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    [attributes setObject:font forKey:NSFontAttributeName];
    [attributes setObject:textColor forKey:NSForegroundColorAttributeName];
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}
- (UIImage *)buttonBackgroundImageForEmptyDataSet:(UIScrollView *)scrollView forState:(UIControlState)state
{
    NSString *imageName = @"";
    
    if (state == UIControlStateNormal) imageName = @"button_background_foursquare_normal";
    if (state == UIControlStateHighlighted) imageName = @"button_background_foursquare_highlight";
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0);
    UIEdgeInsets rectInsets = UIEdgeInsetsZero;
    capInsets = UIEdgeInsetsMake(25.0, 25.0, 25.0, 25.0);
    rectInsets = UIEdgeInsetsMake(0.0, 10, 0.0, 10);
    
    UIImage *image = [UIImage imageNamed:imageName inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    //该方法返回的是UIImage类型的对象,即返回经该方法拉伸后的图像
    //传入的第一个参数capInsets是UIEdgeInsets类型的数据,即原始图像要被保护的区域
    //这个参数是一个结构体,定义如下
    //typedef struct { CGFloat top, left , bottom, right ; } UIEdgeInsets;
    //该参数的意思是被保护的区域到原始图像外轮廓的上部,左部,底部,右部的直线距离,参考图2.1
    //传入的第二个参数resizingMode是UIImageResizingMode类似的数据,即图像拉伸时选用的拉伸模式,
    //这个参数是一个枚举类型,有以下两种方式
    //UIImageResizingModeTile,     平铺
    //UIImageResizingModeStretch,  拉伸
    return [[image resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch] imageWithAlignmentRectInsets:rectInsets];
}
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView
{
    if (self.isLoding) {
        return [UIImage imageNamed:@"loading_imgBlue_78x78" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }else{
        return [UIImage imageNamed:@"placeholder_appstore" inBundle:[NSBundle bundleForClass:[self class]] compatibleWithTraitCollection:nil];
    }
}
- (CAAnimation *)imageAnimationForEmptyDataSet:(UIScrollView *)scrollView
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    animation.toValue = [NSValue valueWithCATransform3D: CATransform3DMakeRotation(M_PI_2, 0.0, 0.0, 1.0) ];
    animation.duration = 0.25;
    animation.cumulative = YES;
    animation.repeatCount = MAXFLOAT;
    
    return animation;
}
- (UIColor *)backgroundColorForEmptyDataSet:(UIScrollView *)scrollView
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView
{
    return -64.0;
}
#pragma mark - DZNEmptyDataSetDelegate Methods

- (BOOL)emptyDataSetShouldDisplay:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView
{
    return YES;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView
{
    return YES;
}
- (BOOL)emptyDataSetShouldAnimateImageView:(UIScrollView *)scrollView
{
    return self.isLoding;
}
- (void)emptyDataSet:(UIScrollView *)scrollView didTapView:(UIView *)view
{
    self.isLoding = YES;
    [self.emptyDataSetTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLoding = NO;
        [self.emptyDataSetTableView reloadData];
    });
}

- (void)emptyDataSet:(UIScrollView *)scrollView didTapButton:(UIButton *)button
{
    self.isLoding = YES;
    [self.emptyDataSetTableView reloadData];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.isLoding = NO;
        [self.emptyDataSetTableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
