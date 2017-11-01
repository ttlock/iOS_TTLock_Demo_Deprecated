//
//  BlueToothHelp.h
//  Sciener
//
//  Created by wjjxx on 16/7/9.
//  Copyright © 2016年 sciener. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BlueToothHelper : NSObject

/**yes 是开 no是其他*/
+ (BOOL)getBlueState;
/**获取电量*/
+ (float)getDianliang;


@end
