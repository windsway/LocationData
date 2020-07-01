//
//  CustomTool.m
//  locationSave
//
//  Created by YONGZHENG on 2020/7/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import "CustomTool.h"
#import "LocationDefine.h"
@implementation CustomTool
+ (void)createShadow:(UIView *)currentView
{
   
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = currentView.bounds;
    layer.shadowOffset = CGSizeZero;
    layer.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.2].CGColor;
    layer.shadowRadius = 10;
    layer.cornerRadius = 8;
    layer.shadowOpacity = .5;
    layer.backgroundColor = [UIColor whiteColor].CGColor;
    [currentView.layer insertSublayer:layer atIndex:0];
}
/** 分享 */
+ (void)mq_share:(NSArray *)items target:(id)target{
    if (items.count == 0 || target == nil) {
        return;
    }
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:items applicationActivities:nil];
    if (@available(iOS 11.0, *)) {//UIActivityTypeMarkupAsPDF是在iOS 11.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks,UIActivityTypeMarkupAsPDF];
    } else if (@available(iOS 9.0, *)) {//UIActivityTypeOpenInIBooks是在iOS 9.0 之后才有的
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail,UIActivityTypeOpenInIBooks];
    }else {
        activityVC.excludedActivityTypes = @[UIActivityTypeMessage,UIActivityTypeMail];
    }
    activityVC.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
       
    };
    //这儿一定要做iPhone与iPad的判断，因为这儿只有iPhone可以present，iPad需pop，所以这儿actVC.popoverPresentationController.sourceView = self.view;在iPad下必须有，不然iPad会crash，self.view你可以换成任何view，你可以理解为弹出的窗需要找个依托。
    UIViewController *vc = target;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        activityVC.popoverPresentationController.sourceView = vc.view;
        [vc presentViewController:activityVC animated:YES completion:nil];
    } else {
        [vc presentViewController:activityVC animated:YES completion:nil];
    }
}
+ (id _Nullable)getUserInfo
{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfo]];
    }
    else
    {
        return nil;
    }
}
+ (void)setCurrentUserInfo:(id _Nonnull)model
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSKeyedArchiver archivedDataWithRootObject:model] forKey:UserInfo];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (BOOL)IslogIn
{
    if ([CustomTool getUserInfo]) {
        return YES;
    }
    else
    {
        return NO;
    }
}
+ (void)logOut
{
    if ([CustomTool IslogIn]) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:UserInfo];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
