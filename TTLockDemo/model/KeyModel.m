//
//  Key.m
//
//  Created by TTLock on 15/5/20.
//  Copyright (c) 2015年 TTLock. All rights reserved.
//

#import "KeyModel.h"


@implementation KeyModel

- (BOOL)isAdmin
{
    return [self.userType isEqualToString:@"110301"];
}

- (id)mj_newValueFromOldValue:(id)oldValue property:(MJProperty *)property{
  
    if ([property.name isEqualToString:@"startDate"]) {
        if ([oldValue isKindOfClass:[NSNumber class]]) {
            return  [NSNumber numberWithInteger:[oldValue integerValue] / 1000];
        }
    }
    if ([property.name isEqualToString:@"endDate"]) {
        if ([oldValue isKindOfClass:[NSNumber class]]) {
            return  [NSNumber numberWithInteger:[oldValue integerValue] / 1000] ;
        }
    }
    if ([property.name isEqualToString:@"lockVersion"]) {
        if ([oldValue isKindOfClass:[NSDictionary class]]) {
            return  [NSString stringWithFormat:@"%@.%@.%@.%@.%@",oldValue[@"protocolType"],oldValue[@"protocolVersion"],oldValue[@"scene"],oldValue[@"groupId"],oldValue[@"orgId"]];
        }
    }
    
    return oldValue;
}

@end

