//
//  SecurityUtil.h
//  Smile
//
//  Created by TTLock on 12-11-24.
//  Copyright (c) 2012年 TTLock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SecurityUtil : NSObject 

#pragma mark - base64
+ (NSString*)encodeBase64String:(NSString *)input;
+ (NSString*)decodeBase64String:(NSString *)input;
+ (NSString*)encodeBase64Data:(NSData *)data;
+ (NSString*)decodeBase64Data:(NSData *)data;

#pragma mark - AES加密
+(NSData*)encryptAESStr:(NSString*)string keyBytes:(Byte*)key;
+(NSData*)encryptAESData:(NSData*)data keyBytes:(Byte*)key;
+(NSData*)decryptToDataAESData:(NSData*)data keyBytes:(Byte*)key;


//将string转成带密码的data
+ (NSData*)encryptAESStr:(NSString*)string key:(NSString *)key;
+(NSData*)encryptAESData:(NSData*)data key:(NSString*)key;
//将带密码的data转成string
+ (NSString*)decryptAESData:(NSData*)data key:(NSString *)key;
+(NSData*)decryptToDataAESData:(NSData*)data key:(NSString*)key;

/**
 *  对生成的管理员密码 进行加密
 *
 *  @param string 原始数据
 *
 *  @return 加密后数据
 */
+ (NSString*)encodeAdminPSString:(NSString*)adminPs;
+ (NSString*)decodeAdminPSString:(NSString*)string;
/**
 *  对生成的动态密码 进行加密
 *
 *  @param string 原始数据
 *
 *  @return 加密后数据
 */
+ (NSString*)encodeLockKeyString:(NSString*)string;
+(NSString*)decodeLockKeyString:(NSString*)string;
/**
 *  aeskey
 *
 *  @param string 原始数据
 *
 *  @return 转化后数据
 */
+(NSString*)encodeAeskey:(NSData*)aeskey;
+(NSData*)decodeAeskey:(NSString*)aeskey;

@end
