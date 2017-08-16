//
//  TimePsRecord.h
//  sciener
//
//  Created by 谢元潮 on 15/1/19.
//
//

#import <Foundation/Foundation.h>

/*!
 @class
 @abstract 限时密码记录类
 */
@interface TimePsRecord : NSObject

/*!
 @property
 @abstract 密码记录的id
 */
@property (nonatomic) int id;

/*!
 @property
 @abstract 房间id
 */
@property (nonatomic, strong) NSString * roomid;

/*!
 @property
 @abstract 管理员密码
 */
@property (nonatomic, strong) NSString * password;

/*!
 @property
 @abstract 接收者的用户名
 */
@property (nonatomic, strong) NSString * receiveUsername;

/*!
 @property
 @abstract 接收者的唯一标识
 */
@property (nonatomic, strong) NSString * receiveUid;

/*!
 @property
 @abstract 发送限时密码的Uid
 */
@property (nonatomic, strong) NSString * sendUid;

/*!
 @property
 @abstract 头像地址
 */
@property (nonatomic, strong) NSString * headurl;

/*!
 @property
 @abstract 限时密码类型
 */
@property (nonatomic, strong) NSString * passwordType;

/*!
 @property
 @abstract 限时密码的版本
 */
@property (nonatomic) int passwordVersion;

/*!
 @property
 @abstract 当前限时密码发送时的日期
 */
@property (nonatomic, strong) NSDate * date;

@end
