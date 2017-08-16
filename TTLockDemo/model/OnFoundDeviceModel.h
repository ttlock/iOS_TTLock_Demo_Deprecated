//
//  OnFoundDeviceModel.h
//  TTLockDemo
//
//  Created by wjjxx on 17/2/17.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OnFoundDeviceModel : NSObject

@property (nonatomic,strong) CBPeripheral *peripheral;
@property (nonatomic,strong) NSNumber * rssi ;
@property (nonatomic,strong) NSString *lockName;
@property (nonatomic,strong) NSString *mac;
@property (nonatomic,strong) NSDictionary * advertisementData;
@property (nonatomic,assign) BOOL isContainAdmin;
@property (nonatomic,assign) int protocolCategory;
@property (nonatomic,assign) BOOL  isAllowUnlock;
@property (nonatomic,assign) int oneMeterRSSI;

- (instancetype)initOnFoundDeviceModelWithDic:(NSDictionary*)dic;
@end
