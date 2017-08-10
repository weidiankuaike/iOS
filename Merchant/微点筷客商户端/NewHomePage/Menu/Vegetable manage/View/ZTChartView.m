//
//  ZTChartView.m
//  merchantClient
//
//  Created by Skyer God on 2017/7/17.
//  Copyright © 2017年 张甜. All rights reserved.
//

#import "ZTChartView.h"

@interface ZTChartView ()<ChartViewDelegate>


@end
@implementation ZTChartView
{
    NSArray * colorArr;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initChartViewWithFrame:(CGRect)frame titleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr{
    self = [super initWithFrame:frame];
    if (self) {
         colorArr  = @[RGB(72, 117, 187),RGB(80, 156, 135),RGB(234, 158, 56),RGB(240, 90, 74),];
        //初始化表
        [self setupPieChartView:_chartView withTitleArr:titleArr percentArr:percentArr];
        //初始化可视化列表
        [self initWithTitleArr:titleArr percentArr:percentArr];
    }
    return self;
}
#pragma mark ------ init List   -------
- (void)initWithTitleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr{

    for (int i=0; i< titleArr.count; i++) {
        UILabel * titleLabel =[[UILabel alloc]init];
        titleLabel.text = titleArr[i];
        titleLabel.font = [UIFont systemFontOfSize:autoScaleW(13)];
        titleLabel.textColor = RGB(128, 128, 128);
        CGSize size = [titleLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:titleLabel.font,NSFontAttributeName, nil]];
        CGFloat wind = size.width;
        [self addSubview:titleLabel];
        titleLabel.sd_layout
        .leftSpaceToView(self,autoScaleW(35))
        .topSpaceToView(self,autoScaleH(50)+i*autoScaleH(30))
        .widthIs(wind)
        .heightIs(autoScaleH(25));

        UILabel * colorLabel = [[UILabel alloc]init];
        colorLabel.backgroundColor = colorArr[i];
        [self addSubview:colorLabel];
        colorLabel.sd_layout
        .leftSpaceToView(self,autoScaleW(17))
        .topSpaceToView(self,autoScaleH(58)+i*autoScaleH(30))
        .widthIs(autoScaleW(13))
        .heightIs(autoScaleH(13));
        
    }

}
#pragma mark ------ init Charts -------
- (void)setupPieChartView:(PieChartView *)chartView withTitleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr
{
    _chartView = [PieChartView new];
    [self addSubview:_chartView];
    _chartView.sd_layout
    .rightEqualToView(self)
    .topSpaceToView(self, 0)
    .widthIs(autoScaleW(230))
    .heightEqualToWidth();

    _chartView.legend.enabled = NO;
    _chartView.delegate = self;

    [_chartView setExtraOffsetsWithLeft:20.f top:0.f right:20.f bottom:0.f];
    [_chartView animateWithYAxisDuration:1.4 easingOption:ChartEasingOptionEaseOutBack];
    chartView.usePercentValuesEnabled = YES;
    chartView.drawSlicesUnderHoleEnabled = NO;
    chartView.holeRadiusPercent = 0.4;
    chartView.transparentCircleRadiusPercent = 0.61;
    chartView.chartDescription.enabled = YES;
    chartView.chartDescription.text = @"";
    [chartView setExtraOffsetsWithLeft:5.f top:10.f right:5.f bottom:5.f];

    chartView.drawCenterTextEnabled = YES;

    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.alignment = NSTextAlignmentCenter;

    NSMutableAttributedString *centerText = [[NSMutableAttributedString alloc] initWithString:@""];
    //    [centerText setAttributes:@{
    //                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f],
    //                                NSParagraphStyleAttributeName: paragraphStyle
    //                                } range:NSMakeRange(0, centerText.length)];
    //    [centerText addAttributes:@{
    //                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Light" size:11.f],
    //                                NSForegroundColorAttributeName: UIColor.grayColor
    //                                } range:NSMakeRange(10, centerText.length - 10)];
    [centerText addAttributes:@{
                                NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-LightItalic" size:11.f],
                                NSForegroundColorAttributeName: [UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]
                                } range:NSMakeRange(0, centerText.length)];
    chartView.centerAttributedText = centerText;

    chartView.drawHoleEnabled = YES;
    chartView.rotationAngle = 0.0;
    chartView.rotationEnabled = YES;
    chartView.highlightPerTapEnabled = YES;

    ChartLegend *l = chartView.legend;
    l.horizontalAlignment = ChartLegendHorizontalAlignmentRight;
    l.verticalAlignment = ChartLegendVerticalAlignmentTop;
    l.orientation = ChartLegendOrientationVertical;
    l.drawInside = NO;
    l.xEntrySpace = 7.0;
    l.yEntrySpace = 0.0;
    l.yOffset = 0.0;

    [self setDataCount:titleArr percentArr:percentArr];

}
-(void)updateChartViewWithTitleArr:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr{
    [self setDataCount:titleArr percentArr:percentArr];
}
- (void)setDataCount:(NSArray<NSString *> *)titleArr percentArr:(NSArray<NSString *> *)percentArr
{

    NSMutableArray *entries = [[NSMutableArray alloc] init];

    for (int i = 0; i < titleArr.count; i++)
    {
        [entries addObject:[[PieChartDataEntry alloc] initWithValue:[percentArr[i] floatValue] label:titleArr[i]]];
    }

    PieChartDataSet *dataSet = [[PieChartDataSet alloc] initWithValues:entries label:@"Election Results"];
    dataSet.sliceSpace = 2.0;

    // add a lot of colors
//
//    NSMutableArray *colors = [[NSMutableArray alloc] init];
//    [colors addObjectsFromArray:ChartColorTemplates.vordiplom];
//    [colors addObjectsFromArray:ChartColorTemplates.joyful];
//    [colors addObjectsFromArray:ChartColorTemplates.colorful];
//    [colors addObjectsFromArray:ChartColorTemplates.liberty];
//    [colors addObjectsFromArray:ChartColorTemplates.pastel];
//    [colors addObject:[UIColor colorWithRed:51/255.f green:181/255.f blue:229/255.f alpha:1.f]];

    dataSet.colors = colorArr;

    dataSet.valueLinePart1OffsetPercentage = 0.8;
    dataSet.valueLinePart1Length = 0.2;
    dataSet.valueLinePart2Length = 0.4;
    //dataSet.xValuePosition = PieChartValuePositionOutsideSlice;
    dataSet.yValuePosition = PieChartValuePositionOutsideSlice;

    PieChartData *data = [[PieChartData alloc] initWithDataSet:dataSet];

    NSNumberFormatter *pFormatter = [[NSNumberFormatter alloc] init];
    pFormatter.numberStyle = NSNumberFormatterPercentStyle;
    pFormatter.maximumFractionDigits = 1;
    pFormatter.multiplier = @1.f;
    pFormatter.percentSymbol = @" %";
    [data setValueFormatter:[[ChartDefaultValueFormatter alloc] initWithFormatter:pFormatter]];
    [data setValueFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:11.f]];
    [data setValueTextColor:UIColor.blackColor];

    _chartView.data = data;
    [_chartView highlightValues:nil];
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

@end
