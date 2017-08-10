//
// ZTPopOverMenu.m
// ZTPopOverMenu
//
//  Created by liufengting on 16/4/5.
//  Copyright © 2016年 liufengting ( https://github.com/liufengting ). All rights reserved.
//

#import "ZTPopOverMenu.h"

// changeable
#define ZTDefaultMargin                     autoScaleW(4.0f)
#define ZTDefaultMenuTextMargin             autoScaleW(6.f)
#define ZTDefaultMenuIconMargin             autoScaleW(6.f)
#define ZTDefaultMenuCornerRadius           autoScaleW(5.f)
#define ZTDefaultAnimationDuration          0.2
// unchangeable, change them at your own risk
#define KSCREEN_WIDTH                       [[UIScreen mainScreen] bounds].size.width
#define KSCREEN_HEIGHT                      [[UIScreen mainScreen] bounds].size.height
#define ZTDefaultBackgroundColor            [UIColor clearColor]
#define ZTDefaultTintColor                  [UIColor colorWithRed:80/255.f green:80/255.f blue:80/255.f alpha:1.f]
#define ZTDefaultTextColor                  [UIColor whiteColor]
#define ZTDefaultMenuFont                   [UIFont systemFontOfSize:autoScaleW(14.f)]
#define ZTDefaultMenuWidth                  autoScaleW(120.f)
#define ZTDefaultMenuIconSize               autoScaleW(18.f)
#define ZTDefaultMenuRowHeight              autoScaleH(40.f)
#define ZTDefaultMenuBorderWidth            0.8
#define ZTDefaultMenuArrowWidth             autoScaleW(8.f)
#define ZTDefaultMenuArrowHeight            autoScaleH(10.f)
#define ZTDefaultMenuArrowWidth_R           autoScaleW(12.f)
#define ZTDefaultMenuArrowHeight_R          autoScaleH(12.f)
#define ZTDefaultMenuArrowRoundRadius       autoScaleW(4.f)

static NSString  *const ZTPopOverMenuTableViewCellIndentifier = @"ZTPopOverMenuTableViewCellIndentifier";
static NSString  *const ZTPopOverMenuImageCacheDirectory = @"com.ZTPopOverMenuImageCache";
/**
 * ZTPopOverMenuArrowDirection
 */
typedef NS_ENUM(NSUInteger,ZTPopOverMenuArrowDirection) {
    /**
     *  Up
     */
   ZTPopOverMenuArrowDirectionUp,
    /**
     *  Down
     */
   ZTPopOverMenuArrowDirectionDown,
};

#pragma mark -ZTPopOverMenuConfiguration

@interface ZTPopOverMenuConfiguration ()

@end

@implementation ZTPopOverMenuConfiguration

+ (ZTPopOverMenuConfiguration *)defaultConfiguration
{
    static dispatch_once_t once = 0;
    static ZTPopOverMenuConfiguration *configuration;
    dispatch_once(&once, ^{ configuration = [[ZTPopOverMenuConfiguration alloc] init]; });
    return configuration;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.menuRowHeight =ZTDefaultMenuRowHeight;
        self.menuWidth =ZTDefaultMenuWidth;
        self.textColor =ZTDefaultTextColor;
        self.textFont =ZTDefaultMenuFont;
        self.tintColor =ZTDefaultTintColor;
        self.borderColor =ZTDefaultTintColor;
        self.borderWidth =ZTDefaultMenuBorderWidth;
        self.textAlignment = NSTextAlignmentLeft;
        self.ignoreImageOriginalColor = NO;
        self.allowRoundedArrow = NO;
        self.menuTextMargin =ZTDefaultMenuTextMargin;
        self.menuIconMargin =ZTDefaultMenuIconMargin;
        self.animationDuration =ZTDefaultAnimationDuration;
    }
    return self;
}

@end

#pragma mark -ZTPopOverMenuCell

@interface ZTPopOverMenuCell ()



@end

@implementation ZTPopOverMenuCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                    menuName:(NSString *)menuName
                   menuImage:(id )menuImage
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        
        [self setupWithMenuName:menuName menuImage:menuImage];
    }
    return self;
}

-(UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _iconImageView.backgroundColor = [UIColor clearColor];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _iconImageView;
}

-(UILabel *)menuNameLabel
{
    if (!_menuNameLabel) {
        _menuNameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _menuNameLabel.backgroundColor = [UIColor clearColor];
    }
    return _menuNameLabel;
}

-(void)setupWithMenuName:(NSString *)menuName menuImage:(id )menuImage
{
   ZTPopOverMenuConfiguration *configuration = [ZTPopOverMenuConfiguration defaultConfiguration];
    
    CGFloat margin = (configuration.menuRowHeight -ZTDefaultMenuIconSize)/2.f;
    CGRect iconImageRect = CGRectMake(configuration.menuIconMargin, margin,ZTDefaultMenuIconSize,ZTDefaultMenuIconSize);
    CGFloat menuNameX = iconImageRect.origin.x + iconImageRect.size.width + configuration.menuTextMargin;
    CGRect menuNameRect = CGRectMake(menuNameX, 0, configuration.menuWidth - menuNameX - configuration.menuTextMargin, configuration.menuRowHeight);
    
    if (!menuImage) {
        menuNameRect = CGRectMake(configuration.menuTextMargin, 0, configuration.menuWidth - configuration.menuTextMargin*2, configuration.menuRowHeight);
    }else{
        self.iconImageView.frame = iconImageRect;
        self.iconImageView.tintColor = configuration.textColor;
        
        [self getImageWithResource:menuImage
                        completion:^(UIImage *image) {
                            if (configuration.ignoreImageOriginalColor) {
                                image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
                            }
                            _iconImageView.image = image;
                        }];
        [self.contentView addSubview:self.iconImageView];
    }
    self.menuNameLabel.frame = menuNameRect;
    self.menuNameLabel.font = configuration.textFont;
    self.menuNameLabel.textColor = configuration.textColor;
    self.menuNameLabel.textAlignment = configuration.textAlignment;
    self.menuNameLabel.text = menuName;
    [self.contentView addSubview:self.menuNameLabel];

    if (configuration.addSubViewToCellBlock) {
        configuration.addSubViewToCellBlock(self);
    }
}

/**
 get image from local or remote
 
 @param resource image reource
 @param completion get image back
 */
-(void)getImageWithResource:(id)resource completion:(void (^)(UIImage *image))completion
{
    if ([resource isKindOfClass:[UIImage class]]) {
        completion(resource);
    }else if ([resource isKindOfClass:[NSString class]]) {
        if ([resource hasPrefix:@"http"]) {
            [self downloadImageWithURL:[NSURL URLWithString:resource] completion:completion];
        }else{
            completion([UIImage imageNamed:resource]);
        }
    }else if ([resource isKindOfClass:[NSURL class]]) {
        [self downloadImageWithURL:resource completion:completion];
    }else{
        NSLog(@"Image resource not recougnized.");
        completion(nil);
    }
}

/**
 download image if needed, cache image into disk if needed.
 
 @param url imageURL
 @param completion get image back
 */
-(void)downloadImageWithURL:(NSURL *)url completion:(void (^)(UIImage *image))completion
{
    if ([self isExitImageForImageURL:url]) {
        NSString *filePath = [self filePathForImageURL:url];
        completion([UIImage imageWithContentsOfFile:filePath]);
    }else{
        // download
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:url]];
            if (image) {
                NSData *data = UIImagePNGRepresentation(image);
                [data writeToFile:[self filePathForImageURL:url] atomically:YES];
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(image);
                });
            }
        });
    }
}

/**
 return if the image is downloaded and cached before
 
 @param url imageURL
 @return if the image is downloaded and cached before
 */
-(BOOL)isExitImageForImageURL:(NSURL *)url
{
    return [[NSFileManager defaultManager] fileExistsAtPath:[self filePathForImageURL:url]];
}

/**
 get local disk cash filePath for imageurl
 
 @param url imageURL
 @return filePath
 */
-(NSString *)filePathForImageURL:(NSURL *)url
{
    NSString *diskCachePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:ZTPopOverMenuImageCacheDirectory];
    if(![[NSFileManager defaultManager] fileExistsAtPath:diskCachePath]){
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:diskCachePath
                                  withIntermediateDirectories:YES
                                                   attributes:@{}
                                                        error:&error];
    }
    NSData *data = [url.absoluteString dataUsingEncoding:NSUTF8StringEncoding];
    NSString *pathComponent = [data base64EncodedStringWithOptions:NSUTF8StringEncoding];
    NSString *filePath = [diskCachePath stringByAppendingPathComponent:pathComponent];
    return filePath;
}

@end



#pragma mark -ZTPopOverMenuView

@interface ZTPopOverMenuView () <UITableViewDelegate,UITableViewDataSource>


@property (nonatomic, strong) NSArray<NSString *> *menuStringArray;
@property (nonatomic, strong) NSArray *menuImageArray;
@property (nonatomic, assign) ZTPopOverMenuArrowDirection arrowDirection;
@property (nonatomic, strong) ZTPopOverMenuDoneBlock doneBlock;
@property (nonatomic, strong) CAShapeLayer *backgroundLayer;


@property (nonatomic, strong) UIColor *tintColor;

@end

@implementation ZTPopOverMenuView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(UITableView *)menuTableView
{
    if (!_menuTableView) {
        _menuTableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _menuTableView.backgroundColor =ZTDefaultBackgroundColor;
        _menuTableView.separatorColor = [UIColor grayColor];
        _menuTableView.layer.cornerRadius =ZTDefaultMenuCornerRadius;
        _menuTableView.scrollEnabled = NO;
        _menuTableView.clipsToBounds = YES;
        _menuTableView.delegate = self;
        _menuTableView.dataSource = self;
        [self addSubview:_menuTableView];
    }
    return _menuTableView;
}

-(CGFloat)menuArrowWidth
{
    return [ZTPopOverMenuConfiguration defaultConfiguration].allowRoundedArrow ?ZTDefaultMenuArrowWidth_R :ZTDefaultMenuArrowWidth;
}
-(CGFloat)menuArrowHeight
{
    return [ZTPopOverMenuConfiguration defaultConfiguration].allowRoundedArrow ?ZTDefaultMenuArrowHeight_R :ZTDefaultMenuArrowHeight;
}

-(void)showWithFrame:(CGRect )frame
          anglePoint:(CGPoint )anglePoint
       withNameArray:(NSArray<NSString*> *)nameArray
      imageNameArray:(NSArray *)imageNameArray
    shouldAutoScroll:(BOOL)shouldAutoScroll
      arrowDirection:(ZTPopOverMenuArrowDirection)arrowDirection
           doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
{
    self.frame = frame;
    _menuStringArray = nameArray;
    _menuImageArray = imageNameArray;
    _arrowDirection = arrowDirection;
    self.doneBlock = doneBlock;
    self.menuTableView.scrollEnabled = shouldAutoScroll;
    
    
    CGRect menuRect = CGRectMake(0, self.menuArrowHeight, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    if (_arrowDirection ==ZTPopOverMenuArrowDirectionDown) {
        menuRect = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height - self.menuArrowHeight);
    }
    [self.menuTableView setFrame:menuRect];
    [self.menuTableView reloadData];
    
    [self drawBackgroundLayerWithAnglePoint:anglePoint];
}
-(void)drawBackgroundLayerWithAnglePoint:(CGPoint)anglePoint
{
    if (_backgroundLayer) {
        [_backgroundLayer removeFromSuperlayer];
    }
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    BOOL allowRoundedArrow = [ZTPopOverMenuConfiguration defaultConfiguration].allowRoundedArrow;
    CGFloat offset = 2.f*ZTDefaultMenuArrowRoundRadius*sinf(M_PI_4/2.f);
    CGFloat roundcenterHeight = offset +ZTDefaultMenuArrowRoundRadius*sqrtf(2.f);
    CGPoint roundcenterPoint = CGPointMake(anglePoint.x, roundcenterHeight);
    
    switch (_arrowDirection) {
        case ZTPopOverMenuArrowDirectionUp:{

            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight - 2.f*ZTDefaultMenuArrowRoundRadius) radius:2.f*ZTDefaultMenuArrowRoundRadius startAngle:M_PI_2 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x +ZTDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y -ZTDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:ZTDefaultMenuArrowRoundRadius startAngle:M_PI_4*7.f endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), self.menuArrowHeight - offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, self.menuArrowHeight - 2.f*ZTDefaultMenuArrowRoundRadius) radius:2.f*ZTDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_2 clockwise:YES];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, self.menuArrowHeight)];
            }
            
            [path addLineToPoint:CGPointMake(ZTDefaultMenuCornerRadius, self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(ZTDefaultMenuCornerRadius, self.menuArrowHeight +ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:-M_PI clockwise:NO];
            [path addLineToPoint:CGPointMake( 0, self.bounds.size.height -ZTDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(ZTDefaultMenuCornerRadius, self.bounds.size.height -ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:M_PI endAngle:M_PI_2 clockwise:NO];
            [path addLineToPoint:CGPointMake( self.bounds.size.width -ZTDefaultMenuCornerRadius, self.bounds.size.height)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width -ZTDefaultMenuCornerRadius, self.bounds.size.height -ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:0 clockwise:NO];
            [path addLineToPoint:CGPointMake(self.bounds.size.width ,ZTDefaultMenuCornerRadius + self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width -ZTDefaultMenuCornerRadius,ZTDefaultMenuCornerRadius + self.menuArrowHeight) radius:ZTDefaultMenuCornerRadius startAngle:0 endAngle:-M_PI_2 clockwise:NO];
            [path closePath];
            
        }break;
        case ZTPopOverMenuArrowDirectionDown:{
            
            roundcenterPoint = CGPointMake(anglePoint.x, anglePoint.y - roundcenterHeight);

            if (allowRoundedArrow) {
                [path addArcWithCenter:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*ZTDefaultMenuArrowRoundRadius) radius:2.f*ZTDefaultMenuArrowRoundRadius startAngle:M_PI_2*3 endAngle:M_PI_4*5.f clockwise:NO];
                [path addLineToPoint:CGPointMake(anglePoint.x +ZTDefaultMenuArrowRoundRadius/sqrtf(2.f), roundcenterPoint.y +ZTDefaultMenuArrowRoundRadius/sqrtf(2.f))];
                [path addArcWithCenter:roundcenterPoint radius:ZTDefaultMenuArrowRoundRadius startAngle:M_PI_4 endAngle:M_PI_4*3.f clockwise:YES];
                [path addLineToPoint:CGPointMake(anglePoint.x - self.menuArrowWidth + (offset * (1.f+1.f/sqrtf(2.f))), anglePoint.y - self.menuArrowHeight + offset/sqrtf(2.f))];
                [path addArcWithCenter:CGPointMake(anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight + 2.f*ZTDefaultMenuArrowRoundRadius) radius:2.f*ZTDefaultMenuArrowRoundRadius startAngle:M_PI_4*7 endAngle:M_PI_2*3 clockwise:NO];
            } else {
                [path moveToPoint:CGPointMake(anglePoint.x + self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
                [path addLineToPoint:anglePoint];
                [path addLineToPoint:CGPointMake( anglePoint.x - self.menuArrowWidth, anglePoint.y - self.menuArrowHeight)];
            }
            
            [path addLineToPoint:CGPointMake(ZTDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight)];
            [path addArcWithCenter:CGPointMake(ZTDefaultMenuCornerRadius, anglePoint.y - self.menuArrowHeight -ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
            [path addLineToPoint:CGPointMake( 0,ZTDefaultMenuCornerRadius)];
            [path addArcWithCenter:CGPointMake(ZTDefaultMenuCornerRadius,ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
            [path addLineToPoint:CGPointMake( self.bounds.size.width -ZTDefaultMenuCornerRadius, 0)];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width -ZTDefaultMenuCornerRadius,ZTDefaultMenuCornerRadius) radius:ZTDefaultMenuCornerRadius startAngle:-M_PI_2 endAngle:0 clockwise:YES];
            [path addLineToPoint:CGPointMake(self.bounds.size.width , anglePoint.y - (ZTDefaultMenuCornerRadius + self.menuArrowHeight))];
            [path addArcWithCenter:CGPointMake(self.bounds.size.width -ZTDefaultMenuCornerRadius, anglePoint.y - (ZTDefaultMenuCornerRadius + self.menuArrowHeight)) radius:ZTDefaultMenuCornerRadius startAngle:0 endAngle:M_PI_2 clockwise:YES];
            [path closePath];
            
        }break;
        default:
            break;
    }
    
    _backgroundLayer = [CAShapeLayer layer];
    _backgroundLayer.path = path.CGPath;
    _backgroundLayer.lineWidth = [ZTPopOverMenuConfiguration defaultConfiguration].borderWidth;
    _backgroundLayer.fillColor = [ZTPopOverMenuConfiguration defaultConfiguration].tintColor.CGColor;
    _backgroundLayer.strokeColor = [ZTPopOverMenuConfiguration defaultConfiguration].borderColor.CGColor;
    [self.layer insertSublayer:_backgroundLayer atIndex:0];
}


#pragma mark - UITableViewDelegate,UITableViewDataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.f;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ZTPopOverMenuConfiguration defaultConfiguration].menuRowHeight;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.f;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _menuStringArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id menuImage;
    if (_menuImageArray.count - 1 >= indexPath.row) {
        menuImage = _menuImageArray[indexPath.row];
    }
   ZTPopOverMenuCell *menuCell = [[ZTPopOverMenuCell alloc]initWithStyle:UITableViewCellStyleDefault
                                                          reuseIdentifier:ZTPopOverMenuTableViewCellIndentifier
                                                                 menuName:[NSString stringWithFormat:@"%@", _menuStringArray[indexPath.row]]
                                                                menuImage:menuImage];
    if (indexPath.row == _menuStringArray.count-1) {
        menuCell.separatorInset = UIEdgeInsetsMake(0, self.bounds.size.width, 0, 0);
    }else{
        menuCell.separatorInset = UIEdgeInsetsMake(0, [ZTPopOverMenuConfiguration defaultConfiguration].menuTextMargin, 0, [ZTPopOverMenuConfiguration defaultConfiguration].menuTextMargin);
    }
    return menuCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.doneBlock) {
        self.doneBlock(indexPath.row);
    }
}

@end


#pragma mark -ZTPopOverMenu

@interface ZTPopOverMenu () <UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * backgroundView;
@property (nonatomic, strong)ZTPopOverMenuView *popMenuView;
@property (nonatomic, strong)ZTPopOverMenuDoneBlock doneBlock;
@property (nonatomic, strong)ZTPopOverMenuDismissBlock dismissBlock;

@property (nonatomic, strong) UIView *sender;
@property (nonatomic, assign) CGRect senderFrame;
@property (nonatomic, strong) NSArray<NSString*> *menuArray;
@property (nonatomic, strong) NSArray<NSString*> *menuImageArray;
@property (nonatomic, assign) BOOL isCurrentlyOnScreen;

@end

@implementation ZTPopOverMenu

+ (ZTPopOverMenu *)sharedInstance
{
    static dispatch_once_t once = 0;
    static ZTPopOverMenu *shared;
    dispatch_once(&once, ^{ shared = [[ZTPopOverMenu alloc] init]; });
    return shared;
}

#pragma mark - Public Method

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showForSender:(UIView *)sender
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:sender senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromEvent:(UIEvent *)event
         withMenuArray:(NSArray<NSString*> *)menuArray
            imageArray:(NSArray *)imageArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:[event.allTouches.anyObject view] senderFrame:CGRectNull withMenu:menuArray imageNameArray:imageArray doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                   doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
                dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:nil doneBlock:doneBlock dismissBlock:dismissBlock];
}

+ (void) showFromSenderFrame:(CGRect )senderFrame
               withMenuArray:(NSArray<NSString*> *)menuArray
                  imageArray:(NSArray *)imageArray
                   doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
                dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    [[self sharedInstance] showForSender:nil senderFrame:senderFrame withMenu:menuArray imageNameArray:imageArray doneBlock:doneBlock dismissBlock:dismissBlock];
}

+(void)dismiss
{
    [[self sharedInstance] dismiss];
}

#pragma mark - Private Methods
- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(onChangeStatusBarOrientationNotification:)
                                                     name:UIApplicationDidChangeStatusBarOrientationNotification
                                                   object:nil];
    }
    return self;
}

- (UIWindow *)backgroundWindow
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    id<UIApplicationDelegate> delegate = [[UIApplication sharedApplication] delegate];
    if (window == nil && [delegate respondsToSelector:@selector(window)]){
        window = [delegate performSelector:@selector(window)];
    }
    return window;
}

-(UIView *)backgroundView
{
    if (!_backgroundView) {
        _backgroundView = [[UIView alloc ]initWithFrame:[UIScreen mainScreen].bounds];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onBackgroundViewTapped:)];
        tap.delegate = self;
        [_backgroundView addGestureRecognizer:tap];
        _backgroundView.backgroundColor =ZTDefaultBackgroundColor;
    }
    return _backgroundView;
}
-(ZTPopOverMenuView *)popMenuView
{
    if (!_popMenuView) {
        _popMenuView = [[ZTPopOverMenuView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        _popMenuView.alpha = 0;
    }
    return _popMenuView;
}

-(CGFloat)menuArrowWidth
{
    return [ZTPopOverMenuConfiguration defaultConfiguration].allowRoundedArrow ?ZTDefaultMenuArrowWidth_R :ZTDefaultMenuArrowWidth;
}
-(CGFloat)menuArrowHeight
{
    return [ZTPopOverMenuConfiguration defaultConfiguration].allowRoundedArrow ?ZTDefaultMenuArrowHeight_R :ZTDefaultMenuArrowHeight;
}

-(void)onChangeStatusBarOrientationNotification:(NSNotification *)notification
{
    if (self.isCurrentlyOnScreen) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self adjustPopOverMenu];
        });
    }
}

- (void) showForSender:(UIView *)sender
           senderFrame:(CGRect )senderFrame
              withMenu:(NSArray<NSString*> *)menuArray
        imageNameArray:(NSArray<NSString*> *)imageNameArray
             doneBlock:(ZTPopOverMenuDoneBlock)doneBlock
          dismissBlock:(ZTPopOverMenuDismissBlock)dismissBlock
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.backgroundView addSubview:self.popMenuView];
        [[self backgroundWindow] addSubview:self.backgroundView];
        
        self.sender = sender;
        self.senderFrame = senderFrame;
        self.menuArray = menuArray;
        self.menuImageArray = imageNameArray;
        self.doneBlock = doneBlock;
        self.dismissBlock = dismissBlock;
        
        [self adjustPopOverMenu];
    });
}

-(void)adjustPopOverMenu
{
    
    [self.backgroundView setFrame:CGRectMake(0, 0, KSCREEN_WIDTH, KSCREEN_HEIGHT)];
    
    CGRect senderRect ;
    
    if (self.sender) {
        senderRect = [self.sender.superview convertRect:self.sender.frame toView:self.backgroundView];
        // if run into touch problems on nav bar, use the fowllowing line.
        //        senderRect.origin.y = MAX(64-senderRect.origin.y, senderRect.origin.y);
    }else{
        senderRect = self.senderFrame;
    }
    if (senderRect.origin.y > KSCREEN_HEIGHT) {
        senderRect.origin.y = KSCREEN_HEIGHT;
    }
    
    CGFloat menuHeight = [ZTPopOverMenuConfiguration defaultConfiguration].menuRowHeight * self.menuArray.count + self.menuArrowHeight;
    CGPoint menuArrowPoint = CGPointMake(senderRect.origin.x + (senderRect.size.width)/2, 0);
    CGFloat menuX = 0;
    CGRect menuRect = CGRectZero;
    BOOL shouldAutoScroll = NO;
   ZTPopOverMenuArrowDirection arrowDirection;
    
    if (senderRect.origin.y + senderRect.size.height/2  < KSCREEN_HEIGHT/2) {
        arrowDirection =ZTPopOverMenuArrowDirectionUp;
        menuArrowPoint.y = 0;
    }else{
        arrowDirection =ZTPopOverMenuArrowDirectionDown;
        menuArrowPoint.y = menuHeight;
        
    }
    
    if (menuArrowPoint.x + [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth/2 +ZTDefaultMargin > KSCREEN_WIDTH) {
        menuArrowPoint.x = MIN(menuArrowPoint.x - (KSCREEN_WIDTH - [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth -ZTDefaultMargin), [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth - self.menuArrowWidth -ZTDefaultMargin);
        menuX = KSCREEN_WIDTH - [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth -ZTDefaultMargin;
    }else if ( menuArrowPoint.x - [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth/2 -ZTDefaultMargin < 0){
        menuArrowPoint.x = MAX(ZTDefaultMenuCornerRadius + self.menuArrowWidth, menuArrowPoint.x -ZTDefaultMargin);
        menuX =ZTDefaultMargin;
    }else{
        menuArrowPoint.x = [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth/2;
        menuX = senderRect.origin.x + (senderRect.size.width)/2 - [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth/2;
    }
    
    if (arrowDirection ==ZTPopOverMenuArrowDirectionUp) {
        menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y + menuRect.size.height > KSCREEN_HEIGHT) {
            menuRect = CGRectMake(menuX, (senderRect.origin.y + senderRect.size.height), [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth, KSCREEN_HEIGHT - menuRect.origin.y -ZTDefaultMargin);
            shouldAutoScroll = YES;
        }
    }else{
        
        menuRect = CGRectMake(menuX, (senderRect.origin.y - menuHeight), [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth, menuHeight);
        // if too long and is out of screen
        if (menuRect.origin.y  < 0) {
            menuRect = CGRectMake(menuX,ZTDefaultMargin, [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth, senderRect.origin.y -ZTDefaultMargin);
            menuArrowPoint.y = senderRect.origin.y;
            shouldAutoScroll = YES;
        }
    }
    
    [self prepareToShowWithMenuRect:menuRect
                     menuArrowPoint:menuArrowPoint
                   shouldAutoScroll:shouldAutoScroll
                     arrowDirection:arrowDirection];
    
    
    [self show];
}

-(void)prepareToShowWithMenuRect:(CGRect)menuRect menuArrowPoint:(CGPoint)menuArrowPoint shouldAutoScroll:(BOOL)shouldAutoScroll arrowDirection:(ZTPopOverMenuArrowDirection)arrowDirection
{
    CGPoint anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 0);
    if (arrowDirection ==ZTPopOverMenuArrowDirectionDown) {
        anchorPoint = CGPointMake(menuArrowPoint.x/menuRect.size.width, 1);
    }
    _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
    
    [_popMenuView showWithFrame:menuRect
                     anglePoint:menuArrowPoint
                  withNameArray:self.menuArray
                 imageNameArray:self.menuImageArray
               shouldAutoScroll:shouldAutoScroll
                 arrowDirection:arrowDirection
                      doneBlock:^(NSInteger selectedIndex) {
                          [self doneActionWithSelectedIndex:selectedIndex];
                      }];
    
    [self setAnchorPoint:anchorPoint forView:_popMenuView];
    
    _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
}


-(void)setAnchorPoint:(CGPoint)anchorPoint forView:(UIView *)view
{
    CGPoint newPoint = CGPointMake(view.bounds.size.width * anchorPoint.x,
                                   view.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(view.bounds.size.width * view.layer.anchorPoint.x,
                                   view.bounds.size.height * view.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, view.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, view.transform);
    
    CGPoint position = view.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    view.layer.position = position;
    view.layer.anchorPoint = anchorPoint;
}

#pragma mark - UIGestureRecognizerDelegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    CGPoint point = [touch locationInView:_popMenuView];
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"]) {
        return NO;
    }else if (CGRectContainsPoint(CGRectMake(0, 0, [ZTPopOverMenuConfiguration defaultConfiguration].menuWidth, [ZTPopOverMenuConfiguration defaultConfiguration].menuRowHeight), point)) {
        [self doneActionWithSelectedIndex:0];
        return NO;
    }
    return YES;
}

#pragma mark - onBackgroundViewTapped

-(void)onBackgroundViewTapped:(UIGestureRecognizer *)gesture
{
    [self dismiss];
}

#pragma mark - show animation

- (void)show
{
    self.isCurrentlyOnScreen = YES;
    [UIView animateWithDuration:ZTDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 1;
                         _popMenuView.transform = CGAffineTransformMakeScale(1, 1);
                     }];
}

#pragma mark - dismiss animation

- (void)dismiss
{
    self.isCurrentlyOnScreen = NO;
    [self doneActionWithSelectedIndex:-1];
}

#pragma mark - doneActionWithSelectedIndex

-(void)doneActionWithSelectedIndex:(NSInteger)selectedIndex
{
    [UIView animateWithDuration:ZTDefaultAnimationDuration
                     animations:^{
                         _popMenuView.alpha = 0;
                         _popMenuView.transform = CGAffineTransformMakeScale(0.1, 0.1);
                     }completion:^(BOOL finished) {
                         if (finished) {
                             [self.popMenuView removeFromSuperview];
                             [self.backgroundView removeFromSuperview];
                             if (selectedIndex < 0) {
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             }else{
                                 if (self.doneBlock) {
                                     self.doneBlock(selectedIndex);
                                 }
                                 if (self.dismissBlock) {
                                     self.dismissBlock();
                                 }
                             }
                         }
                     }];
}
@end
