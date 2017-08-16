//
//  KeyboardPs.h
//  sciener
//
//  Created by 谢元潮 on 15/3/25.
//
//

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 键盘密码类
 */
@interface KeyboardPs : NSObject

//#define KEYBOARD_PS_TYPE_ADMIN              0  //管理员密码
#define KEYBOARD_PS_TYPE_NORMAL_ALL_DATE    1  //永久有效普通用户密码
#define KEYBOARD_PS_TYPE_LIMITED_TIMES      2  //次数密码
#define KEYBOARD_PS_TYPE_LIMITED_DATE       3  //期限密码

/*!
 @property
 @abstract 键盘密码id
*/
@property (nonatomic) int psId;

/*!
 @property
 @abstract 键盘密码
*/
@property (nonatomic,strong) NSString* keyboardPs;

/*!
 @property
 @abstract 键盘密码类型
*/
@property (nonatomic) int type;

/*!
 @property
 @abstract 开始时间
*/
@property (nonatomic,strong) NSDate* startDate;

/*!
 @property
 @abstract 结束时间
*/
@property (nonatomic,strong) NSDate* endDate;

/*!
 @property
 @abstract 键盘密码创建日期
*/
@property (nonatomic,strong) NSDate* createDate;

/*!
 @property
 @abstract 次数
*/
@property (nonatomic) int times;

/*!
 @property
 @abstract 剩余次数
*/
@property (nonatomic) int timesRemain;

/*!
 @property
 @abstract 使用者的id
*/
@property (nonatomic,strong) NSString* uid;//使用者的id

/*!
 @property
 @abstract 使用者的name
*/
@property (nonatomic,strong) NSString* userName;//使用者的name


@end



@interface KeyboardPwd : NSObject

@property(nonatomic, strong) NSString *keyboardPwd;

@property (nonatomic, assign) NSInteger keyboardPwdId;

@property(nonatomic, assign) NSTimeInterval startDate;

@property(nonatomic, assign) NSTimeInterval endDate;

@property(nonatomic, assign) NSTimeInterval sendDate;

@property (nonatomic, assign) NSInteger keyboardPwdVersion;

@property (nonatomic, assign) NSInteger keyboardPwdType;

@property (nonatomic, assign) NSInteger lockId;
@end

