//
//  DownloadTestVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/6/11.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "DownloadTestVC.h"
#import <AFNetworking/AFNetworking.h>
#import "AFOfflineResumeDownloadFileVC.h"

@interface DownloadTestVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *progressView;
@property (weak, nonatomic) IBOutlet UILabel *progressLabel;

@end

@implementation DownloadTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"Download";
    
    
}
- (IBAction)clickDownloadStart:(id)sender {
    // 1. 创建会话管理者
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    // 2. 创建下载路径和请求对象
    NSURL *URL = [NSURL URLWithString:@"http://dldir1.qq.com/qqfile/QQforMac/QQ_V5.4.0.dmg"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    // 3.创建下载任务
    /**
     * 第一个参数 - request：请求对象
     * 第二个参数 - progress：下载进度block
     *      其中： downloadProgress.completedUnitCount：已经完成的大小
     *            downloadProgress.totalUnitCount：文件的总大小
     * 第三个参数 - destination：自动完成文件剪切操作
     *      其中： 返回值:该文件应该被剪切到哪里
     *            targetPath：临时路径 tmp NSURL
     *            response：响应头
     * 第四个参数 - completionHandler：下载完成回调
     *      其中： filePath：真实路径 == 第三个参数的返回值
     *            error:错误信息
     */
    
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress *downloadProgress) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // 下载进度
            self.progressView.progress = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
            self.progressLabel.text = [NSString stringWithFormat:@"当前下载进度:%.0f%%",100.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount];
        });
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *path = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [path URLByAppendingPathComponent:@"QQ_V5.4.0.dmg"];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    // 4. 开启下载任务
    [downloadTask resume];
}
- (IBAction)clickSkip:(id)sender {
    AFOfflineResumeDownloadFileVC *aFOfflineResumeDownloadFileVC = [[AFOfflineResumeDownloadFileVC alloc] init];
    [self.navigationController pushViewController:aFOfflineResumeDownloadFileVC animated:YES];
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
