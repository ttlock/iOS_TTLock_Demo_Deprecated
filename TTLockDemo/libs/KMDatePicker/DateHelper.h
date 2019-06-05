//
//  DateHelper.h
//  KMDatePicker
//
//  Created by KenmuHuang on 15/10/8.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

+ (NSDate *)localeDate;

+ (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format;

+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format;

+(NSString*)formateDate:(NSDate*)date format:(NSString*)format;


+(NSString*)GetCurrentTimeInMillisecond;


+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format;

@end
