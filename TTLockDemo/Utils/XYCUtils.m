//
//  Utils.m
//  BTstackCocoa
//
//  Created by wan on 13-1-31.
//
//

#import "XYCUtils.h"
#import "Key.h"

@implementation XYCUtils

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
