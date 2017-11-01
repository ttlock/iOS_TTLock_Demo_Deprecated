//
//  AppDelegate.m
//  Created by 谢元潮 on 14-10-29.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import "AppDelegate.h"
#import "Tab0ViewController.h"
#import "DBHelper.h"
#import "Define.h"
#import "RequestService.h"
#import "XYCUtils.h"
#import "KeyDetailViewController.h"
#import "OnFoundDeviceModel.h"

@interface AppDelegate ()
{
    Tab0ViewController * root;

}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
   //创建TTLock
     TTLockHelperClass;

    //是否打印日志
    [TTLock setDebug:NO];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    root = [[Tab0ViewController alloc]initWithNibName:@"Tab0ViewController" bundle:nil];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];
    
    return YES;
    
}
- (void)applicationDidEnterBackground:(UIApplication *)application {
    [TTObjectTTLockHelper stopBTDeviceScan];
   
}
- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [TTObjectTTLockHelper startBTDeviceScan:YES];
}

//禁止横屏
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
@end
