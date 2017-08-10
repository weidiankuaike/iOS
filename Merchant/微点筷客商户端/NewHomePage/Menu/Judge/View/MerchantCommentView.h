//
//  MerchantCommentView.h
//  微点筷客商户端
//
//  Created by Skyer God on 17/2/10.
//  Copyright © 2017年 张森森. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MerchantCommentView : UIView
/** 评论数珠   (strong) **/
@property (nonatomic, strong) NSArray *commentArr;
+(void)getCommentArrCount:(NSInteger )count;
@end
