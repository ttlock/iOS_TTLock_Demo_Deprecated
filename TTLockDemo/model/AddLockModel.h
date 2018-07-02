//
//  AddLockModel.h
//
//  Created by wjjxx on 16/5/3.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface AddLockModel : NSObject

@property (nonatomic,strong)CBPeripheral * peripheral;

@property (nonatomic,assign)BOOL isContainAdmin;

@property (nonatomic,strong)NSDictionary *advertisementData;

@property (nonatomic,strong)NSString *lockMac;
/** The time to search for this  peripheral */
@property (nonatomic,strong)NSDate *searchTime;

@property (nonatomic,assign)int protocolType;

@property (nonatomic,assign)int protocolVersion;
@end
