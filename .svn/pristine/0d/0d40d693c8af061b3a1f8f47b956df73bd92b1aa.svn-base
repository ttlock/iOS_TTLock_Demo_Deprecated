//
//  OnFoundDeviceModel.m
//  TTLockDemo
//
//  Created by wjjxx on 17/2/17.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "OnFoundDeviceModel.h"

@implementation OnFoundDeviceModel

- (instancetype)initOnFoundDeviceModelWithDic:(NSDictionary*)dic{
    if (self = [super init]) {
        _mac = dic[@"mac"];
        _lockName = dic[@"lockName"];
        _rssi = dic[@"rssi"];
        _peripheral = dic[@"peripheral"];
        _isAllowUnlock = [dic[@"isAllowUnlock"] boolValue];
        _oneMeterRSSI = [dic[@"oneMeterRSSI"] intValue];
        _advertisementData = dic[@"advertisementData"];
        _protocolType = [dic[@"protocolType"] intValue];
        _protocolVersion = [dic[@"protocolVersion"] intValue];
        _isContainAdmin = [dic[@"isContainAdmin"] boolValue];

    }
    return self;
}
@end
