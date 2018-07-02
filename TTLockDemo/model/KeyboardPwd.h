//
//  KeyboardPs.h
//  sciener
//
//  Created by TTLock on 15/3/25.
//
//

#import <Foundation/Foundation.h>

@interface KeyboardPwd : NSObject

@property(nonatomic, strong) NSString *keyboardPwd;

@property (nonatomic, assign) NSInteger keyboardPwdId;

@property(nonatomic, assign) NSTimeInterval startDate;

@property(nonatomic, assign) NSTimeInterval endDate;

@property(nonatomic, assign) NSTimeInterval sendDate;

@property (nonatomic, assign) NSInteger keyboardPwdVersion;

@property (nonatomic, assign) NSInteger keyboardPwdType;

@property (nonatomic, assign) NSInteger lockId;
@end

