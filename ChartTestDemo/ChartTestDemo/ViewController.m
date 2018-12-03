//
//  ViewController.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/5/8.
//  Copyright © 2018年 Liuxin. All rights reserved.
//



#import "ViewController.h"
#import "Charts-Swift.h"
#import <SDWebImage/UIButton+WebCache.h>
#import <AFNetworking/AFNetworking.h>
#import "Person.h"
#import "ChatrsTestViewController.h"
#import <YYKit/YYKit.h>
#import "MinTestVC.h"
#import "ChartTestDemo-Swift.h"
#import "BDSSpeechSynthesizer.h"
#import <AVFoundation/AVFoundation.h>

static NSString *const PersonModelKey = @"PersonModelKey";
static NSString *const PersonCache = @"PersonCache";

//#error 请在官网新建app，配置bundleId，并在此填写相关参数
static NSString *const APP_ID = @"14869675";
static NSString *const API_KEY = @"wHGpfjcGd7wdhlWpSpFsTCUG";
static NSString *const SECRET_KEY = @"U3oc3HzgHM5TGVWcw3pSyL7g5ok43nZa";

@interface ViewController ()<BDSSpeechSynthesizerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [BDSSpeechSynthesizer setLogLevel:BDS_PUBLIC_LOG_VERBOSE];
//    [[BDSSpeechSynthesizer sharedInstance] setSynthesizerDelegate:self];
//    //[self configureOfflineTTS];
//    [self configureOnlineTTS];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"YYCache";
    
    LineChartView *lineview = [[LineChartView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 300)];
    lineview.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:lineview];
    
    UIView *lodingView = [[UIView alloc] initWithFrame:CGRectMake(0, lineview.bottom+10, [UIScreen mainScreen].bounds.size.width, 200)];
    lodingView.backgroundColor = [UIColor orangeColor];
    lodingView.centerX = self.view.centerX;
    [self.view addSubview:lodingView];
    
    //[self setUpAnimation:lodingView.layer size:CGSizeMake(60, 60) color:[UIColor whiteColor]];
    CALayer *layer = [self bezierCurve:CGSizeMake([UIScreen mainScreen].bounds.size.width, 200) color:[UIColor redColor]];
    [lodingView.layer addSublayer:layer];
    
//   CALayer *layer = [self layerWith:CGSizeMake(60, 60) color:[UIColor whiteColor]];
//    layer.frame = CGRectMake((lodingView.width-60)/2, (lodingView.height-60)/2, 60, 60);
//    [lodingView.layer addSublayer:layer];
//
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    rotationAnimation.byValue = [NSNumber numberWithDouble:M_PI * 2.0f];
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];


    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.15 :0.46 :0.9 :0.6];

    CAKeyframeAnimation *keyframeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];

    keyframeAnimation.keyTimes = @[[NSNumber numberWithDouble:0.4], [NSNumber numberWithDouble:0.5], [NSNumber numberWithDouble:1]];
    keyframeAnimation.timingFunctions = @[timingFunction, timingFunction];
    keyframeAnimation.values = @[[NSNumber numberWithDouble:0.8], [NSNumber numberWithDouble:1.1], [NSNumber numberWithDouble:0.75]];
    keyframeAnimation.duration = 1;

    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[rotationAnimation, keyframeAnimation];
    groupAnimation.duration = 1;
    groupAnimation.repeatCount = MAXFLOAT;
    groupAnimation.removedOnCompletion = NO;
    [layer addAnimation:groupAnimation forKey:@"animation"];
//
//    CALayer *layerTow = [self layerWith:CGSizeMake(30, 30) color:[UIColor whiteColor]];
//    layerTow.frame = CGRectMake((lodingView.width-30)/2, (lodingView.height-30)/2, 30, 30);
//    [lodingView.layer addSublayer:layerTow];
//
//    CABasicAnimation *rotationAnimation2 = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
//    rotationAnimation2.byValue = [NSNumber numberWithDouble:-M_PI * 2.0f];
//    rotationAnimation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
//    rotationAnimation2.duration = 1.5;
//    rotationAnimation2.repeatCount = MAXFLOAT;
//    rotationAnimation2.removedOnCompletion = NO;
//    [layerTow addAnimation:rotationAnimation2 forKey:@"animation2"];
    
    //绕Y轴做了45度角的旋转
//    CATransform3D test3D = CATransform3DMakeRotation(M_PI_4, 0, 1, 0);
//    lodingView.layer.transform = test3D;
    
    Person *person = [[Person alloc] init];
    person.name = @"小猪佩奇";
    person.sex = @"女";
    person.age = 11;
    person.clothing = @"red";
    person.isBig = YES;
    person.stature = 35.79f;
    person.income = 13455;
    
    //创建一个YYCache实例:userInfoCache
    YYCache *userInfoCache = [YYCache cacheWithName:PersonCache];
    
    //存入键值对
    [userInfoCache setObject:person forKey:PersonModelKey];
    
    //判断缓存是否存在
    [userInfoCache containsObjectForKey:PersonModelKey withBlock:^(NSString * _Nonnull key, BOOL contains) {
        if (contains){
            NSLog(@"object exists");
        }
    }];
    
    //根据key读取数据
    [userInfoCache objectForKey:PersonModelKey withBlock:^(NSString * _Nonnull key, id<NSCoding>  _Nonnull object) {
        Person *cacheMode = (Person *)object;
        NSLog(@"______%@",cacheMode.name);
    }];
    
    //根据key移除缓存
    [userInfoCache removeObjectForKey:PersonModelKey withBlock:^(NSString * _Nonnull key) {
        NSLog(@"remove user name %@",key);
    }];
    
    //移除所有缓存
    [userInfoCache removeAllObjectsWithBlock:^{
        NSLog(@"removing all cache succeed");
    }];
    
    //移除所有缓存带进度
    [userInfoCache removeAllObjectsWithProgressBlock:^(int removedCount, int totalCount) {
        NSLog(@"remove all cache objects: removedCount :%d  totalCount : %d",removedCount,totalCount);
    } endBlock:^(BOOL error) {
        if(!error){
            NSLog(@"remove all cache objects: succeed");
        }else{
            NSLog(@"remove all cache objects: failed");
        }
    }];
    
//    CAMediaTimingFunction *timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5 :0.6 :1];
//    CAMediaTimingFunction *timingFunctionTow = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
//    animation.timingFunctions = @[timingFunction,timingFunctionTow];
    
    //将两个 transform3D对象变换属性进行叠加，返回一个新的transform3D对象
    [NSValue valueWithCATransform3D:CATransform3DConcat([self createRotateXTransform:0], [self createRotateXTransform:0])];
    //CATransform3DMakeRotation(<#CGFloat angle#>, <#CGFloat x#>, <#CGFloat y#>, <#CGFloat z#>)
    //sync :同步
    //async :异步
//    dispatch_sync(dispatch_get_main_queue(), ^{
//        
//    });
    //dispatch_async(<#dispatch_queue_t  _Nonnull queue#>, <#^(void)block#>)
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 100, [UIScreen mainScreen].bounds.size.width-15, 1)];
    lineImageView.image = [self drawLineOfDashByImageView:lineImageView];
    [self.view addSubview:lineImageView];
}
-(void)configureOfflineTTS{
    
    NSError *err = nil;
    // 在这里选择不同的离线音库（请在XCode中Add相应的资源文件），同一时间只能load一个离线音库。根据网络状况和配置，SDK可能会自动切换到离线合成。
    NSString* offlineEngineSpeechData = [[NSBundle mainBundle] pathForResource:@"Chinese_And_English_Speech_Female" ofType:@"dat"];
    
    NSString* offlineChineseAndEnglishTextData = [[NSBundle mainBundle] pathForResource:@"Chinese_And_English_Text" ofType:@"dat"];
    
    err = [[BDSSpeechSynthesizer sharedInstance] loadOfflineEngine:offlineChineseAndEnglishTextData speechDataPath:offlineEngineSpeechData licenseFilePath:nil withAppCode:APP_ID];
    if(err){
        NSLog(@"Offline TTS init failed");
        return;
    }
    
    NSInteger sentenceID;
    NSError* sentenceErr = nil;
    sentenceID = [[BDSSpeechSynthesizer sharedInstance] speakSentence:@"支付宝到账0.05元" withError:&sentenceErr];
    
    if(sentenceErr == nil){
        NSLog(@"Add sentence Error");
    }
    
}
-(void)configureOnlineTTS{
    
    [[BDSSpeechSynthesizer sharedInstance] setApiKey:API_KEY withSecretKey:SECRET_KEY];
    
    [[AVAudioSession sharedInstance]setCategory:AVAudioSessionCategoryPlayback error:nil];
    
    [[BDSSpeechSynthesizer sharedInstance] speakSentence:@"支付宝到账0.05元" withError:nil];
    
}
#pragma mark - implement BDSSpeechSynthesizerDelegate
- (void)synthesizerStartWorkingSentence:(NSInteger)SynthesizeSentence{
    NSLog(@"Did start synth %ld", (long)SynthesizeSentence);
    
}

- (void)synthesizerFinishWorkingSentence:(NSInteger)SynthesizeSentence{
    NSLog(@"Did finish synth, %ld", (long)SynthesizeSentence);
    
}

- (void)synthesizerSpeechStartSentence:(NSInteger)SpeakSentence{
    NSLog(@"Did start speak %ld", (long)SpeakSentence);
}

- (void)synthesizerSpeechEndSentence:(NSInteger)SpeakSentence{
    NSLog(@"Did end speak %ld", (long)SpeakSentence);
    
}
- (UIImage *)drawLineOfDashByImageView:(UIImageView *)imageView {
    // 开始划线 划线的frame
    UIGraphicsBeginImageContext(imageView.frame.size);
    [imageView.image drawInRect:CGRectMake(0, 0, imageView.frame.size.width, imageView.frame.size.height)];
    // 获取上下文
    CGContextRef line = UIGraphicsGetCurrentContext();
    // 设置线条终点的形状
    CGContextSetLineCap(line, kCGLineCapRound);
    // 设置虚线的长度 和 间距
    CGFloat lengths[] = {3,3};
    CGContextSetStrokeColorWithColor(line, [UIColor greenColor].CGColor);
    // 开始绘制虚线
    CGContextSetLineDash(line, 0, lengths, 1);
    CGContextMoveToPoint(line, 0.0, 1.0);
    CGContextAddLineToPoint(line, [UIScreen mainScreen].bounds.size.width-15, 1.0);
    CGContextStrokePath(line);
    return UIGraphicsGetImageFromCurrentImageContext();
}
- (CATransform3D)createRotateXTransform:(CGFloat)angle{
    CATransform3D transform3D = CATransform3DMakeRotation(angle, 1, 0, 0);
    transform3D.m34 =  - 1.0 / 100.0;
    return transform3D;
}

- (IBAction)clickPushVC:(id)sender {
//    ChatrsTestViewController *testVc = [[ChatrsTestViewController alloc] init];
//    [self.navigationController pushViewController:testVc animated:YES];
    
//    TestViewController *testVc = [[TestViewController alloc] init];
//    [self.navigationController pushViewController:testVc animated:YES];
    
    
    
    
//    MinTestVC *testVC = [[MinTestVC alloc] init];
//    [self.navigationController pushViewController:testVC animated:YES];
}

- (void)setUpAnimation:(CALayer *)layer size:(CGSize)size color:(UIColor *)color{
    double beginTime = 0.5;
    double strokeStartDuration = 1.2;
    double strokeEndDuration = 0.7;
    
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation"];
    /*byvalue是在fromvalue的值的基础上增加量*/
    rotationAnimation.byValue = [NSNumber numberWithDouble:M_PI * 2.0f];
    //动画的时间节奏控制
    /*
     kCAMediaTimingFunctionLinear 匀速
     kCAMediaTimingFunctionEaseIn 慢进
     kCAMediaTimingFunctionEaseOut 慢出
     kCAMediaTimingFunctionEaseInEaseOut 慢进慢出
     kCAMediaTimingFunctionDefault 默认值（慢进慢出）
     */
    rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    /** timingFunction
     *
     *  当上面的预置不能满足你的需求的时候,你可以使用下面的两个方法来自定义你的timingFunction
     *  具体参见下面的URL
     *
     *  @see http://developer.apple.com/library/ios/#documentation/Cocoa/Reference/CAMediaTimingFunction_class/Introduction/Introduction.html
     *
     *  + (id)functionWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
     *
     *  - (id)initWithControlPoints:(float)c1x :(float)c1y :(float)c2x :(float)c2y;
     */
    //rotationAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.3 :0.5 :0.6 :1];
    
    
    //表示从路径的1位置画到0 怎么画是按照清除开始的位置也就是1 这样开始的路径是空的（即都被清除掉了）一直清除到0 效果就是一条路径被反方向画出来
    CABasicAnimation *strokeEndAnimation = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    strokeEndAnimation.duration = strokeEndDuration;
    /**
     *  注意CAMediaTimingFunction 是一个贝塞尔曲线的控制方法，可以令动画做到先慢後快或先快後慢的结果
     */
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.2 :0.0 :1.0];
    strokeEndAnimation.fromValue = [NSNumber numberWithFloat:0];
    strokeEndAnimation.toValue = [NSNumber numberWithFloat:1];
    
    //表示从路径的0位置画到1怎么画是按照清除开始的位置也就是清除0 一直清除到1 效果就是一条路径慢慢的消失
    CABasicAnimation *strokeStartAnimation = [CABasicAnimation animationWithKeyPath:@"strokeStart"];
    strokeStartAnimation.duration = strokeStartDuration;
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithControlPoints:0.4 :0.2 :0.0 :1.0];
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat:0];
    strokeStartAnimation.toValue = [NSNumber numberWithFloat:1];
    strokeStartAnimation.beginTime = beginTime;
    
    CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
    groupAnimation.animations = @[rotationAnimation, strokeEndAnimation, strokeStartAnimation];
    groupAnimation.duration = strokeStartDuration + beginTime;
    groupAnimation.repeatCount = MAXFLOAT;
    //当duration值已经达到时，是否将动画自动从渲染树上移除
    groupAnimation.removedOnCompletion = NO;
    /*
     kCAFillModeRemoved 动画结束后，将会移除掉做的动画效果
     kCAFillModeForwards 动画结束后，动画将保持最后的表现状态
     kCAFillModeBackwards 与kCAFillModeForwards相对应
     kCAFillModeBoth 是kCAFillModeForwards和kCAFillModeBackwards的结合
     kCAFillModeFrozen 4.0之后就不推荐使用了。
     */
    groupAnimation.fillMode = kCAFillModeForwards;
    
    CAShapeLayer *animationLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 5.0f;
    /*
     center：圆心的坐标
     radius：半径
     startAngle：起始的弧度
     endAngle：圆弧结束的弧度
     clockwise：YES为顺时针，No为逆时针
     */
    [path addArcWithCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:-(M_PI / 2) endAngle:M_PI + M_PI / 2 clockwise:YES];
    animationLayer.fillColor = nil;
    animationLayer.strokeColor = color.CGColor;
    animationLayer.lineWidth = lineWidth;
    animationLayer.backgroundColor = nil;
    animationLayer.path = path.CGPath;
    animationLayer.frame = CGRectMake(layer.bounds.size.width - size.width, layer.bounds.size.height - size.width, size.height, size.height);;
    
    [layer addSublayer:animationLayer];
    [animationLayer addAnimation:groupAnimation forKey:@"animation"];
}
- (CALayer *)layerWith:(CGSize)size color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer new];
    UIBezierPath *path = [UIBezierPath new];
    CGFloat lineWidth = 2;
    /*
     center：圆心的坐标
     radius：半径
     startAngle：起始的弧度
     endAngle：圆弧结束的弧度
     clockwise：YES为顺时针，No为逆时针
     */
    [path addArcWithCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:M_PI / 3 endAngle:M_PI clockwise:YES];
    
    /*
     注意：
     （1）IOS坐标体系与数学坐标体系有差别，因此不能完全采用数学计算公式。
     （2）数学计算公式：
     x2=x+r*cos(角度值*PI/180)
     y2=y+r*sin(角度值*PI/180)
     但是在UIBezierPath的路径绘制中中使用的是数学计算公式
     （3）IOS中计算公式：
     x2=x+r*cos(角度值*PI/180)
     y2=y-r*sin(角度值*PI/180)
     */
    [path moveToPoint:CGPointMake(size.width / 2 + size.width / 2 * cos(240.0*M_PI/180), size.height / 2 + size.height / 2 * sin(240.0*M_PI/180))];

    [path addArcWithCenter:CGPointMake(size.width / 2, size.height / 2) radius:size.width / 2 startAngle:M_PI / 3.0 + M_PI endAngle:M_PI * 2 clockwise:YES];
    
    layer.fillColor = nil;
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    //layer.frame = CGRectMake(size.width/2, size.height/2, size.width, size.height);
    
    return layer;
}
- (CALayer *)bezierCurve:(CGSize)size color:(UIColor *)color{
    CAShapeLayer *layer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    CGFloat lineWidth = 2.0f;
    
    // 11.绘制三次贝塞尔曲线
    /**
     *  该方法就是画三次贝塞尔曲线的关键方法，以三个点画一段曲线，一般和moveToPoint:配合使用。其实端点为moveToPoint:设置，终止端点位为endPoint；。控制点1的坐标controlPoint1，这个参数可以调整。控制点2的坐标是controlPoint2。
     *
     *  @param endPoint      终点坐标
     *  @param controlPoint1 控制点1
     *  @param controlPoint2 控制点2
     */

    
    path.lineCapStyle  = kCGLineCapRound;
    path.lineJoinStyle = kCGLineCapRound;
    [path moveToPoint:CGPointMake(20, 100)];
    [path addCurveToPoint:CGPointMake(220, 100) controlPoint1:CGPointMake(120, 20) controlPoint2:CGPointMake(120, 180)];
    
    //[path addQuadCurveToPoint:CGPointMake(100, 100) controlPoint:CGPointMake(50, 100)];
    
    layer.strokeColor = color.CGColor;
    layer.lineWidth = lineWidth;
    layer.backgroundColor = nil;
    layer.path = path.CGPath;
    layer.frame = CGRectMake(0, 0, size.width, size.height);
    layer.fillColor = [UIColor clearColor].CGColor;
    return layer;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

