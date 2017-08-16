//
//  UserInfo.h
//  BTstackCocoa
//
//  Created by wan on 13-3-6.
//
//

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 用户信息类
 */
@interface UserInfo : NSObject

//0，已冻结；1，正常；2，冻结中；3，解除冻结中；4，已分享秘钥；5，删除中；
#define STATE_TYPE_BLOCKED 0
#define STATE_TYPE_NORMAL 1
#define STATE_TYPE_BLOCKING 2
#define STATE_TYPE_UNLOCKING 3
#define STATE_TYPE_SHARED 4
#define STATE_TYPE_DELETING 5


/*!
 @property
 @abstract 用户唯一码
*/
@property (nonatomic, strong) NSString *openid;//用户唯一码

/*!
 @property
 @abstract 状态
 */
@property (nonatomic, strong) NSString *status;//状态

/*!
 @property
 @abstract 钥匙id
 */
@property (nonatomic, strong) NSString *keyId;

/*!
 @property
 @abstract 日期
 */
@property (nonatomic, strong) NSDate *date;

/*!
 @property
 @abstract 开始时间
 */
@property (nonatomic, strong) NSDate *startDate;

/*!
 @property
 @abstract 结束时间
 */
@property (nonatomic, strong) NSDate *endDate;

/*!
 @property
 @abstract 房间id
 */
@property (nonatomic, strong) NSString *lockId;

/*!
 @property
 @abstract 头像的url地址
 */
@property (nonatomic, strong) NSString *headurl;

/*!
 @property
 @abstract 昵称
 */
@property (nonatomic, strong) NSString *nickname;

@end
