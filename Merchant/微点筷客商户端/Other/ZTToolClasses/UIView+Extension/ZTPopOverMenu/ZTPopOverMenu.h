//
// ZTPopOverMenu.h
// ZTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 * ZTPopOverMenuDoneBlock
 *
 *  @param selectedIndex SlectedIndex
 */
typedef void (^ZTPopOverMenuDoneBlock)(NSInteger selectedIndex);
/**
 * ZTPopOverMenuDismissBlock
 */
typedef void (^ZTPopOverMenuDismissBlock)();

@class ZTPopOverMenuCell;
typedef void (^ZTPopOverMenuCellInitViewBlock)(ZTPopOverMenuCell *cell);

/**
 *  -----------------------ZTPopOverMenuConfiguration-----------------------
 */
@interface ZTPopOverMenuConfiguration : NSObject

@property (nonatomic, assign)CGFloat menuTextMargin;// Default is 6.
@property (nonatomic, assign)CGFloat menuIconMargin;// Default is 6.
@property (nonatomic, assign)CGFloat menuRowHeight;
@property (nonatomic, assign)CGFloat menuWidth;
@property (nonatomic, strong)UIColor *textColor;
@property (nonatomic, strong)UIColor *tintColor;
@property (nonatomic, strong)UIColor *borderColor;
@property (nonatomic, assign)CGFloat borderWidth;
@property (nonatomic, strong)UIFont *textFont;
@property (nonatomic, assign)NSTextAlignment textAlignment;
@property (nonatomic, assign)BOOL ignoreImageOriginalColor;// Default is 'NO', if sets to 'YES', images color will be same as textColor.
@property (nonatomic, assign)BOOL allowRoundedArrow;// Default is 'NO', if sets to 'YES', the arrow will be drawn with round corner.
@property (nonatomic, assign)NSTimeInterval animationDuration;
/** 动态给cell添加控件   (strong) **/
@property (nonatomic, strong) ZTPopOverMenuCellInitViewBlock addSubViewToCellBlock;
/**
 *  defaultConfiguration
 *
 *  @return curren configuration
 */
+ (ZTPopOverMenuConfiguration *)defaultConfiguration;

@end

/**
 *  -----------------------ZTPopOverMenuCell-----------------------
 */
@interface ZTPopOverMenuCell : UITableViewCell
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *menuNameLabel;
@end
/**
 *  -----------------------ZTPopOverMenuView-----------------------
 */
@interface ZTPopOverMenuView : UIControl
@property (nonatomic, strong) UITableView *menuTableView;
@end

/**
 *  -----------------------ZTPopOverMenu-----------------------
 */
@interface ZTPopOverMenu : NSObject


/**
 show method with sender without images

 @param sender sender
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with sender and image resouce Array
 
 @param sender sender
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event without images

 @param event event
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 show method for barbuttonitems with event and imageArray

 @param event event
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame without images

 @param senderFrame senderFrame
 @param menuArray menuArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                   doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
                dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 show method with SenderFrame and image resouce Array

 @param senderFrame senderFrame
 @param menuArray menuArray
 @param imageArray imageArray
 @param doneBlock doneBlock
 @param dismissBlock dismissBlock
 */
+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                  imageArray:(NSArray *)imageArray
                   doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
                dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock;

/**
 *  dismiss method
 */
+ (void) dismiss;

@end
