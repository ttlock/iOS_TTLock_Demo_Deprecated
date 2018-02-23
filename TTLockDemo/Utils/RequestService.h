//
//  RequestService.h
//  BTstackCocoa
//
//  Created by wan on 13-3-7.
//
//

#import <Foundation/Foundation.h>
#import "Key.h"
#import "LockModel.h"
#import "UserInfo.h"
/*!
 @class
 @abstract 请求服务类
 */
@interface RequestService : NSObject

//openid = 用户id
//绑定管理员（/room/bindingAdmin）
/*!
 @method
 @abstract 绑定管理员
 @discussion  门锁添加成功后需要做绑定管理员操作
 @param LockModel 钥匙类
 @param accessToken 访问令牌
 @param clientId 客户端id
 @param protocol_type 协议类型
 @param protocol_version 协议版本
 @param scene 应用场景
 @param group_id 应用id
 @param org_id 应用子id
 @result int
 */
+(int)bindLock:(KeyModel*)LockModel
 protocol_type:(NSString*)protocol_type
protocol_version:(NSString*)protocol_version
         scene:(NSString*)scene
      group_id:(NSString*)group_id
        org_id:(NSString*)org_id;
/**
 *解除绑定
 */
+(int)unbindLockId:(int)lockId
              date:(NSString*)date;

+(id)loginWithUsername:(NSString*)username
              password:(NSString*)password;
/*!
 @method
 @abstract 发送电子钥匙
 @discussion  给普通用户发送电子钥匙
 @param roomid 房间id
 @param startDate 开始时间
 @param endDate 结束时间
 @param key 密钥
 @param mac mac地址
 @param message 消息
 @param clientid 客户端id
 @param accessToken 访问令牌
 @param openid 用户id
 @result int
 */
+(int)SendEKey_roomid:(NSString *)roomid
            startDate:(NSString *)startDate
              endDate:(NSString*)endDate
                  key:(NSString*)key
                  mac:(NSString *)mac
              message:(NSString *)message
             receiver:(NSString*)receiver;



/*!
 @method
 @abstract 获取电子钥匙列表
 @discussion 收到电子钥匙后, 获取电子钥匙列表
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result NSMutableArray
 */
+(NSMutableArray*)requestEkeys;

/*!
 @method
 @abstract 上传开锁记录
 @discussion 开锁后上传开锁记录
 @param success 成功标志
 @param roomid 房间id
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result int
 */
+(int)uploadUnlockRecord_success:(BOOL)success
                          roomID:(int)roomid;


/*!
 @method
 @abstract 请求开锁记录
 @discussion 将开锁记录请求到本地
 @param roomid 房间id
 @param page 页数
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result NSMutableArray
 */
+(NSMutableArray*)requetUnlockRecords_roomID:(int)roomid
                                        page:(int)page;

/*!
 @method
 @abstract 请求锁的用户
 @discussion 将某一个房间id的用户信息请求到本地
 @param roomid 房间id
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result NSMutableArray
 */
+(NSMutableArray*)requetRoomUsers_roomID:(int)roomid;

/*!
 @method
 @abstract  解除冻结
 @discussion 解冻钥匙
 @param kid         钥匙id
 @param roomid 房间id
 @param openid 用户id
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result int
 */
+(int)unblockUser_kid:(int)kid
               roomID:(int)roomid;

/*!
 @method
 @abstract  冻结
 @discussion 冻结钥匙
 @param kid         钥匙id
 @param roomid 房间id
 @param openid 用户id
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result int
 */
+(int)blockUser_kid:(int)kid
             roomID:(int)roomid
             openid:(NSString*)openid;


/*!
 @method
 @abstract  获取用户信息
 @discussion 获取某一用户的信息
 @param user 用户
 @param clientid 客户端id
 @param accessToken 访问令牌
 @result int
 */
+(int)requestUserInfo_userinfo:(UserInfo*)user;
/**
 *  上传或重置键盘密码
 *
 *  @param clientid    开放平台注册时分配的app_id
 *  @param accessToken 访问令牌
 *  @param lockId      锁id
 *  @param pwdInfo     加密后的密码信息（SDK返回的参数）
 *  @param timestamp   时间戳（SDK返回的参数）
 *
 *  @return errcode
 */
+(int)resetKeyboardPasswordWithLockId:(int)lockId
                              pwdInfo:(NSString*)pwdInfo
                            timestamp:(NSString*)timestamp;
/*!
 @method
 @abstract  使用键盘密码
 @discussion 从服务端获取一个键盘密码
 @param clientId 客户端id
 @param accessToken 访问令牌
 @param lockId 锁id
 @param keyboardPwdVersion 键盘密码版本
 @param keyboardPwdType 键盘密码类型
 @param receiverUsername 接收者用户名
 @result id
 */
+(id)UseKPSWithLockId:(int)lockId keyboardPwdVersion:(int)keyboardPwdVersion keyboardPwdType:(int)keyboardPwdType receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate;


/*!
 @method
 @abstract  获取键盘密码记录
 @discussion
 @param clientId 客户端id
 @param accessToken 访问令牌
 @param lockId 锁id
 @param pageNo 页码
 @param pageSize 每页的数量
 @result id
 */
+(id)RequestKpsUsageWithLockId:(int)lockId pageNo:(int)pageNo pageSize:(int)pageSize;

/*!
 @method
 @abstract  修改锁名称(别名)
 @discussion
 @param clientId 客户端id
 @param accessToken 访问令牌
 @param lockId 锁id
 @param lockAlias 锁的别名
 @result int
 */
+(int)changeKeyNameWithLockId:(int)lockId lockAlias:(NSString *)lockAlias;

/*!
 @method
 @abstract 重置电子钥匙
 @discussion
 @param clientId 客户端id
 @param accessToken 访问令牌
 @param lockId 锁id
 @param lockFlagPos 锁标志位的位置
 @result int
 */
+(int)resetAllKeyWithLockId:(int)lockId lockFlagPos:(NSString *)lockFlagPos;
@end
