//
//  CustomTool.h
//  locationSave
//
//  Created by YONGZHENG on 2020/7/1.
//  Copyright © 2020 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface CustomTool : NSObject
///阴影处理
+ (void)createShadow:(UIView *)currentView;
///分享处理  [标题，链接，图片]
+ (void)mq_share:(NSArray *)items target:(id)target;
+ (id  _Nullable)getUserInfo;
+ (BOOL)IslogIn;
+ (void)logOut;
+ (void)setCurrentUserInfo:(id _Nonnull)model;
@end

NS_ASSUME_NONNULL_END
