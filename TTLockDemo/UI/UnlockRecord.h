//
//  UnlockRecord.h
//
//  Created by 谢元潮 on 14-10-31.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 开锁记录类
 */
@interface UnlockRecord : NSObject

/*!
 @property
 @abstract 用户唯一识别码
 */
@property (nonatomic, strong) NSString * openid;

/*!
 @property
 @abstract 日期
 */
@property (nonatomic, strong) NSDate * date;

/*!
 @property
 @abstract 成功标志
 */
@property (nonatomic) BOOL success;

/*!
 @property
 @abstract 记录的id
 */
@property (nonatomic) int recordID;


/*!
 @method
 @abstract 初始化开锁记录类
 @discussion 初始化开锁记录类, 包括recordID, openID, success, date四个参数
 @param recordID 记录id
 @param openID   用户唯一识别码
 @param success 成功标志
 @param date 日期
 @result id
 */
-(id)initWithRecordID:(int)recordID openID:(NSString*)openID success:(BOOL)success date:(NSDate*)date;

@end
