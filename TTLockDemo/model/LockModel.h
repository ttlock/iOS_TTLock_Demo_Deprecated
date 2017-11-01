//
//  LockModel.h
//
//  Created by 谢元潮 on 14-10-31.
//  Copyright (c) 2014年 谢元潮. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LockVersion : NSObject

@property (nonatomic, assign) NSInteger protocolType;

@property (nonatomic, assign) NSInteger protocolVersion;

@property (nonatomic, assign) NSInteger scene;

@property (nonatomic, assign) NSInteger groupId;

@property (nonatomic, assign) NSInteger orgId;

@end

