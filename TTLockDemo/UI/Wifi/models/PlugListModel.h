//
//  PlugListModel.h
//  Sciener
//
//  Created by wjjxx on 17/1/6.
//  Copyright © 2017年 sciener. All rights reserved.
//

#import "JSONModel.h"

@interface PlugListModel : JSONModel

@property (nonatomic,strong) NSNumber<Optional> * gatewayId;

@property (nonatomic,strong) NSString <Optional>*gatewayMac;

@property (nonatomic,strong) NSNumber<Optional> * isOnline;

@property (nonatomic,strong) NSNumber<Optional> * lockNum;
@end
