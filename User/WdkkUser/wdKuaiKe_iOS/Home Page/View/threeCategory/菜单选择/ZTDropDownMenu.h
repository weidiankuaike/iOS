//
//  ZTDropDownMenu.h
//  ZTDropDownMenu
//
//  Created by ZT  on 15-1-12.
//  Copyright (c) 2015年 ZT . All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>

@interface ZTIndexPath : NSObject

@property (nonatomic, assign) NSInteger column;
@property (nonatomic, assign) NSInteger leftOrRight;
@property (nonatomic, assign) NSInteger leftRow;
@property (nonatomic, assign) NSInteger row;
- (instancetype)initWithColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;
+ (instancetype)indexPathWithCol:(NSInteger)col leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow row:(NSInteger)row;

@end

#pragma mark - data source protocol
@class ZTDropDownMenu;

@protocol ZTDropDownMenuDataSource <NSObject>

@required
- (NSInteger)menu:(ZTDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column leftOrRight:(NSInteger)leftOrRight leftRow:(NSInteger)leftRow;
- (NSString *)menu:(ZTDropDownMenu *)menu titleForRowAtIndexPath:(ZTIndexPath *)indexPath;
- (NSString *)menu:(ZTDropDownMenu *)menu titleForColumn:(NSInteger)column;
/**
 * 表视图显示时，左边表显示比例
 */
- (CGFloat)widthRatioOfLeftColumn:(NSInteger)column;
/**
 * 表视图显示时，是否需要两个表显示
 */
- (BOOL)haveRightTableViewInColumn:(NSInteger)column;

/**
 * 返回当前菜单左边表选中行
 */
- (NSInteger)currentLeftSelectedRow:(NSInteger)column;

@optional
//default value is 1
- (NSInteger)numberOfColumnsInMenu:(ZTDropDownMenu *)menu;

/**
 * 是否需要显示为UICollectionView 默认为否
 */
- (BOOL)displayByCollectionViewInColumn:(NSInteger)column;

@end

#pragma mark - delegate
@protocol ZTDropDownMenuDelegate <NSObject>
@optional
- (void)menu:(ZTDropDownMenu *)menu didSelectRowAtIndexPath:(ZTIndexPath *)indexPath;
@end

#pragma mark - interface
@interface ZTDropDownMenu : UIView <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@property (nonatomic, weak) id <ZTDropDownMenuDataSource> dataSource;
@property (nonatomic, weak) id <ZTDropDownMenuDelegate> delegate;

@property (nonatomic, strong) UIColor *indicatorColor;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *separatorColor;
/**
 *  the width of menu will be set to screen width defaultly
 *
 *  @param origin the origin of this view's frame
 *  @param height menu's height
 *
 *  @return menu
 */
- (instancetype)initWithOrigin:(CGPoint)origin andHeight:(CGFloat)height;
- (NSString *)titleForRowAtIndexPath:(ZTIndexPath *)indexPath;

@end
