//
//  MoreOperationSetVC.m
//  微点筷客商户端
//
//  Created by Skyer God on 17/1/13.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import "MoreOperationSetVC.h"
#import "HelpCenterSetVCViewController.h"
#import "AdviseRetroactionVC.h"
#import "AboutUsVC.h"
@interface MoreOperationSetVC ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *tableV;
    NSArray *secondSecArr;
    NSArray *firstSecArr;
}
@end

@implementation MoreOperationSetVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    self.titleView.text = @"更多操作";
    self.rightBarItem.hidden = YES;
    [self createTableView];
}
- (void)leftBarButtonItemAction{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)createTableView{
    firstSecArr = @[@"清理缓存"];
    secondSecArr = @[ @"帮助中心", @"意见反馈", @"关于我们"];
    tableV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    tableV.backgroundColor = RGB(238, 238, 238);
    tableV.delegate = self;
    tableV.dataSource = self;
    [self.view addSubview:tableV];
    tableV.bounces = NO;
    tableV.sd_layout.spaceToSuperView(UIEdgeInsetsMake(64, 0, 0, 0));
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return firstSecArr.count;
    } else {
        return secondSecArr.count;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.001;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 42;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"operationCell";
    UITableViewCell *cell = [tableV dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.section == 0) {
        cell.textLabel.text = firstSecArr[indexPath.row];
        CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
        NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
        cell.detailTextLabel.text = message;

    } else {
        cell.textLabel.text = secondSecArr[indexPath.row];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    [self setExtraCellLineHidden:tableV];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            //清理缓存
                [self putBufferBtnClicked];
        }
    } else {
        switch (indexPath.row) {
            case 0:{
                //帮助中心
                HelpCenterSetVCViewController *help = [[HelpCenterSetVCViewController alloc] init];
                [self.navigationController pushViewController:help animated:YES];
            }
                break;
            case 1: {
                //意见反馈
                AdviseRetroactionVC *advise = [[AdviseRetroactionVC alloc] init];
                [self.navigationController pushViewController:advise animated:YES];
            }
                break;
            case 2: {
                //关于我们
                AboutUsVC *about = [[AboutUsVC alloc] init];
                [self.navigationController pushViewController:about animated:YES];
            }
                break;

            default:
                break;
        }
    }
}
//清除缓存按钮的点击事件
- (void)putBufferBtnClicked{
    NSString * cachPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *pathSec = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject;
    NSString *cachePathTemporary = NSTemporaryDirectory();
    //    CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    UITableViewCell *cacheCell = [tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    NSString *message = [NSString stringWithFormat:@"缓存%@, 删除缓存", cacheCell.detailTextLabel.text];

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:(UIAlertControllerStyleAlert)];

    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self cleanCaches:cachPath];
            [self cleanCaches:pathSec];
            [self cleanCaches:cachePathTemporary];
        });

    }];

    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:nil];
    [alert addAction:action];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
}
// 计算目录大小
- (CGFloat)folderSizeAtPath:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *manager = [NSFileManager defaultManager];
    CGFloat size = 0;
    if ([manager fileExistsAtPath:path]) {
        // 获取该目录下的文件，计算其大小
        NSArray *childrenFile = [manager subpathsAtPath:path];
        for (NSString *fileName in childrenFile) {
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            size += [manager attributesOfItemAtPath:absolutePath error:nil].fileSize;
        }
        // 将大小转化为M
        return size / 1024.0 / 1024.0;
    }
    return 0;
}
// 根据路径删除文件
- (void)cleanCaches:(NSString *)path{
    // 利用NSFileManager实现对文件的管理
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:path]) {
        // 获取该路径下面的文件名
        NSArray *childrenFiles = [fileManager subpathsAtPath:path];
        for (NSString *fileName in childrenFiles) {
            // 拼接路径
            NSString *absolutePath = [path stringByAppendingPathComponent:fileName];
            // 将文件删除
            [fileManager removeItemAtPath:absolutePath error:nil];
        }
    }



        CGFloat size = [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).lastObject] + [self folderSizeAtPath:NSTemporaryDirectory()];
    if (size < 0.01) {
        NSString *message = size > 1 ? [NSString stringWithFormat:@"%.2fM", size] : [NSString stringWithFormat:@"%.2fK", size * 1024.0];
        UITableViewCell *cacheCell = [tableV cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
        [SVProgressHUD showSuccessWithStatus:@"清理成功!"];
        cacheCell.detailTextLabel.text = message;
    }


}
/** 隐藏多余的分割线 **/
-(void)setExtraCellLineHidden: (UITableView *)tableView
{
    UIView *view = [UIView new];

    view.backgroundColor = [UIColor clearColor];

    [tableView setTableFooterView:view];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
