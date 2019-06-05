//
//  DateHelper.m
//  KMDatePicker
//
//  Created by KenmuHuang on 15/10/8.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "DateHelper.h"

@implementation DateHelper

+ (NSDate *)localeDate {
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate:date];
    return [date dateByAddingTimeInterval:interval];
}

+ (NSDate *)dateFromString:(NSString *)dateStr withFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = format ?: @"yyyy-MM-dd HH:mm";
    return [formatter dateFromString:dateStr];
}

+ (NSString *)dateToString:(NSDate *)date withFormat:(NSString *)format {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.dateFormat = format ?: @"yyyy-MM-dd HH:mm";
    return [formatter stringFromDate:date];
}
+(NSString*)formateDate:(NSDate*)date format:(NSString*)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setAMSymbol:@"AM"];
    [formatter setPMSymbol:@"PM"];
    [formatter setDateFormat:format];
    
    NSString* dateStr = [formatter stringFromDate:date];
    
    return dateStr;
}


+(NSString*)GetCurrentTimeInMillisecond
{
    
    NSDate* date = [NSDate date];
    
    NSTimeInterval interval=[date timeIntervalSince1970]*1000;
    
    NSString *dateStr = [NSString stringWithFormat:@"%f",interval];
    
    NSArray *macStrArray =[dateStr componentsSeparatedByString:@"."];
    
    return [macStrArray objectAtIndex:0];
    
}

+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format
{
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:format];
    
    NSDate *date=[formatter dateFromString:dateStr];
    
    
    return date;
    
    
}
@end
