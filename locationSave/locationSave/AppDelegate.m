//
//  AppDelegate.m
//  locationSave
//
//  Created by mac on 2020/1/14.
//  Copyright © 2020 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataBaseManager.h"
#import "test1.h"
#import "test2.h"
#import <objc/runtime.h>
@interface AppDelegate ()
@property (nonatomic, strong) UIWindow *rootWind;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.rootWind = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.rootWind makeKeyAndVisible];
    ViewController *vc = [[ViewController alloc] init];
    self.rootWind.rootViewController = vc;
    [DataBaseManager initdatabaseWithTableName:@[@"test1",@"test2"]];
    test1 *model = [test1 new];
    model.myid = 1;
    model.objcname = @"1111";
    model.objcname11 = @"2222";

    [DataBaseManager replaceSection:model];
    test1 *model2 = [test1 new];
    model2.myid = 2;
    model2.objcname = @"3333";
    model2.objcname11 = @"4444";

    [DataBaseManager replaceSection:model2];
    test1 *model3 = [test1 new];
    model3.myid = 3;
    model3.objcname = @"55";
    model3.objcname11 = @"666";
    [DataBaseManager replaceSection:model3];
    NSArray *array = [DataBaseManager getAllSection:model];
    test2 *people = [test2 new];
    people.nowid = @"1";
    people.myid = 1;
    people.iphone = @"1111";
    [DataBaseManager replaceSection:people];
    test2 *people1 = [test2 new];
    people1.nowid = @"1";
    people1.myid = 2;
    people1.iphone = @"3333";
    [DataBaseManager replaceSection:people1];
    NSArray *array3 = [DataBaseManager getAllSection:people1];
    NSArray *searchA = [DataBaseManager getSectionByRelevanceMoreTable:@{@"test1":@{@"des":@"objcname"},@"test2":@{@"searchKey":@"nowid",@"searchValue":@"1",@"resultKey":@"iphone"}}];
    return YES;
}
@end
