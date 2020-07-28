//
//  AppDelegate.m
//  TestApp
//
//  Created by xuzhiwei on 2020/7/22.
//  Copyright © 2020 netease. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DataForFMDB.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1、创建窗口
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];

    //2.创建一个导航控制器并添加子视图
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:[ViewController new]];

    //3.设置根视图
    self.window.rootViewController = nav;

    //4、显示窗口
    [self.window makeKeyAndVisible];

    return YES;
}


@end
