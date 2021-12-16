//
//  RequestService.h
//  BTstackCocoa
//
//  Created by wan on 13-3-7.
//
//

#import <Foundation/Foundation.h>
#import "LockModel.h"


@interface RequestService : NSObject

+(id)loginWithUsername:(NSString*)username
              password:(NSString*)password;


+(NSMutableArray*)requetUnlockRecords_roomID:(int)roomid
                                        page:(int)page;

+(id)UseKPSWithLockId:(int)lockId keyboardPwdVersion:(int)keyboardPwdVersion keyboardPwdType:(int)keyboardPwdType receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate;

+(NSString *) md5:(NSString *)inPutText;
@end
