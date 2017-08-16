//
//  MyLog.h
//  
//
//  Created by wan on 13-2-22.
//
//

#import <Foundation/Foundation.h>
/*!
 @class
 @abstract 打印类
 */
@interface MyLog : NSObject
/*!
 @method
 @abstract 打印给定的参数
 @discussion 如果isDebug为yes, 就打印给定的参数
 @param string 给定的字符串
 @param isDebug 是否需要打印的标志
 @result void
 */
+(void) log:(NSString *)string isdebug:(BOOL)isDebug;

/*!
 @method
 @abstract 按照一定的格式打印给定的参数
 @discussion
 @param formatStr 给定的打印格式
 @result void
 */
+ (void) logFormate:(NSString *)formatStr, ... ;
@end
