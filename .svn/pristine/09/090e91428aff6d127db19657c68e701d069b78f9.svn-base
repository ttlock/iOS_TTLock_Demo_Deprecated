//
//  NSDate+CalculateDay.m
//  OCNSCalendar
//
//  Created by KenmuHuang on 15/10/7.
//  Copyright © 2015年 Kenmu. All rights reserved.
//

#import "NSDate+CalculateDay.h"

@implementation NSDate (CalculateDay)

- (NSUInteger)daysOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSRange range = [gregorian rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:self];
    return range.length;
}

- (NSUInteger)daysOfYear {
    NSUInteger days = 0;
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [gregorian components:NSCalendarUnitYear fromDate:self];
    
    for (NSUInteger i=1; i<=12; i++) {
        [comps setMonth:i];
        days += [[gregorian dateFromComponents:comps] daysOfMonth];
    }
    return days;
}

- (NSDate *)firstDayOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]]; 
    [comps setDay:1];
    
    return [gregorian dateFromComponents:comps];
}

- (NSDate *)lastDayOfMonth {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [comps setDay:[self daysOfMonth]];
    
    return [gregorian dateFromComponents:comps];
}

- (NSDate *)addMonthAndDay:(NSUInteger)months days:(NSUInteger)days {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *comps = [NSDateComponents new];
    [comps setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [comps setMonth:months];
    [comps setDay:days];
    
    return [gregorian dateByAddingComponents:comps toDate:self options:0];
}

- (NSArray *)monthAndDayBetweenTwoDates:(NSDate *)toDate {
    NSMutableArray *mArrMonthAndDay = [[NSMutableArray alloc] initWithCapacity:2];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    unsigned unitFlags = NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:self toDate:toDate options:0];
    
    [mArrMonthAndDay addObject:[NSString stringWithFormat:@"%ld", (long)[comps month]]];
    [mArrMonthAndDay addObject:[NSString stringWithFormat:@"%ld", (long)[comps day]]];
    return mArrMonthAndDay;
}

- (NSInteger)weekday {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:self] weekday];
}

- (NSString *)weekdayName:(BOOL)isShortName localeIdentifier:(NSString *)localeIdentifier {
    NSDateFormatter *formatter = [NSDateFormatter new];
    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"UTC"];
    formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier];
    formatter.dateFormat = isShortName ? @"EE" : @"EEEE";
    return [formatter stringFromDate:self];
}

- (NSString *)weekdayNameCN:(BOOL)isShortName {

    return [self weekdayName:isShortName localeIdentifier:@"zh_CN"];
}

- (NSString *)weekdayNameEN:(BOOL)isShortName {
    return [self weekdayName:isShortName localeIdentifier:@"en_US"];
}

@end
