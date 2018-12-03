//
//  ChatrsTestViewController.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/9.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "ChatrsTestViewController.h"
#import "ChartTestDemo-Swift.h"
#import "TestEmptyDataSetVC.h"
@interface ChatrsTestViewController ()<ChartViewDelegate>

@property (weak, nonatomic) IBOutlet LineChartView *chartView;
@property (nonatomic, strong) NSArray *options;
@end

@implementation ChatrsTestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Charts";
//    self.options = @[
//                     @{@"key": @"toggleValues", @"label": @"Toggle Values"},
//                     @{@"key": @"toggleFilled", @"label": @"Toggle Filled"},
//                     @{@"key": @"toggleCircles", @"label": @"Toggle Circles"},
//                     @{@"key": @"toggleCubic", @"label": @"Toggle Cubic"},
//                     @{@"key": @"toggleHorizontalCubic", @"label": @"Toggle Horizontal Cubic"},
//                     @{@"key": @"toggleIcons", @"label": @"Toggle Icons"},
//                     @{@"key": @"toggleStepped", @"label": @"Toggle Stepped"},
//                     @{@"key": @"toggleHighlight", @"label": @"Toggle Highlight"},
//                     @{@"key": @"animateX", @"label": @"Animate X"},
//                     @{@"key": @"animateY", @"label": @"Animate Y"},
//                     @{@"key": @"animateXY", @"label": @"Animate XY"},
//                     @{@"key": @"saveToGallery", @"label": @"Save to Camera Roll"},
//                     @{@"key": @"togglePinchZoom", @"label": @"Toggle PinchZoom"},
//                     @{@"key": @"toggleAutoScaleMinMax", @"label": @"Toggle auto scale min/max"},
//                     @{@"key": @"toggleData", @"label": @"Toggle Data"},
//                     ];
    
    _chartView.delegate = self;
    
    //打开这个属性，你的图表上将会有关于你的图标的描述。例如: chartView.chartDescription.enabled = YES chartView.chartDescription.text = @"王尼玛的chartsView"
    _chartView.chartDescription.enabled = NO;
    
    //启用拖拽图表
    _chartView.dragEnabled = YES;
    
    //启用扩展吗?(用手势放大和缩小)图表(这并不影响拖动)。
    [_chartView setScaleEnabled:YES];
    
    //是否开启触控放大
    _chartView.pinchZoomEnabled = YES;
    
    //是否有网格背景
    _chartView.drawGridBackgroundEnabled = NO;
    
    // x-axis limit line X轴上添加限制线
    ChartLimitLine *llXAxis = [[ChartLimitLine alloc] initWithLimit:10.0 label:@"Index 10"];
    //设置线的宽度
    llXAxis.lineWidth = 4.0;
    //设置相对于坐标轴，虚线样式的，虚线高度单位
    llXAxis.lineDashLengths = @[@(10.f),@(10.f),@(0.f)];
    //设置限制线描述文案的显示位置
    llXAxis.labelPosition = ChartLimitLabelPositionRightBottom;
    //设置限制线描述文案字体大小
    llXAxis.valueFont = [UIFont systemFontOfSize:10.f];
    //设置限制线描述文案字体颜色
    llXAxis.valueTextColor = [UIColor purpleColor];
    //设置限制线颜色
    llXAxis.lineColor = [UIColor purpleColor];
    //添加限制线到X轴上
    //[_chartView.xAxis addLimitLine:llXAxis];
    
    //设置X轴虚线样式的网格线
    _chartView.xAxis.gridLineDashLengths = @[@10.0, @10.0];
    //意思跟轴线的一样
    _chartView.xAxis.gridLineDashPhase = 0.f;
    
    ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:150.0 label:@"Upper Limit"];
    ll1.lineWidth = 4.0;
    ll1.lineDashLengths = @[@5.f, @5.f];
    ll1.labelPosition = ChartLimitLabelPositionRightTop;
    ll1.valueFont = [UIFont systemFontOfSize:10.0];
    
    ChartLimitLine *ll2 = [[ChartLimitLine alloc] initWithLimit:-30.0 label:@"Lower Limit"];
    ll2.lineWidth = 4.0;
    ll2.lineDashLengths = @[@5.f, @5.f];
    ll2.labelPosition = ChartLimitLabelPositionRightBottom;
    ll2.valueFont = [UIFont systemFontOfSize:10.0];
    
    //获取左边Y轴
    ChartYAxis *leftAxis = _chartView.leftAxis;
    [leftAxis removeAllLimitLines];
    
    //添加限制线到Y轴上
    [leftAxis addLimitLine:ll1];
    [leftAxis addLimitLine:ll2];
    
    //Y轴最大值
    leftAxis.axisMaximum = 200.0;
    //Y轴最小值
    leftAxis.axisMinimum = 0.0;
    leftAxis.labelCount = 10;
    
    //设置Y轴虚线样式的网格线
    leftAxis.gridLineDashLengths = @[@5.f, @5.f];
    //从0开始绘画
    leftAxis.drawZeroLineEnabled = NO;
    //限制线绘制在数据后面还是前面，默认为false，即绘制在数据前面；
    leftAxis.drawLimitLinesBehindDataEnabled = YES;
    //不绘制右边轴
    _chartView.rightAxis.enabled = NO;
    
    //[_chartView.viewPortHandler setMaximumScaleY: 2.f];
    //[_chartView.viewPortHandler setMaximumScaleX: 2.f];
    
    //气泡
    BalloonMarker *marker = [[BalloonMarker alloc]
                             initWithColor: [ChartColorTemplates colorFromString:@"#FFC0CB"]
                             font: [UIFont systemFontOfSize:12.0]
                             textColor: UIColor.whiteColor
                             insets: UIEdgeInsetsMake(8.0, 8.0, 20.0, 8.0)];
    marker.chartView = _chartView;
    marker.minimumSize = CGSizeMake(80.f, 40.f);
    _chartView.marker = marker;
    
    //描述及图例样式
    _chartView.legend.form = ChartLegendFormLine;
    _chartView.legend.textColor = [UIColor purpleColor];
    
    [self updateChartData];
    //设置动画时间
    [_chartView animateWithXAxisDuration:2.5];
    
    
}
- (void)updateChartData
{
   [self setDataCount:45.0 range:100.0];
}
- (void)setDataCount:(int)count range:(double)range
{
    NSMutableArray *values = [[NSMutableArray alloc] init];
    
    //初始化数据源
    for (int i = 0; i < count; i++)
    {
        double val = arc4random_uniform(range) + 3;
        [values addObject:[[ChartDataEntry alloc] initWithX:i y:val icon: [UIImage imageNamed:@"icon_star"]]];
    }
    
    LineChartDataSet *set1 = nil;
    if (_chartView.data.dataSetCount > 0)
    {
        set1 = (LineChartDataSet *)_chartView.data.dataSets[0];
        set1.values = values;
        //通知data去更新
        [_chartView.data notifyDataChanged];
        //通知图表去更新
        [_chartView notifyDataSetChanged];
    }
    else
    {
        set1 = [[LineChartDataSet alloc] initWithValues:values label:@"DataSet 1"];
        
        //是否显示每个点设置的icon图片
        set1.drawIconsEnabled = NO;
        
        //虚线间隔
        //set1.lineDashLengths = @[@5.f, @2.5f];
        //十字线的虚线样式
        set1.highlightLineDashLengths = @[@5.f, @2.5f];
        //折线颜色
        [set1 setColor:UIColor.blackColor];
        //设置折线样式，这个是平滑的过渡
        //set1.mode = LineChartModeCubicBezier;
        //是否显示折线点
        set1.drawCirclesEnabled = NO;
        //折线点的颜色
        //[set1 setCircleColor:UIColor.blackColor];
        //折线的宽度
        set1.lineWidth = 1.0;
        //折线点的宽度
        //set1.circleRadius = 3.0;
        //是否画空心圆
        //set1.drawCircleHoleEnabled = NO;
        //折线点的值的字是否显示
        set1.drawValuesEnabled = NO;
        //折线点的值的字体大小
        set1.valueFont = [UIFont systemFontOfSize:9.f];
        
        //折线图下方折线的描述示例设置
        //图例线的样式比例，跟折线图比例一致
        //set1.formLineDashLengths = @[@5.f, @2.5f];
        //图例的线宽
        set1.formLineWidth = 1.0;
        //图例的字体大小
        set1.formSize = 15.0;
        // 设置渐变效果
        NSArray *gradientColors = @[
                                    (id)[ChartColorTemplates colorFromString:@"#00ff0000"].CGColor,
                                    (id)[ChartColorTemplates colorFromString:@"#ffff0000"].CGColor
                                    ];
        CGGradientRef gradient = CGGradientCreateWithColors(nil, (CFArrayRef)gradientColors, nil);
        //透明度
        set1.fillAlpha = 1.f;
        //赋值填充颜色对象
        set1.fill = [ChartFill fillWithLinearGradient:gradient angle:90.f];
        //是否填充颜色 
        set1.drawFilledEnabled = YES;
        
        CGGradientRelease(gradient);
        
        NSMutableArray *dataSets = [[NSMutableArray alloc] init];
        [dataSets addObject:set1];
        
        //此对象就是 lineChartView 需要最终数据对象
        LineChartData *data = [[LineChartData alloc] initWithDataSets:dataSets];
        
        _chartView.data = data;
    }
}

#pragma mark - ChartViewDelegate
- (void)chartValueSelected:(ChartViewBase * __nonnull)chartView entry:(ChartDataEntry * __nonnull)entry highlight:(ChartHighlight * __nonnull)highlight
{
    NSLog(@"chartValueSelected");
}

- (void)chartValueNothingSelected:(ChartViewBase * __nonnull)chartView
{
    NSLog(@"chartValueNothingSelected");
}
- (IBAction)clickPushVC:(UIButton *)sender {
    TestEmptyDataSetVC *testEmptyDataSetVC = [[TestEmptyDataSetVC alloc] init];
    [self.navigationController pushViewController:testEmptyDataSetVC animated:YES];
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
