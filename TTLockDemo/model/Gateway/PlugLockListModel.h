//
//  PlugLockListModel.h
//  Sciener
//
//  Created by wjjxx on 17/1/9.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PlugLockListModel : NSObject

@property (nonatomic,strong) NSNumber * lockId;

@property (nonatomic,strong) NSString * lockName;

@property (nonatomic,strong) NSString *lockMac;

@property (nonatomic,strong) NSNumber * rssi;

@property (nonatomic,strong) NSNumber * updateDate;

@end
