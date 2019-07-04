//
//  AppDelegate.m
//  Created by TTLock on 14-10-29.
//  Copyright (c) 2014年 TTLock. All rights reserved.
//

#import "AppDelegate.h"
#import "Tab0ViewController.h"
#import "Define.h"
#import "RequestService.h"
#import "KeyDetailViewController.h"
#import "OnFoundDeviceModel.h"

@interface AppDelegate ()
{
    Tab0ViewController * root;

}
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //create TTLock object
     TTLockHelperClass;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    root = [[Tab0ViewController alloc]initWithNibName:@"Tab0ViewController" bundle:nil];
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:root];
    self.window.rootViewController = nav;
    
    [self.window makeKeyAndVisible];

    return YES;
    
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    [TTObjectTTLockHelper startBTDeviceScan:YES];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [TTObjectTTLockHelper stopBTDeviceScan];
    
}
- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window{
    return UIInterfaceOrientationMaskPortrait;
}
@end
