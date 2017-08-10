//
//  SerachView.m
//  WDKKtest
//
//  Created by Skyer God on 16/7/28.
//  Copyright © 2016年 weiDianKuaiKe. All rights reserved.
//

#import "SerachView.h"

#import "MySearchBar.h"
@interface SearchBarView ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *resultTableV;
@end
@implementation SearchBarView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        
        self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
        
        self.searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.searchBar.delegate = self;
        
        self.searchBar.searchBarStyle = UISearchBarStyleProminent;
        
        //设置搜索框背景
        [self.searchBar setBackgroundImage:[UIImage imageNamed:@"icon_barBackImage"]];
        self.searchBar.scopeBarBackgroundImage = self.searchBar.backgroundImage;
        //设置左边搜索指示图
        [self.searchBar setImage:[UIImage imageNamed:@"icon_search"] forSearchBarIcon:UISearchBarIconClear state:UIControlStateNormal];
        
        //设置文本背景
        [self.searchBar setSearchFieldBackgroundImage:[UIImage imageNamed:@"icon_barBackImage"] forState:UIControlStateNormal];
        self.searchBar.translucent = YES;
        self.searchBar.placeholder = @"请输入商家或商品名称";

//        // 搜索栏下部的选择栏，数组里面的内容是按钮的标题
//        self.searchBar.scopeButtonTitles = [NSArray arrayWithObjects:@"iOS",@"Android",@"iPhone",nil];
//        // 进入界面,搜索栏下部的默认选择栏按钮的索引(也就是第一出现在哪个选择栏)
//        self.searchBar.selectedScopeButtonIndex =2;
//        // 控制搜索栏下部的选择栏是否显示出来(显示的话,就要修改search的frame,不显示的话80就够了)
//        self.searchBar.showsScopeBar =YES;
        
        [self addSubview:self.searchBar];
    }
    return self;
}
- (UITableView *)resultTableV{
    if (!_resultTableV) {
        
        self.resultTableV = [[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(self.searchBar.frame), self.bounds.size.width, self.bounds.size.height-CGRectGetHeight(self.searchBar.frame)) style:UITableViewStylePlain];
        self.resultTableV.dataSource = self;
        self.resultTableV.delegate = self;
        self.resultTableV.separatorStyle = 0;
        [self.resultTableV registerClass:[UITableViewCell class] forCellReuseIdentifier:@"resultCell"];
    }
    return _resultTableV;
}
//serachBar Delegate方法
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    return YES;//设置为NO无法回收键盘
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;//取消字体颜色
    [searchBar setShowsCancelButton:YES animated:YES];
    
    [self addSubview:self.resultTableV];
    
    for (UIView *view  in [[[searchBar subviews] firstObject] subviews]) {
        if ([view isKindOfClass:[UIButton class]]) {
            UIButton *cancel = (UIButton *)view;
            
            [cancel setTitle:@"取消" forState:UIControlStateNormal];
            [cancel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }

}
// 结束掉用的编辑方法
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    NSLog(@"查询结束");
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{

    //输入关键字弹出
    NSLog(@"🐯  你一输入关键字我就出来啦    关键字是--%@ 一共--%lu个", searchText, (unsigned long)searchText.length);
//    self.result = nil;
//    
//    // 在这里对比 输入的关键字 与数组里面的数据 是否相同
//    for (int i = 0; i < self.nameArr.count; i++) {
//        NSString *string = self.nameArr[i];
//        if (string.length >= searchText.length) {
//            NSString *str = [self.nameArr[i] substringWithRange:NSMakeRange(0, searchText.length)];
//            if ([str isEqualToString:searchText]) {
//                [self.result addObject:self.nameArr[i]];
//            }
//            
//        }
//    }
//    // 这里需要刷新 tableView !!!
//    [self.searchResult reloadData];
}

//取消按钮响应的方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"🐰  你一点取消我就出来啦");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
// 键盘上的Search 响应的方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    NSLog(@"🐲  你一点键盘上的搜索我就出来啦");
    [searchBar setShowsCancelButton:NO animated:YES];
    [searchBar resignFirstResponder];
}
//tableView协议方法
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"resultCell" forIndexPath:indexPath];
    
    cell.textLabel.text = @"微点筷客";
    
    
//    NSRange range = [cell.label.text rangeOfString:_keyWord];
    
//    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:_nameArr[indexPath.row][@"portrait"]] placeholderImage:[UIImage imageNamed:@"renyuPlaceHolder.jpg"]];
//    NSMutableAttributedString *arrStr = [[NSMutableAttributedString alloc]initWithString:cell.label.text];
//    //    NSLog(@"%@", arrStr);
//    if ([cell.label.text containsString:_keyWord]) {
//        
//        
//        [arrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:range]; //字体大小
//        [arrStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:0.881 green:0.308 blue:0.295 alpha:1.000] range:range]; //字体颜色
//        [arrStr addAttribute:NSBackgroundColorAttributeName value:[UIColor orangeColor] range:range]; //背景颜色
//        //    [arrStr addAttribute:NSShadowAttributeName value:[UIColor redColor] range:range]; //阴影
//        [arrStr addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:range];//删除线
//        cell.label.attributedText = arrStr;
//        
//    }
    
    return cell;
}
@end
