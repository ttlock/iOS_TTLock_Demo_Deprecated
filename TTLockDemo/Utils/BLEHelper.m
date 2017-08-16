//
//  BleHelper.m
//  TTLockDemo
//
//  Created by wjjxx on 16/11/8.
//  Copyright © 2016年 wjj. All rights reserved.
//

#import "BLEHelper.h"
#import "AppDelegate.h"

@implementation BLEHelper

+ (void)connectLock:(Key*)connectKey{
    AppDelegate *tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.currentPeripheral.state == CBPeripheralStateConnected) {
        [tempAppDelegate.TTObject disconnect:tempAppDelegate.currentPeripheral];
        tempAppDelegate.currentKey = connectKey;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray *perperipherals = [tempAppDelegate.TTObject.manager retrievePeripheralsWithIdentifiers:[NSArray arrayWithObjects:[[NSUUID alloc]initWithUUIDString:connectKey.peripheralUUIDStr], nil]];
            
            [tempAppDelegate.TTObject connect:perperipherals[0]];
        });
    }else{
        tempAppDelegate.currentKey = connectKey;
        NSArray *perperipherals = [tempAppDelegate.TTObject.manager retrievePeripheralsWithIdentifiers:[NSArray arrayWithObjects:[[NSUUID alloc]initWithUUIDString:connectKey.peripheralUUIDStr], nil]];
        [tempAppDelegate.TTObject connect:perperipherals[0]];
    }
}
+ (BOOL)getBlueState{
    AppDelegate * tempAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (tempAppDelegate.TTObject.manager.state != CBCentralManagerStatePoweredOn) {
        [SVProgressHUD setMinimumDismissTimeInterval:3];
        [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
        [SVProgressHUD showImage:nil status:@"请开启蓝牙"];
        return NO;
    }
    return YES;
}
@end
