//
//  DishdetailView.m
//  wdKuaiKe_iOS
//
//  Created by 张森森 on 17/4/28.
//  Copyright © 2017年 weiDianKuaiKe. All rights reserved.
//

#import "DishdetailView.h"
#import "ShoppingCartSingletonView.h"
#import "ShoppingCartView.h"
#import "ThrowLineTool.h"
@implementation DishdetailView


- (id)initWithFrame:(CGRect)frame withString:(NSString *)string{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBA(0, 0, 0, 0.4);
        _numberstr = string;
        
        [self CreatView:frame];
    }
    
    return self;
}
/**
 *  抛物线小红点
 *
 *  @return
 */
- (UIImageView *)redView
{
    if (!_redView) {
        _redView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        _redView.image = [UIImage imageNamed:@"红色"];
        _redView.layer.cornerRadius = 10;
    }
    return _redView;
}
-(void)CreatView:(CGRect )frame{
    
    
    _bigView = [[UIView alloc]init];
    _bigView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bigView];

    _headimage = [[UIImageView alloc]init];
    [_bigView addSubview:_headimage];
    
    _namelabel = [[UILabel alloc]init];
    _namelabel.backgroundColor = [UIColor whiteColor];
    _namelabel.textColor = [UIColor blackColor];
    [_bigView addSubview:_namelabel];
    
    _numberLabel = [[UILabel alloc]init];
    _numberLabel.textColor = [UIColor lightGrayColor];
    _numberLabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_bigView addSubview:_numberLabel];
    
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.textColor = UIColorFromRGB(0xfd7577);
    [_bigView addSubview:_priceLabel];
    
    _linelabel = [[UILabel alloc]init];
    _linelabel.backgroundColor = UIColorFromRGB(0xeeeeee);
    [_bigView addSubview:_linelabel];
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setBackgroundImage:[UIImage imageNamed:@"菜品取消"] forState:UIControlStateNormal];
    [_cancelBtn addTarget:self action:@selector(Cancel) forControlEvents:UIControlEventTouchUpInside];
    [_bigView addSubview:_cancelBtn];
    
    _goodslabel = [[UILabel alloc]init];
    _goodslabel.text = @"商品信息";
    _goodslabel.textColor = [UIColor blackColor];
    _goodslabel.font = [UIFont systemFontOfSize:autoScaleW(15)];
    [_bigView addSubview:_goodslabel];
    
    _addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_addBtn setBackgroundImage:[UIImage imageNamed:@"加号"] forState:UIControlStateNormal];
    [_bigView addSubview:_addBtn];
    
    
    self.dishnumlabel = [[UILabel alloc] init];
    self.dishnumlabel.text = _numberstr;
    self.dishnumlabel.textColor = [UIColor blackColor];
    self.dishnumlabel.font = [UIFont systemFontOfSize:14];
    self.dishnumlabel.textAlignment = NSTextAlignmentCenter;
    [_bigView addSubview:self.dishnumlabel];
    
    
    self.subtract = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.subtract setBackgroundImage:[UIImage imageNamed:@"减号"] forState:UIControlStateNormal];
    [_bigView addSubview:_subtract];
    
    [self.addBtn addTarget:self action:@selector(clickAddBT:) forControlEvents:UIControlEventTouchUpInside];
    [self.subtract addTarget:self action:@selector(clickSubBT:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([_numberstr isEqualToString:@""]||[_numberstr isEqualToString:@"0"]) {
        
        self.subtract.hidden = YES;
        self.dishnumlabel.hidden = YES;
    }
    
    
    [self initFrame];
    
}
- (void)initFrame{

    
     _bigView.frame = CGRectMake(self.frame.size.width/10, self.frame.size.height/8, self.frame.size.width- (self.frame.size.width/10)*2, self.frame.size.height- (self.frame.size.height/5)*2);
    
    _headimage.sd_layout.leftEqualToView(_bigView).rightEqualToView(_bigView).topEqualToView(_bigView).heightIs(_bigView.height_sd/2);
    
    _namelabel.sd_layout.leftSpaceToView(_bigView,autoScaleW(15)).topSpaceToView(_headimage,autoScaleH(15)).heightIs(autoScaleH(25));
    [_namelabel setSingleLineAutoResizeWithMaxWidth:300];
    
    _numberLabel.sd_layout.leftEqualToView(_namelabel).topSpaceToView(_namelabel,autoScaleH(10)).heightIs(autoScaleH(20));
    [_numberLabel setSingleLineAutoResizeWithMaxWidth:150];
    
    _priceLabel.sd_layout.leftEqualToView(_numberLabel).topSpaceToView(_numberLabel,autoScaleH(10)).heightIs(autoScaleH(20));
    [_priceLabel setSingleLineAutoResizeWithMaxWidth:200];
    
    _linelabel.sd_layout.leftEqualToView(_bigView).rightEqualToView(_bigView).topSpaceToView(_priceLabel,autoScaleH(10)).heightIs(1);
    
    _cancelBtn.sd_layout.rightSpaceToView(_bigView,autoScaleW(-10)).topSpaceToView(_bigView,autoScaleH(-10)).widthIs(autoScaleW(30)).heightIs(autoScaleH(30));
    
    _goodslabel.sd_layout.leftSpaceToView(_bigView,autoScaleW(15)).topSpaceToView(_linelabel,autoScaleH(10)).widthIs(autoScaleW(80)).heightIs(autoScaleH(20));
    
    self.addBtn.sd_layout.topSpaceToView(_headimage,autoScaleH(40)) .widthIs(25).heightIs(25).rightSpaceToView(_bigView, 15);
    
    self.dishnumlabel.sd_layout
    .rightSpaceToView(_addBtn, 3)
    .topEqualToView(_addBtn)
    .heightIs(25);
    [self.dishnumlabel setSingleLineAutoResizeWithMaxWidth:40];
    
    self.subtract.sd_layout
    .rightSpaceToView(_dishnumlabel,3)
    .topEqualToView(_dishnumlabel)
    .heightIs(25)
    .widthIs(25);
  
    
}
- (void)setModel:(DishesDetailModel *)model{
    _model = model;
    
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_model.images]]) {
        
        [_headimage sd_setImageWithURL:[NSURL URLWithString:_model.images]placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    }else{
        
        NSString * imageStr = [model.images stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [_headimage sd_setImageWithURL:[NSURL URLWithString:imageStr] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
    }
    
    _namelabel.text = _model.productName;
    _numberLabel.text = [NSString stringWithFormat:@"月售：%@",_model.sales] ;
    _priceLabel.text =  [NSString stringWithFormat:@"￥%@",_model.fee];
    
}
- (void)Cancel{
    
    _IsExist = NO;
    if (self.block) {
        
        self.block(_num,_sum,_dishdict,YES,_IsExist);
    }
    [self removeFromSuperview];
    
}
- (void)clickAddBT:(UIButton *)sender{
    self.number = [self.dishnumlabel.text intValue];
    self.number +=1;
    _sum = _sum + [_model.fee floatValue];
    _num +=1;
    [self showOrderNumbers:self.number];
    
    if (_pushint==1) {
        CGRect parentRectA = [self convertRect:sender.frame toView:self];
        CGRect parentRectB = [[ShoppingCartSingletonView shareManagerWithParentView:self] convertRect:[ShoppingCartSingletonView shareManagerWithParentView:self].shoppingCartBtn.frame toView:self];
        sender.adjustsImageWhenHighlighted = NO;
        
        [self addSubview:self.redView];
        [[ThrowLineTool sharedTool] throwObject:self.redView from:parentRectA.origin to:parentRectB.origin];
        
        
        [[ShoppingCartSingletonView shareManagerWithParentView:self] convertRect:[ShoppingCartSingletonView shareManagerWithParentView:self].shoppingCartBtn.frame toView:self];
        
    }
    
    
    if (_dishdict.count!=0) {
        
        
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        
        [dict setObject:_model.images forKey:@"image"];
        [dict setObject:_model.productName forKey:@"name"];
        [dict setObject:_model.fee forKey:@"fee"];
        [dict setObject:self.dishnumlabel.text forKey:@"number"];
        [dict setObject:_indexstr forKey:@"index"];
        
        [dict setObject:_model.productId forKey:@"id"];
        
        [_dishdict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
           
            if ([_dishdict[idx][@"name"] isEqualToString:_model.productName]) {
                
//                [dict setValue:[NSString stringWithFormat:@"%ld",self.number] forKey:@"number"];
                [_dishdict removeObjectAtIndex:idx];
                //修改该菜品信息
            }
        }];
        
        [_dishdict addObject:dict];

    }
    else{
        
        _dishdict = [NSMutableArray array];
        NSMutableDictionary * dict = [NSMutableDictionary dictionary];
        [dict setObject:_model.images forKey:@"image"];
        [dict setObject:_model.productName forKey:@"name"];
        [dict setObject:_model.fee forKey:@"fee"];
        [dict setObject:self.dishnumlabel.text forKey:@"number"];
        [dict setObject:_indexstr forKey:@"index"];
        
        [dict setObject:_model.productId forKey:@"id"];
        
        [_dishdict addObject:dict];
        
    }
    if (self.block) {
        
        self.block(_num,_sum,_dishdict,YES,_IsExist);
    }
    
    
}
- (void)clickSubBT:(UIButton *)sender{
    
    self.number = [self.dishnumlabel.text intValue];
    self.number -=1;
    [self showOrderNumbers:self.number];
    
    _sum = _sum - [_model.fee floatValue];
    _num -=1;
    

// 切记不能用 for循环或者便利 ，一边遍历 一遍修改数组的值 会报错
    [_dishdict enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        NSMutableDictionary * dict = _dishdict[idx];
        
        if ([dict[@"name"] isEqualToString:_model.productName]) {
            if (self.number ==0) {
                
                [_dishdict removeObject:dict];
            }
            else{
                [dict setValue:[NSString stringWithFormat:@"%ld",self.number] forKey:@"number"];
            }
        }
        
    }];
    
    if (self.block) {
        
        self.block(_num,_sum,_dishdict,NO,_IsExist);
    }

}

-(void)showOrderNumbers:(NSUInteger)count
{
    self.dishnumlabel.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.number];
    if (self.number > 0)
    {
        [self.subtract setHidden:NO];
        [self.dishnumlabel setHidden:NO];
    }
    else
    {
        [self.subtract setHidden:YES];
        [self.dishnumlabel setHidden:YES];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
