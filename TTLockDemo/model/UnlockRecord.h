//
//  UnlockRecord.h
//
//  Created by TTLock on 14-10-31.
//  Copyright (c) 2014年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UnlockRecord : NSObject


@property (nonatomic, strong) NSString * openid;

@property (nonatomic, strong) NSDate * date;

@property (nonatomic) BOOL success;

@property (nonatomic) int recordID;


-(id)initWithRecordID:(int)recordID openID:(NSString*)openID success:(BOOL)success date:(NSDate*)date;

@end
