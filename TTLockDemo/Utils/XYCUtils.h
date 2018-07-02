//
//  Utils.h
//  BTstackCocoa
//
//  Created by wan on 13-1-31.
//
//

#import <Foundation/Foundation.h>
#import "Key.h"

@interface XYCUtils : NSObject

+(NSString*)formateDate:(NSDate*)date format:(NSString*)format;


+(NSString*)GetCurrentTimeInMillisecond;


+(NSDate*)formateDateFromStringToDate:(NSString*)dateStr format:(NSString*)format;



@end
