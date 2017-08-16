//
//  AddLockModel.h
//
//  Created by wjjxx on 16/5/3.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>
@interface AddLockModel : NSObject

/**蓝牙*/
@property (nonatomic,strong)CBPeripheral * peripheral;
/**是否是管理员*/
@property (nonatomic,assign)BOOL isContainAdmin;
/**蓝牙广播的数据*/
@property (nonatomic,strong)NSDictionary *advertisementData;
/**蓝牙的mac地址*/
@property (nonatomic,strong)NSString *lockMac;
/**搜索到这个蓝牙的时间*/
@property (nonatomic,strong)NSDate *searchTime;

@property (nonatomic,assign)int protocolCategory;

@end
