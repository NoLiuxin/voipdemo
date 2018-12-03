//
//  YYKitTestListVC.m
//  ChartTestDemo
//
//  Created by 刘新 on 2018/6/1.
//  Copyright © 2018年 Liuxin. All rights reserved.
//

#import "YYKitTestListVC.h"
#import <YYKit/YYKit.h>
#import "YYTableView.h"
#import "YYKitTestCell.h"
#import "TestListModel.h"
#import "TestListLayout.h"
#import "YYPhotoGroupView.h"
#import "DownloadTestVC.h"

@interface YYKitTestListVC ()<UITableViewDelegate, UITableViewDataSource,WBStatusCellDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *layouts;
@end

@implementation YYKitTestListVC
- (instancetype)init {
    self = [super init];
    _tableView = [YYTableView new];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _layouts = [NSMutableArray new];
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"YYKit";
    _tableView.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight-64);
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_tableView];
    
    
    NSArray *dataArray = @[@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]},@{@"contentText":@"Augustus Owsley Stanley (May 21, 1867 – August 12, 1958) was an American politician from the U.S. state of Kentucky. A Democrat, he served as the 38th Governor of Kentucky. From 1903 to 1915, Stanley represented Kentucky's 2nd congressional district in the U.S. House of Representatives, where he gained a",@"imageArray":@[@"http://img4.duitang.com/uploads/item/201312/05/20131205171741_ATjVt.jpeg",@"http://img2.ph.126.net/2RmEasihDVAGzWoiJANQyA==/6631496575234573151.jpg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171732_ecTnY.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205171742_TVULC.jpeg",@"http://img4.duitang.com/uploads/item/201312/05/20131205172514_VFhZx.jpeg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=fa1801f63301213fdb3e469f3c8e5ca4/b90e7bec54e736d15826b92791504fc2d56269e3.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=af19d32ba6af2eddc0fc41aae5796b9c/a2cc7cd98d1001e9e011b922b20e7bec54e797ea.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=c7df66b0c33d70cf58f7a24e90b5bb75/3ac79f3df8dcd1000240cca8788b4710b8122f5e.jpg",@"http://imgsrc.baidu.com/image/c0%3Dshijue1%2C0%2C0%2C294%2C40/sign=978dff9fb3014a9095334efec11e5367/f703738da97739123a81c54cf2198618367ae27c.jpg"]}];
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.size = CGSizeMake(80, 80);
    indicator.center = CGPointMake(kScreenWidth / 2, kScreenHeight / 2);
    indicator.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.670];
    indicator.clipsToBounds = YES;
    indicator.layer.cornerRadius = 6;
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (int i = 0; i < dataArray.count; i++) {
            NSDictionary *dataDic = dataArray[i];
            
            TestListModel *model = [TestListModel modelWithJSON:dataDic];
            TestListLayout *layout = [[TestListLayout alloc] initWithStatus:model];
            [self.layouts addObject:layout];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [indicator removeFromSuperview];
            [self.tableView reloadData];
        });
    });
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.layouts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID =@"cellID";
    YYKitTestCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell==nil) {
        cell = [[YYKitTestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.delegate = self;
    }
    [cell setLayout:_layouts[indexPath.row]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return ((TestListLayout *)_layouts[indexPath.row]).height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DownloadTestVC *downloadTestVC = [[DownloadTestVC alloc] init];
    [self.navigationController pushViewController:downloadTestVC animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/// 点击了图片
- (void)cell:(YYKitTestCell *)cell didClickImageAtIndex:(NSUInteger)index{
    UIView *fromView = nil;
    NSMutableArray *items = [NSMutableArray new];
    TestListModel *status = cell.statusView.layout.status;
    NSArray *pics = status.imageArray;
    
    for (NSUInteger i = 0, max = pics.count; i < max; i++) {
        UIView *imgView = cell.statusView.picViews[i];
        YYPhotoGroupItem *item = [YYPhotoGroupItem new];
        item.thumbView = imgView;
        item.largeImageURL = [NSURL URLWithString:pics[i]];
        item.largeImageSize = CGSizeMake(imgView.width, imgView.height);
        [items addObject:item];
        if (i == index) {
            fromView = imgView;
        }
    }
    YYPhotoGroupView *v = [[YYPhotoGroupView alloc] initWithGroupItems:items];
    [v presentFromImageView:fromView toContainer:self.navigationController.view animated:YES completion:nil];
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
