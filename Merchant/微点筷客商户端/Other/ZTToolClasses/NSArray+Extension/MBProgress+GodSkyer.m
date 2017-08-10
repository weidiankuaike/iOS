//
//  MBProgress+GodSkyer.m
//  微点筷客商户端
//
//  Created by Skyer God on 16/12/21.
//  Copyright © 2016年 张森森. All rights reserved.
//

#import "MBProgress+GodSkyer.h"

@interface MBProgress_GodSkyer ()<MBProgressHUDDelegate>
{
    MBProgressHUD *HUD;
    long long expectedLength;
    long long currentLength;
}
@end
@implementation MBProgress_GodSkyer
+(MBProgress_GodSkyer *)shareManager{
    static MBProgress_GodSkyer *shareManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareManager = [[MBProgress_GodSkyer alloc] init];
    });
    return shareManager;
}

#pragma mark 显示信息
- (void)showSimple:(UIView *)parentView {
    // The hud will dispable all input on the view (use the higest view possible in the view hierarchy)
    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;

    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showWithLabelWithMessage:(NSString *)message inView:(UIView *)parentView {

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = message;

    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showWithDetailsLabelMessage:(NSString *)message detailMessage:(NSString *)detailMsg inView:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:(UIView *)parentView];
    [parentView addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = message;
    HUD.detailsLabelText = detailMsg;
    HUD.square = YES;

    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showWithLabelDeterminate:(NSString *)message inView:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    HUD.dimBackground = YES;
    [parentView addSubview:HUD];

    // Set determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;

    HUD.delegate = self;
    HUD.labelText = message;

    // myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:self animated:YES];
}

- (void)showWIthLabelAnnularDeterminate:(UIView *)parentView{
    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    // Set determinate mode
    HUD.mode = MBProgressHUDModeAnnularDeterminate;

    HUD.delegate = self;
    HUD.labelText = @"Loading";

    // myProgressTask uses the HUD instance to update progress
    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showWithLabelDeterminateHorizontalBarWithProgress:(CGFloat )progress inView:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    // Set determinate bar mode
    HUD.mode = MBProgressHUDModeDeterminateHorizontalBar;
    HUD.dimBackground = YES;
    HUD.delegate = self;

    // myProgressTask uses the HUD instance to update progress
//    [HUD showWhileExecuting:@selector(myProgressTask) onTarget:self withObject:HUD animated:YES];
    [HUD showAnimated:YES];
    HUD.progress = progress;

}

- (void)showWithCustomView:(NSString *)message inView:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];

    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;

    HUD.delegate = self;
    HUD.labelText = message;

    [HUD show:YES];
    [HUD hide:YES afterDelay:3];
}

- (void)showWithLabelMixed:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = @"Connecting";
    HUD.minSize = CGSizeMake(135.f, 135.f);

    [HUD showWhileExecuting:@selector(myMixedTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showUsingBlocks:(UIView *)parentView{
#if NS_BLOCKS_AVAILABLE
    MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:hud];
    hud.labelText = @"With a block";

    [hud showAnimated:YES whileExecutingBlock:^{
        [self myTask];
    } completionBlock:^{
        [hud removeFromSuperview];
    }];
#endif
}

- (void)showOnWindow:(UIView *)parentView{
    // The hud will dispable all input on the window
    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    HUD.delegate = self;
    HUD.labelText = @"Loading";

    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showURL:(UIView *)parentView{
    NSURL *URL = [NSURL URLWithString:@"https://github.com/matej/MBProgressHUD/zipball/master"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [connection start];

    HUD = [MBProgressHUD showHUDAddedTo:parentView animated:YES];
    HUD.delegate = self;
}


- (void)showWithGradient:(UIView *)parentView{

    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    HUD.dimBackground = YES;

    // Regiser for HUD callbacks so we can remove it from the window at the right time
    HUD.delegate = self;

    // Show the HUD while the provided method executes in a new thread
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

- (void)showTextOnly:(UIView *)parentView{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:parentView animated:YES];

    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.labelText = @"Some message...";
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;

    [hud hide:YES afterDelay:3];
}

- (void)showWithColor:(UIView *)parentView{
    HUD = [[MBProgressHUD alloc] initWithView:parentView];
    [parentView addSubview:HUD];

    // Set the hud to display with a color
    HUD.color = [UIColor colorWithRed:0.23 green:0.50 blue:0.82 alpha:0.90];

    HUD.delegate = self;
    [HUD showWhileExecuting:@selector(myTask) onTarget:self withObject:HUD animated:YES];
}

#pragma mark -
#pragma mark Execution code

- (void)myTask {
    // Do something usefull in here instead of sleeping ...
    sleep(3);
}

- (void)myProgressTask {
    // This just increases the progress indicator in a loop
    float progress = 0.0f;
    while (progress < 1.0f) {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
}

- (void)myMixedTask {
    // Indeterminate mode
    sleep(2);
    // Switch to determinate mode
    HUD.mode = MBProgressHUDModeDeterminate;
    HUD.labelText = @"Progress";
    float progress = 0.0f;
    while (progress < 1.0f)
    {
        progress += 0.01f;
        HUD.progress = progress;
        usleep(50000);
    }
    // Back to indeterminate mode
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.labelText = @"Cleaning up";
    sleep(2);
    // The sample image is based on the work by www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = @"Completed";
    sleep(2);
}

#pragma mark -
#pragma mark NSURLConnectionDelegete

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    expectedLength = [response expectedContentLength];
    currentLength = 0;
    HUD.mode = MBProgressHUDModeDeterminate;
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    currentLength += [data length];
    HUD.progress = currentLength / (float)expectedLength;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [HUD hide:YES];
}

- (void)hiddenHUD{
    [HUD hideAnimated:YES];
}
#pragma mark -
#pragma mark MBProgressHUDDelegate methods

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
    HUD = nil;
}
@end
