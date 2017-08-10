//
//  JudgeTableViewCell.m
//  微点筷客商户端
//
//  Created by 张森森 on 16/10/19.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "JudgeTableViewCell.h"
#import "JudgeModel.h"
#import "MBProgressHUD+SS.h"
#import "SDWeiXinPhotoContainerView.h"
#import "ZTAlertSheetView.h"
#import "ReportViewController.h"
#import "MerchantCommentCell.h"
#import "NSString+TimeHandle.h"
#define start_x 15.0
#define start_y 5
#define mulit_start_y 5 + 8
@interface JudgeTableViewCell ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>{
    UITextField *_textFiled;
    NSInteger tempTag;
}
/** 评价   (strong) **/
@property (nonatomic, strong) SDWeiXinPhotoContainerView *picContainerView;
/** 评价区   (strong) **/
@property (nonatomic, strong) UITableView *commentView;
/** commentTagView   (strong) **/
@property (nonatomic, strong) UIView *conmmentTagV;
/** recommandDishesTagV   (strong) **/
@property (nonatomic, strong) UIView *recommandTagV;
/** 举报   (strong) **/
@property (nonatomic, strong) ButtonStyle *reportBT;
/** 星星数珠   (strong) **/
@property (nonatomic, strong) NSMutableArray *starImageArr;
/** 恢复   (strong) **/
@property (nonatomic, strong) ButtonStyle * responseBT;
/** textField   (strong) **/
@property (nonatomic, strong) UIView *textFiledView;
///** 回复评论视图   (strong) **/
//@property (nonatomic, strong) UIView *commentView;
/** 保存每个cell 的高度   (strong) **/
@property (nonatomic, strong) NSMutableArray *temCellHeightArr;
@end

@implementation JudgeTableViewCell

-(UILabel *)commentLabel{
    if (!_commentLabel) {
        //评价详情 可能有
        _commentLabel = [[UILabel alloc]init];
        _commentLabel.font =[UIFont systemFontOfSize:13];
        _commentLabel.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
        _commentLabel.numberOfLines = 0;
        [self.contentView addSubview:_commentLabel];
    }
    return _commentLabel;
}
-(SDWeiXinPhotoContainerView *)picContainerView{
    if (!_picContainerView) {
        _picContainerView = [SDWeiXinPhotoContainerView new];
        [self.contentView addSubview:_picContainerView];
    }
    return _picContainerView;
}
-(UIView *)conmmentTagV{
    if (!_conmmentTagV) {
        NSArray *tagArr = [_model.tag componentsSeparatedByString:@","];
        _conmmentTagV = [[UIView alloc] init];
        _conmmentTagV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_conmmentTagV];
        for (int i =0; i<tagArr.count - 1 ; i++) {

            UILabel *conmmentTag = [[UILabel alloc]init];
            conmmentTag.text = [NSString stringWithFormat:@"  %@  ", tagArr[i]];
            conmmentTag.textColor = [UIColor grayColor];
            conmmentTag.font= [UIFont systemFontOfSize:autoScaleW(9)];
            [_conmmentTagV addSubview:conmmentTag];

            conmmentTag.sd_layout
            .leftSpaceToView(_conmmentTagV, i * autoScaleW(75))
            .topSpaceToView(_conmmentTagV, 0)
            .heightIs(autoScaleH(15));
            [conmmentTag setSingleLineAutoResizeWithMaxWidth:100];
            [conmmentTag setSd_cornerRadiusFromHeightRatio:@(0.1)];
            conmmentTag.layer.borderWidth = 0.5;
            conmmentTag.layer.borderColor = RGB(205, 205, 205).CGColor;
        }
        _conmmentTagV.sd_layout
        .leftEqualToView(_nameLabel)
        .rightSpaceToView(self.contentView, start_x)
        .heightIs(autoScaleH(15));
    }
    return _conmmentTagV;
}
-(UIView *)recommandTagV{
    if (!_recommandTagV) {
        _recommandTagV = [[UIView alloc] init];
        _recommandTagV.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_recommandTagV];


        NSArray *recommArr = [_model.likeFood componentsSeparatedByString:@","];
        if (recommArr.count > 3) {
            recommArr = [recommArr subarrayWithRange:NSMakeRange(0, 2)];
        }
        for (int i =0; i<recommArr.count; i++) {
            ButtonStyle *reconBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
            [reconBT setImage:[UIImage imageNamed:@"赞"] forState:UIControlStateNormal];
            [reconBT setTitle:recommArr[i] forState:UIControlStateNormal];
            [reconBT setTitleColor:RGB(242, 164, 65) forState:UIControlStateNormal];
            reconBT.enabled = NO;
            [reconBT.titleLabel setFont:[UIFont systemFontOfSize:11]];
            [_recommandTagV addSubview:reconBT];

            CGFloat width = [recommArr[i] calculateStringWithFontSize:11].width + 15;
            reconBT.sd_layout
            .topEqualToView(_recommandTagV)
            .leftSpaceToView(_recommandTagV, i * (width + 10))
            .heightIs(15)
            .widthIs(width);
            //            [reconBT setupAutoSizeWithHorizontalPadding:3 buttonHeight:15];
            [reconBT setSd_cornerRadiusFromHeightRatio:@(0.1)];
            reconBT.layer.borderWidth = 0.5;
            reconBT.layer.borderColor = RGB(242, 164, 65).CGColor;
        }
        _recommandTagV.sd_layout
        .leftEqualToView(_nameLabel)
        .rightSpaceToView(self.contentView, start_x)
        .heightIs(15);
    }
    return _recommandTagV;
}
-(UITableView *)commentView {

    if (!_commentView) {
        _commentView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _commentView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.6];
        _commentView.delegate = self;
        _commentView.dataSource = self;
        _commentView.separatorStyle = 0;
        _commentView.bounces = NO;
//        _commentView.estimatedRowHeight = 100;
//        _commentView.rowHeight = UITableViewAutomaticDimension;
        
    }
    [self.contentView addSubview:_commentView];
    _commentView.sd_layout
    .leftEqualToView(_nameLabel)
    .rightSpaceToView(self.contentView, start_x)
    .heightIs([self getCommentViewSumHeightWith:_model.merchantReply]);
    return _commentView;
}
-(UIView *)textFiledView{
    if (!_textFiledView) {
        UIViewController *parentVC = [self viewController];
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        CGFloat buttonWidth = autoScaleW(60);
        CGFloat height = autoScaleH(40);

        _textFiledView = [[UIView alloc] init];
        _textFiledView.backgroundColor = [UIColor whiteColor];
        [parentVC.view addSubview:_textFiledView];
        _textFiledView.layer.borderWidth = 0.6;
        _textFiledView.layer.borderColor = [UIColor lightGrayColor].CGColor;

        _textFiled = [[UITextField alloc] init];
        _textFiled.backgroundColor = [UIColor lightTextColor];
        _textFiled.placeholder = @"输入内容";
        _textFiled.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        _textFiled.textAlignment = NSTextAlignmentCenter;
        _textFiled.delegate = self;
        _textFiled.font = [UIFont systemFontOfSize:14];
        _textFiled.returnKeyType = UIReturnKeyDone;
        _textFiled.inputAccessoryView = [[UIView alloc] init];
        //        _textFiled.keyboardType = UIKeyboardTypeNumberPad;
        [_textFiledView addSubview:_textFiled];

        ButtonStyle *submitButton = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [submitButton setTitle:@"提交" forState:UIControlStateNormal];
        [submitButton setBackgroundColor:UIColorFromRGB(0xfd7577)];
        [submitButton addTarget:self action:@selector(submitBTClick:) forControlEvents:UIControlEventTouchUpInside];
        [_textFiledView addSubview:submitButton];

        _textFiledView.sd_layout
        .leftEqualToView(parentVC.view)
        .rightEqualToView(parentVC.view)
        .bottomEqualToView(parentVC.view)
        .heightIs(height);

        _textFiled.sd_layout
        .leftEqualToView(_textFiledView)
        .centerYEqualToView(_textFiledView)
        .widthIs(width - buttonWidth)
        .heightRatioToView(_textFiledView, 1);


        submitButton.sd_layout
        .leftSpaceToView(_textFiled, 0)
        .rightEqualToView(self.contentView)
        .centerYEqualToView(_textFiledView)
        .heightRatioToView(_textFiledView, 1);

        [_textFiled becomeFirstResponder];
    }
    return _textFiledView;
}
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *topLabel =[[UILabel alloc] init];
        topLabel.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.5];
        [self.contentView addSubview:topLabel];

        topLabel.sd_layout
        .leftSpaceToView(self.contentView, start_x - 5)
        .rightSpaceToView(self.contentView, start_x - 5)
        .topEqualToView(self.contentView)
        .heightIs(1);

        //用户图像
        _userImageV =[[UIImageView alloc]init];
        [self.contentView addSubview:_userImageV];
        //用户名
        _nameLabel = [[UILabel alloc]init];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textColor = [UIColor lightGrayColor];
        [self.contentView addSubview:_nameLabel];
        _nameLabel.contentMode = UIControlContentVerticalAlignmentTop;
        //时间
        _timelabel =[[UILabel alloc]init];
        _timelabel.textColor = [UIColor blackColor];
        _timelabel.font = [UIFont systemFontOfSize:11];
        [self.contentView addSubview:_timelabel];

        _reportBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        [_reportBT setImage:[UIImage imageNamed:@"下"] forState:UIControlStateNormal];
        [_reportBT addTarget:self action:@selector(reportClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_reportBT];

        _userImageV.sd_layout
        .leftSpaceToView(self.contentView, start_x)
        .topSpaceToView(topLabel, start_x)
        .widthIs(35)
        .heightIs(35);
//        _userImageV.layer.shouldRasterize = YES;
//        _userImageV.layer.rasterizationScale = [UIScreen mainScreen].scale;
//        _userImageV.layer.minificationFilter = kCAFilterNearest;
        [_userImageV setSd_cornerRadiusFromHeightRatio:@(0.5)];

        _nameLabel.sd_layout
        .leftSpaceToView(_userImageV, 10)
        .topEqualToView(_userImageV)
        .heightIs(15);
        [_nameLabel setSingleLineAutoResizeWithMaxWidth:120];
        [_nameLabel setMaxNumberOfLinesToShow:2];

        _reportBT.sd_layout
        .rightSpaceToView(self.contentView, start_x)
        .centerYEqualToView(_nameLabel)
        .heightRatioToView(_nameLabel, 1.5)
        .widthEqualToHeight(0);


        //星星
        //        UIView *starView = [self createCommentViewStarImageWithScore:_model.score starIcon:@"x" halfStarIcon:@"半" behindStarIcon:@"56" ];
        CGFloat width = 10;
        CGFloat space = 3;
        _starImageArr = [NSMutableArray array];
        for (int i =0; i<5; i++) {

            UIImageView * starImageV = [[UIImageView alloc]init];
            starImageV.image = [UIImage imageNamed:@"56"];
            [self.contentView addSubview:starImageV];

            starImageV.sd_layout
            .rightSpaceToView(_reportBT, i * (space + width) + 10)
            .centerYEqualToView(_reportBT)
            .widthIs(autoScaleW(width))
            .heightIs(autoScaleH(width));

            if (i == 4) {
                _timelabel.sd_layout
                .topEqualToView(_nameLabel)
                .rightSpaceToView(starImageV, 20)
                .heightRatioToView(_nameLabel, 1);
                [_timelabel setSingleLineAutoResizeWithMaxWidth:120];
            }
            [_starImageArr addObject:starImageV];
        }

        _responseBT = [ButtonStyle buttonWithType:UIButtonTypeCustom];
        _responseBT.backgroundColor = RGB(238, 238, 238);
        _responseBT.layer.masksToBounds = YES;
        _responseBT.layer.cornerRadius = 3;
        [_responseBT setTitle:@"回复" forState:UIControlStateNormal];
        [_responseBT setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _responseBT.titleLabel.font = [UIFont systemFontOfSize:13];
        [_responseBT addTarget:self action:@selector(responseClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_responseBT];

        _responseBT.sd_layout
        .rightSpaceToView(self.contentView,start_x * 2)
        .topSpaceToView(_userImageV, 5)
        .widthIs(40)
        .heightIs(30);

        [self setupAutoHeightWithBottomViewsArray:@[_responseBT] bottomMargin:start_x];
    }
    return self;
}
-(void)setModel:(JudgeModel*)model
{

    _model = model;
    if (_model) {
        NSString *url = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:_model.avatar]] ? _model.avatar : [_model.avatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userImageV sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"loadingIcon"]];
        _nameLabel.text = _model.userName;
        _timelabel.text = [_model.createTime getDateTimeFromTimeStrWithOption:TIME_TO_DAY];

        CGFloat intRatio = [_model.score integerValue];
        CGFloat flRatio = [_model.score floatValue];
        CGFloat subRatio = flRatio - intRatio;
        for (int i =0; i<5; i++) {
            UIImageView * starImageV = _starImageArr[i];
            if (subRatio != 0 && subRatio < 0.5) {
                //半刻
                if ( i == 5 - 1 - intRatio) {
                    starImageV.image = [UIImage imageNamed:@"半"];
                } else if (i < 5 - 1 - intRatio) {
                    starImageV.image = [UIImage imageNamed:@"56"];
                } else {
                    starImageV.image = [UIImage imageNamed:@"x"];
                }
            } else if (subRatio >= 0.5) {
                if (i == intRatio + 1) {
                    starImageV.image = [UIImage imageNamed:@"x"];
                } else if (i < 5 - intRatio - 1) {
                    starImageV.image = [UIImage imageNamed:@"56"];
                } else {
                    starImageV.image = [UIImage imageNamed:@"x"];
                }
            } else {
                if (i < 5 - intRatio) {
                    [starImageV setImage:[UIImage imageNamed:@"56"]];
                } else {
                    starImageV.image = [UIImage imageNamed:@"x"];
                }
            }
        }
        [self updateMultiSubViews:model];
        [self setupAutoHeightWithBottomViewsArray:@[_responseBT, _timelabel, _userImageV] bottomMargin:start_x];
    }
}
//根据数据 和 懒加载结合 动态更新布局
- (void)updateMultiSubViews:(JudgeModel *)model {

    //如果有评论
    if (![model.content isNull]) {
        self.commentLabel.text = model.content;
        self.commentLabel.sd_layout
        .leftEqualToView(_nameLabel)
        .topSpaceToView(_nameLabel, start_y)
        .rightSpaceToView(self.contentView,start_x);
        [_commentLabel setAutoHeight:60];
        [_commentLabel setMaxNumberOfLinesToShow:4];
        [self updateResponseButtonFrameWithParentView:_commentLabel];
    }
    //有图片
    if (![model.evalImage isNull]) {
        NSMutableArray *arr = [NSMutableArray arrayWithArray:[model.evalImage componentsSeparatedByString:@","]];
        if (arr.count > 1) {
            [arr removeObjectAtIndex:arr.count - 1];
        }
        self.picContainerView.picPathStringsArray = arr;
        if (![model.content isNull]) {
            self.picContainerView.sd_layout
            .leftEqualToView(_commentLabel)
            .topSpaceToView(_commentLabel, start_y);
        } else {
            self.picContainerView.sd_layout
            .leftEqualToView(_nameLabel)
            .topSpaceToView(_nameLabel, mulit_start_y + 5);
        }
        [self updateResponseButtonFrameWithParentView:_picContainerView];
    }
    if (![model.tag isNull]) {
        if (_commentLabel == nil && _picContainerView == nil) {
            // 无 评论 和 图片
            self.conmmentTagV.sd_layout
            .topSpaceToView(_nameLabel, mulit_start_y);
        } else if (_picContainerView == nil) {
            //无 评论
            self.conmmentTagV.sd_layout
            .topSpaceToView(_commentLabel, mulit_start_y);
        } else {
            //无 图片 或者 都有
            self.conmmentTagV.sd_layout
            .topSpaceToView(_picContainerView, mulit_start_y);
        }
        [self updateResponseButtonFrameWithParentView:_conmmentTagV];
    }
    if (![model.likeFood isNull]) {
        if (_commentLabel == nil && _picContainerView == nil && _conmmentTagV == nil) {
            self.recommandTagV.sd_layout
            .topSpaceToView(_nameLabel, mulit_start_y);
        } else if ( _picContainerView == nil && _conmmentTagV == nil) {
            self.recommandTagV.sd_layout
            .topSpaceToView(_commentLabel, mulit_start_y);
        } else if ( _conmmentTagV == nil) {
            self.recommandTagV.sd_layout
            .topSpaceToView(_picContainerView, mulit_start_y);
        } else {
            self.recommandTagV.sd_layout
            .topSpaceToView(_conmmentTagV, start_y);
        }
        [self updateResponseButtonFrameWithParentView:_recommandTagV];
    }

    if (model.merchantReply.count != 0) {
        if (_commentLabel == nil && _picContainerView == nil && _conmmentTagV == nil && _recommandTagV == nil) {
            self.commentView.sd_layout
            .topSpaceToView(_nameLabel, mulit_start_y);
        } else if (_picContainerView == nil && _conmmentTagV == nil && _recommandTagV == nil) {
            self.commentView.sd_layout
            .topSpaceToView(_commentLabel, mulit_start_y); // 已经在内部实现高度自适应所以不需要再设置高度
        } else if (_conmmentTagV == nil && _recommandTagV == nil) {
            self.commentView.sd_layout
            .topSpaceToView(_picContainerView, mulit_start_y);
        } else if (_recommandTagV == nil) {
            self.commentView.sd_layout
            .topSpaceToView(_conmmentTagV, mulit_start_y);
        } else {
            self.commentView.sd_layout
            .topSpaceToView(_recommandTagV, mulit_start_y);
        }
        [self updateResponseButtonFrameWithParentView:_commentView];
    }
    //全为空
    if ([_model.content isNull] && [_model.evalImage isNull] && [_model.tag isNull] && [_model.likeFood isNull] && _model.merchantReply.count == 0) {
//        [self updateResponseButtonFrameWithParentView:_userImageV];
        _responseBT.sd_layout
        .topSpaceToView(_userImageV, 5);
    }
}
//更新恢复按钮布局
- (void)updateResponseButtonFrameWithParentView:(id)parentView{
    _responseBT.sd_layout
    .topSpaceToView(parentView, 5);
    [_responseBT updateLayout];
}
//举报
- (void)reportClick:(ButtonStyle *)sender{
    ZTAlertSheetView *sheet = [[ZTAlertSheetView alloc] initWithTitleArray:@[@"举报", @"取消"]];
    [sheet showView];

    sheet.alertSheetReturn = ^(NSInteger index) {
        if (index == 0) {
            //举报
            UIViewController *viewController = [self viewController];
            ReportViewController *report = [[ReportViewController alloc] init];
            [viewController.navigationController pushViewController:report animated:YES];
            report.namestring = _model.userName;
            report.judeidstr = _model.id;
            report.xqstring = _model.content;
        }
    };
}
//回复相应
- (void)responseClick:(ButtonStyle *)sender{
    [self notifiKeyboard];
    self.textFiledView.hidden = NO;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)notifiKeyboard{
    //增加监听，当键盘出现或改变时收出消息

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];

    //增加监听，当键退出时收出消息

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];


}
//当键盘出现或改变时调用

- (void)keyboardWillShow:(NSNotification *)aNotification
{
//    获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    self.textFiledView.hidden = NO;
    _textFiledView.sd_layout
    .spaceToSuperView(UIEdgeInsetsMake(0, 0, height, 0));
}
//提交 回复内容
- (void)submitBTClick:(ButtonStyle *)sender{
    if ([_textFiled.text isNull]) {
        [_textFiled resignFirstResponder];
    } else {
        NSString *keyUrl = @"api/merchant/addMerchantReply";
        NSString *uploadUrl = [NSString stringWithFormat:@"%@%@?token=%@&storeId=%@&userId=%@&evalId=%@&content=%@", kBaseURL, keyUrl, TOKEN, storeID, _BaseModel.id, _model.id, _textFiled.text];
          
        [[QYXNetTool shareManager] postNetWithUrl:uploadUrl urlBody:nil bodyStyle:QYXBodyString header:nil response:QYXJSON success:^(id result) {
             [_textFiled resignFirstResponder];
            if (![result[@"msgType"] isEqualToString:@"0"]) {
                [_textFiled becomeFirstResponder];
            }
            if (_reloadBlock) {
                _reloadBlock(YES);
            }
        } failure:^(NSError *error) {

        }];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
    [self submitBTClick:nil];
    return YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
//    [textField resignFirstResponder];

    _textFiledView.hidden = YES;
    _textFiledView = nil;
    [_textFiledView removeFromSuperview];
}
//当键退出时调用

- (void)keyboardWillHide:(NSNotification *)aNotification
{
    _textFiledView.hidden = YES;
    _textFiledView = nil;
    [_textFiledView removeFromSuperview];
}
- (UIViewController *)viewController {
    for (UIView* next = [self superview]; next; next = next.superview) {
        UIResponder *nextResponder = [next nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
    }
    return nil;
}
//计算整体cell的高度
- (CGFloat)getCommentViewSumHeightWith:(NSArray *)merchanatReplay{
    __block CGFloat tempHeight = 0;
    _temCellHeightArr = [NSMutableArray new];
    [merchanatReplay enumerateObjectsUsingBlock:^(CommentModel *_Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat sumWidth =   [UIScreen mainScreen].bounds.size.width - autoScaleW(50);
        CGFloat width = autoScaleW(70);
        CGFloat contentWidth = sumWidth - width;
        CGFloat height = [model.content sizeWithFont:[UIFont systemFontOfSize:12] constrainedToWidth:contentWidth].height;
        tempHeight += height;
        [_temCellHeightArr addObject:@(height)];
    }];
    return tempHeight;
}
#pragma mark ---------  评论信息 －－－－－－－
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _model.merchantReply.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    CommentModel *model = _model.merchantReply[indexPath.row];
    CGFloat height = [_temCellHeightArr[indexPath.row] floatValue];
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = [NSString stringWithFormat:@"%ldcell", (long)indexPath.row];
    MerchantCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[MerchantCommentCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.model = _model.merchantReply[indexPath.row];
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:tableView];
    return cell;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
