//
//  ResviceDetail.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/2/8.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "ResviceDetail.h"
#import "DetailTableViewCell.h"
@implementation ResviceDetail
- (id)initWithary:(NSMutableArray*)dictary
{
    self = [super init];
    if (self) {
        
        self.backgroundColor = RGBA(0, 0, 0, 0.3);
//        self.backgroundColor = [UIColor redColor];
        NSLog(@">>>%@",dictary);
        _dictary = dictary;
        [self CreatTableviewWithdict];
        
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(Remove)];
        tap.delegate = self;
        [self addGestureRecognizer:tap];
        
    }
    
    return self;
}
- (void)CreatTableviewWithdict
{
    _detailtable = [[UITableView alloc]init];
//    detailtable.backgroundColor = RGBA(0, 0, 0, 0.3);
    _detailtable.delegate = self;
    _detailtable.dataSource = self;
    _detailtable.separatorStyle = 0;
    [self addSubview:_detailtable];
    _detailtable.sd_layout.leftEqualToView(self).bottomEqualToView(self).widthIs(GetWidth).heightIs(_dictary.count*autoScaleH(45)+50);
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dictary.count;
}
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [NSString stringWithFormat:@"%ld-%ld", indexPath.row, indexPath.section];

    DetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (!cell) {
        
        cell = [[DetailTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:str];
    }
    cell.selectionStyle = 0;
    UILabel * linelabel = [[UILabel alloc]init];
    linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [cell addSubview:linelabel];
    linelabel.sd_layout.leftEqualToView(cell).rightEqualToView(cell).bottomEqualToView(cell).heightIs(1);
    
    NSDictionary * celldict = _dictary[indexPath.row];
    cell.namelabel.text = celldict[@"name"];
    cell.pricelabel.text = [NSString stringWithFormat:@"￥%@",celldict[@"fee"]];
    cell.numLabel.text = celldict[@"number"];
    cell.indexstr = celldict[@"index"];
    cell.idstr = celldict[@"id"];
    cell.plusBlock = ^(NSMutableDictionary * dict,BOOL change)
    {
//        __weak NSDictionary * notdict = nil;
        
        if (change==YES) {
            //便利数组有这道菜先删除再添加新状态
            [_dictary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                if ([_dictary[idx][@"id"] isEqualToString:dict[@"id"]]) {
                    
                    [_dictary[idx] setObject:dict[@"number"] forKey:@"number"];
                }
                
            }];

            //点击加号
            _notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"yes",@"change",dict[@"fee"],@"fee", nil];
        }
        else
        {
            //判断是否减到0份（删除）
            NSString * numberstr = dict[@"number"];
            NSInteger number = [numberstr integerValue];
            if (number==0) {
                
                [_dictary removeObjectAtIndex:indexPath.row];
                if (_dictary.count!=0) {
                    
                    [_detailtable reloadData];
                    
                    _detailtable.sd_layout.leftEqualToView(self).bottomEqualToView(self).widthIs(GetWidth).heightIs(_dictary.count*autoScaleH(45)+50);
                    
                }
                
            }
            else
            {
                //便利数组有这道菜先删除再添加新状态
                [_dictary enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    if ([_dictary[idx][@"id"] isEqualToString:dict[@"id"]]) {
                        
                        [_dictary[idx] setObject:dict[@"number"] forKey:@"number"];
                    }
                    
                }];

            }
            
            // 减号
            if (_dictary.count!=0) {
                _notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"no",@"change",dict[@"fee"],@"fee", nil];
                
            }
            else{
                _notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"remove",@"change",@"0",@"fee", nil];
            }
            

        }
        
         [[NSNotificationCenter defaultCenter]postNotificationName:@"changedine" object:self userInfo:_notdict];
        
    };

    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return autoScaleH(45);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 50;
}
- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView * headSectionview = [[UIView alloc]init];
    UIButton * chooseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [chooseBtn setTitle:@"重新选时选座" forState:UIControlStateNormal];
    [chooseBtn setTitleColor:UIColorFromRGB(0xfd7577) forState:UIControlStateNormal];
    chooseBtn.titleLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [chooseBtn addTarget:self action:@selector(AgainChoose) forControlEvents:UIControlEventTouchUpInside];
    [headSectionview addSubview:chooseBtn];
    chooseBtn.sd_layout.leftSpaceToView(headSectionview,autoScaleW(10)).topSpaceToView(headSectionview,autoScaleH(5)).widthIs(autoScaleW(100)).heightIs(autoScaleH(20));
    
    UILabel * titleLabel = [[UILabel alloc]init];
    titleLabel.text = @"已选菜单";
    titleLabel.font = [UIFont systemFontOfSize:autoScaleW(16)];
    titleLabel.textColor = [UIColor lightGrayColor];
    [headSectionview addSubview:titleLabel];
    titleLabel.sd_layout.centerXEqualToView(headSectionview).topEqualToView(chooseBtn).widthIs(autoScaleW(80)).heightIs(autoScaleH(20));
    
    if (_dictary.count!=0) {
        UIButton * leftbtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [leftbtn addTarget:self action:@selector(RemoveDine) forControlEvents:UIControlEventTouchUpInside];
        [headSectionview addSubview:leftbtn];
        leftbtn.sd_layout.rightSpaceToView(headSectionview,autoScaleW(10)).topSpaceToView(headSectionview,autoScaleH(7)).widthIs(autoScaleW(50)).heightIs(autoScaleH(25));
        
        UILabel * qklabel = [[UILabel alloc]init];
        qklabel.text = @"清空";
        qklabel.textColor = UIColorFromRGB(0xfd7577);
        qklabel.font =  [UIFont systemFontOfSize:autoScaleW(15)];
        [leftbtn addSubview:qklabel];
        qklabel.sd_layout.leftEqualToView(leftbtn).topEqualToView(leftbtn).widthIs(40).heightIs(15);
        
        UIImageView * qkimage = [[UIImageView alloc]init];
        qkimage.image = [UIImage imageNamed:@"垃圾桶"];
        [leftbtn addSubview:qkimage];
        qkimage.sd_layout.leftSpaceToView(qklabel,autoScaleW(3)).topEqualToView(qklabel).widthIs(15).heightIs(15);
        
    }
    
    
    return headSectionview;
}
//重新选时选做
- (void)AgainChoose
{
    _notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"choose",@"change",@"0",@"fee", nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changedine" object:self userInfo:_notdict];
    
}
// 清空
- (void)RemoveDine
{
    [_dictary removeAllObjects];
    [_detailtable reloadData];
    
     _notdict = [NSDictionary dictionaryWithObjectsAndKeys:_dictary,@"ary",@"remove",@"change",@"0",@"fee", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changedine" object:self userInfo:_notdict];
}
// 手势方法
- (void)Remove{
    
    [self removeFromSuperview];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"removeView" object:nil];
}

//点击空白地方消失
#pragma mark 判断手势跟cell方法是否冲突
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableView"]) {
        //返回为NO则屏蔽手势事件
        return NO;
    }
    return YES;
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
