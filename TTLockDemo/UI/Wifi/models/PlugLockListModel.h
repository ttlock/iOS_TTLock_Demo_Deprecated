//
//  PlugLockListModel.h
//  Sciener
//
//  Created by wjjxx on 17/1/9.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "JSONModel.h"

@interface PlugLockListModel : JSONModel

@property (nonatomic,strong) NSNumber<Optional> * lockId;

@property (nonatomic,strong) NSString<Optional> * lockName;

@property (nonatomic,strong) NSString <Optional>*lockMac;

@property (nonatomic,strong) NSNumber<Optional> * rssi;

@property (nonatomic,strong) NSNumber<Optional> * updateDate;

@end
