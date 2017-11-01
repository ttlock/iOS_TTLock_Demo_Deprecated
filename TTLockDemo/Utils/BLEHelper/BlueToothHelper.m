//
//  BlueToothHelp.m
//  Sciener
//
//  Created by wjjxx on 16/7/9.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import "BlueToothHelper.h"
#import "TTLockHelper.h"


@implementation BlueToothHelper

+ (BOOL)getBlueState{

    if (TTObjectTTLockHelper.state != TTManagerStatePoweredOn) {
        [SSToastHelper showToastWithStatus:LS(@"words_lock_msg_one")];
     
        return NO;
    }
    return YES;
}

+ (float)getDianliang{

    int dianliang = -1;
    dianliang = [TTObjectTTLockHelper getPower];
    if (dianliang % 5 != 0 && dianliang != -1) {
         dianliang = (dianliang / 5 + 1) * 5;
    }
    return dianliang;
}

@end
