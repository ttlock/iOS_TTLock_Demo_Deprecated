//
//  BleHelper.h
//  TTLockDemo
//
//  Created by wjjxx on 16/11/8.
//  Copyright © 2016年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BLEHelper : NSObject
+ (void)connectLock:(Key*)connectKey;

+ (BOOL)getBlueState;

@end
