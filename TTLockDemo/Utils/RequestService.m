//
//  RequestService.m
//  BTstackCocoa
//
//  Created by wan on 13-3-7.
//
//

#import "RequestService.h"
#import "XYCUtils.h"
#import "MyLog.h"
#import "Define.h"
#import "UnlockRecord.h"
#import "AppDelegate.h"
#import "TimePsRecord.h"
#import "CommonCrypto/CommonDigest.h"


#define URL @"https://api.ttlock.com.cn"  //正式服务器


@implementation RequestService

/*绑定管理员 */
+(int)bindLock:(LockModel*)LockModel
 protocol_type:(NSString*)protocol_type
protocol_version:(NSString*)protocol_version
         scene:(NSString*)scene
      group_id:(NSString*)group_id
        org_id:(NSString*)org_id
{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString *newgroup_id = group_id;
    NSString *neworg_id = org_id;
    if ([group_id  isEqual: @"0"]) {
        newgroup_id = @"1";
    }
    if ([org_id  isEqual: @"0"]) {
        neworg_id = @"1";
    }
    
    // LockModel.lockMac = @"";
    
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/bindingAdmin?clientId=%@&accessToken=%@&date=%@&lockKey=%@&lockMac=%@&lockName=%@&lockVersion={\"protocolType\": \"%@\",\"protocolVersion\": \"%@\",\"scene\":\"%@\",\"groupId\":\"%@\",\"orgId\":\"%@\"}&aesKeyStr=%@&lockFlagPos=%d",URL,TTAppkey,[SettingHelper getAccessToken],date,LockModel.lockKey,LockModel.lockMac,LockModel.lockName,protocol_type,protocol_version,scene,newgroup_id,neworg_id,LockModel.aesKeyStr,LockModel.lockFlagPos];
    
    NSLog(@"绑定管理员url:%@",url);
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"绑定管理员 send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //  [MyLog logFormate:@"response:%@",response];
    NSLog(@"绑定管理员的response:%@", response);
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSString * errmsg = [resultsDictionary objectForKey:@"errmsg"];
    
    if (!errcode) {
        
//        NSString * roomid = [resultsDictionary objectForKey:@"lockId"];
//        NSString * keyid = [resultsDictionary objectForKey:@"keyId"];
        
//        LockModel.lockId = roomid.intValue;
//        LockModel.keyId = keyid.intValue;
        return 0;
    }
    NSLog(@"errmsg = %@", errmsg);
    return errcode.intValue;
    
}
+(int)unbindLockId:(int)lockId
              date:(NSString*)date{
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/unbind?clientId=%@&accessToken=%@&date=%@&lockId=%i",URL,TTAppkey,[SettingHelper getAccessToken],date,lockId];
    [MyLog logFormate:@"解除绑定url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    if (!errcode) {
        errcode = @"-1";
    }
    
    return errcode.intValue;
}
+(id)loginWithUsername:(NSString*)username
              password:(NSString*)password{
    
    NSString * contentString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&grant_type=%@&username=%@&password=%@&redirect_uri=%@",TTAppkey,TTAppSecret,@"password",username,[RequestService md5:password],TTRedirectUri];
    
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSMutableData *postBody = [[NSMutableData alloc]initWithData:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"%@/oauth2/token",URL];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPBody:postBody];
    [urlRequest setHTTPMethod:@"POST"];
    NSString *contentType = [NSString stringWithFormat:@"application/x-www-form-urlencoded"];
    [urlRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return [NSString stringWithFormat:@"%d",NET_REQUEST_ERROR_NO_DATA];
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    NSString * errmsg= [resultsDictionary objectForKey:@"errmsg"];
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    if (!errmsg) {
        return resultsDictionary;
    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:errmsg?errmsg:@"未知错误" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alterView show];
        });
        
    }
    return errcode;
    
}
/*
 
 &message=give+you+message
 
 
 反馈：
 
 {
 " errcode ": 0,
 " errmsg ": "none error message"
 }
 
 */

+(int)SendEKey_roomid:(NSString *)roomid
            startDate:(NSString *)startDate
              endDate:(NSString*)endDate
                  key:(NSString*)key
                  mac:(NSString *)mac
              message:(NSString *)message
             receiver:(NSString*)receiver

{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/key/send?clientId=%@&accessToken=%@&receiverUsername=%@&lockId=%@&date=%@&startDate=%@&endDate=%@&remarks=%@",URL,TTAppkey,[SettingHelper getAccessToken],receiver,roomid,date,startDate,endDate,message];
    
    [MyLog logFormate:@"发送电子钥匙url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    NSLog(@"发送电子钥匙response:%@",response);
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    return errcode.intValue;
    
}

//获取电子钥匙列表
+(NSMutableArray*)requestEkeys
{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/key/listShareKey?clientId=%@&accessToken=%@&date=%@",URL,TTAppkey,[SettingHelper getAccessToken],date];
    
    [MyLog logFormate:@"ekey列表 url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return Nil;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"获取电子钥匙列表response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    if (!errcode) {
        
        NSArray * array = [resultsDictionary objectForKey:@"list"];
        NSMutableArray * keyList = [[NSMutableArray alloc]init];
        for (NSDictionary* keyItem in array) {
//            NSNumber * start_date = [keyItem objectForKey:@"startDate"];
//            NSNumber * end_date = [keyItem objectForKey:@"endDate"];
            NSNumber * key_id = [keyItem objectForKey:@"keyId"];
            NSNumber * room_id = [keyItem objectForKey:@"lockId"];
//            NSNumber * date = [keyItem objectForKey:@"date"];
            
            LockModel * key = [[LockModel alloc]init];
//            key.startDate = start_date.longLongValue/1000;
//            key.endDate = end_date.longLongValue/1000;
//            key.date = date.longLongValue/1000;
//            key.keyId = key_id.intValue;
            key.lockId = room_id.intValue;
            key.lockAlias = [NSString stringWithFormat:@"%@-%@",room_id,key_id];
            [keyList addObject:key];
        }
        return keyList;
        
    }
    
    return Nil;
}

//下载电子钥匙
//+(int)downloadEkey_key:(LockModel*)key
//
//{
//    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
//    NSString * url = [NSString stringWithFormat:@"%@/v3/key/download?clientId=%@&accessToken=%@&date=%@&keyId=%i&lockId=%i",URL,TTAppkey,[SettingHelper getAccessToken],date,key.keyId,key.lockId];
//    
//    [MyLog logFormate:@"下载电子钥匙url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
//    
//    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"GET"];
//    
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
//    if (data == nil) {
//        NSLog(@"send request failed: %@", error);
//        return NET_REQUEST_ERROR_NO_DATA;
//    }
//    
//    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"下载电子钥匙response:%@",response);
//    [MyLog logFormate:@"下载电子钥匙response:%@",response];
//    
//    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
//    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//    
//    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
//    
//    
//    if (!errcode) {
//        
//        NSString * lock_name = [resultsDictionary objectForKey:@"lockName"];
//        
//        key.lockKey = [resultsDictionary objectForKey:@"lockKey"];
//        
//        NSTimeInterval startDate = 0;
//        NSTimeInterval endDate = 0;
//        NSNumber *sdate = [resultsDictionary objectForKey:@"startDate"];
//        NSNumber *edate = [resultsDictionary objectForKey:@"endDate"];
//        if (sdate && edate) {
//            startDate = sdate.longLongValue / 1000;
//            endDate = edate.longLongValue / 1000;
//        }
//        else {
//            
//        }
//        NSNumber * date = [resultsDictionary objectForKey:@"date"];
//        NSNumber * unlock_flag = [resultsDictionary objectForKey:@"lockFlagPos"];
//        key.aesKeyStr =  [resultsDictionary objectForKey:@"aesKeyStr"];;
//        
//        key.lockVersion = [NSString stringWithFormat:@"%@.%@.%@.%@.%@",[resultsDictionary objectForKey:@"protocolType"],[resultsDictionary objectForKey:@"protocolVersion"],[resultsDictionary objectForKey:@"scene"],[resultsDictionary objectForKey:@"groupId"],[resultsDictionary objectForKey:@"orgId"]];
//        key.lockMac =  [resultsDictionary objectForKey:@"lockMac"];;
//        key.date = date.longLongValue/1000;
//        key.startDate = startDate;
//        key.endDate = endDate;
//        key.lockName = lock_name;
//        key.lockAlias = lock_name;
//        key.lockFlagPos = unlock_flag.intValue;
//        key.isAdmin = NO;
//        return 0;
//        
//    }
//    
//    return errcode.intValue;
//}

+(int)uploadUnlockRecord_success:(BOOL)success
                          roomID:(int)roomid{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/uploadRecord?clientId=%@&accessToken=%@&date=%@&lockId=%i&success=%i&unlockDate=%@",URL,TTAppkey,[SettingHelper getAccessToken],date,roomid,success,date];
    
    [MyLog logFormate:@"上传开锁记录url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    if (!errcode) {
        errcode = @"-1";
    }
    
    return errcode.intValue;
    
}

+(NSMutableArray*)requetUnlockRecords_roomID:(int)roomid
                                        page:(int)page

{
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/listRecords?clientId=%@&accessToken=%@&date=%@&pageNo=%i&lockId=%i&pageSize=20",URL,TTAppkey,[SettingHelper getAccessToken],date,page,roomid];
    
    [MyLog logFormate:@"获取开锁记录url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return Nil;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    
    if (!errcode) {
        
        NSArray * array = [resultsDictionary objectForKey:@"list"];
        
        NSMutableArray * keyList = [[NSMutableArray alloc]init];
        
        for (NSDictionary* keyItem in array) {
            
            NSNumber * recordid = [keyItem objectForKey:@"lockId"];
            NSNumber * openid = [NSNumber numberWithLong:[[keyItem objectForKey:@"username"] longValue]] ;
            NSNumber * success = [keyItem objectForKey:@"success"];
            //NSNumber * room_id = [keyItem objectForKey:@"room_id"];
            NSNumber * date = [keyItem objectForKey:@"unlockDate"];
            
            UnlockRecord * record = [[UnlockRecord alloc]initWithRecordID:recordid.intValue openID:openid.stringValue success:success.intValue date:[NSDate dateWithTimeIntervalSince1970:date.longLongValue/1000]];
            
            [keyList addObject:record];
            
        }
        
        
        return keyList;
        
    }
    
    return Nil;
    
}

+(NSMutableArray*)requetRoomUsers_roomID:(int)roomid{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/listAllKey?clientId=%@&accessToken=%@&date=%@&lockId=%i",URL,TTAppkey,[SettingHelper getAccessToken],date,roomid];
    
    [MyLog logFormate:@"获取锁用户url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return Nil;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    if (!errcode) {
        
        NSArray * array = [resultsDictionary objectForKey:@"list"];
        
        NSMutableArray * keyList = [[NSMutableArray alloc]init];
        
        for (NSDictionary* keyItem in array) {
            
            NSNumber * key_id = [keyItem objectForKey:@"keyId"];
            NSString * key_status = [keyItem objectForKey:@"keyStatus"];
            NSNumber * date = [keyItem objectForKey:@"date"];
            NSNumber * openid =  [keyItem objectForKey:@"openid"] ;
            NSNumber * room_id = [keyItem objectForKey:@"lockId"];
            NSNumber * start_date = [keyItem objectForKey:@"startDate"];
            NSNumber * end_date = [keyItem objectForKey:@"endDate"];
            
            UserInfo * user = [[UserInfo alloc]init];
            user.openid = openid.stringValue;
            user.status = key_status;
            user.keyId = key_id.stringValue;
            user.date = [NSDate dateWithTimeIntervalSince1970:date.longLongValue/1000];
            user.startDate = [NSDate dateWithTimeIntervalSince1970:start_date.longLongValue/1000];
            user.endDate = [NSDate dateWithTimeIntervalSince1970:end_date.longLongValue/1000];
            user.lockId = room_id.stringValue;
            [keyList addObject:user];
        }
        
        return keyList;
        
    }
    
    return Nil;
    
}

+(int)blockUser_kid:(int)kid
             roomID:(int)roomid
             openid:(NSString*)openid{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/key/freeze?clientId=%@&accessToken=%@&openid=%@&date=%@&lockId=%i&keyId=%i",URL,TTAppkey,[SettingHelper getAccessToken],openid,date,roomid,kid];
    
    [MyLog logFormate:@"冻结url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    return errcode.intValue;
    
}

+(int)unblockUser_kid:(int)kid
               roomID:(int)roomid{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/key/unfreeze?clientId=%@&accessToken=%@&openid=%@&date=%@&lockId=%i&keyId=%i",URL,TTAppkey,[SettingHelper getAccessToken],[SettingHelper getOpenID],date,roomid,kid];
    
    [MyLog logFormate:@"解除冻结url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    return errcode.intValue;
    
}


+(int)requestUserInfo_userinfo:(UserInfo*)user{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/v3/user/getUserInfo?clientId=%@&clientSecret=%@&openid=%@&date=%@",URL,TTAppkey,TTAppSecret,user.openid,date];
    
    [MyLog logFormate:@"delete user url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    [MyLog logFormate:@"33333333333333response:%@",response];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    NSString * headurl = [resultsDictionary objectForKey:@"headurl"];
    NSString * nickname = [resultsDictionary objectForKey:@"nickname"];
    user.headurl = headurl;
    user.nickname = nickname;
    
    return errcode.intValue;
    
}

+(int)resetKeyboardPasswordWithLockId:(int)lockId
                              pwdInfo:(NSString*)pwdInfo
                            timestamp:(NSString*)timestamp{
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    
    NSString * contentString = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&pwdInfo=%@&timestamp=%@&date=%@",TTAppkey,[SettingHelper getAccessToken],lockId,pwdInfo,timestamp,date];
    
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSMutableData *postBody = [[NSMutableData alloc]initWithData:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"%@/v3/keyboardPwd/reset",URL];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postBody];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    return errcode.intValue;
    
    
    
}


+(id)UseKPSWithLockId:(int)lockId keyboardPwdVersion:(int)keyboardPwdVersion keyboardPwdType:(int)keyboardPwdType receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate{
    
    NSString *url = [NSString stringWithFormat:@"%@/v3/keyboardPwd/get",URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%@&keyboardPwdVersion=%d&keyboardPwdType=%d&receiverUsername=%@&date=%@&startDate=%@&endDate=%@", TTAppkey, [SettingHelper getAccessToken],[NSString stringWithFormat:@"%d", lockId], keyboardPwdVersion, keyboardPwdType, receiverUsername, [XYCUtils GetCurrentTimeInMillisecond],startDate,endDate];
    
    [MyLog logFormate:@"delete user url:%@", [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return  [NSNumber numberWithInt:-1];
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    NSLog(@"获取键盘密码body = %@", body);
    NSLog(@"获取键盘密码response = %@", response);
    
    if (!errcode || errcode.intValue == 0) {
        NSString * keyboardPwd = (NSString* )[resultsDictionary objectForKey:@"keyboardPwd"];
        return keyboardPwd;
    }
    
    return  [NSNumber numberWithInt:errcode.intValue];
}



+(int)UploadKpsclientId:(NSString*)clientId
            accessToken:(NSString *)accessToken
                 lockId:(int)lockid
           currentindex:(int)currentIndex
    fourKeyboardPwdList:(NSMutableString *)psListString
          timeControlTb:(NSString*)timeControlString
               position:(NSString*)posString
             checkDigit:(NSMutableString*)checkString {
    
    NSString *url = [NSString stringWithFormat:@"%@/v3/keyboardPwd/uploadv3", URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&currentIndex=%i&fourKeyboardPwdList=%@&timeControlTb=%@&position=%@&checkDigit=%@&date=%@", clientId,accessToken,lockid,currentIndex,psListString,timeControlString,posString,checkString, [XYCUtils GetCurrentTimeInMillisecond]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"V2AES备份键盘密码body = %@", body);
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSLog(@"V2AES备份键盘密码response = %@", response);
    
    NSLog(@"发送用户密码errcode = %@", errcode);
    
    if (!errcode || errcode.intValue == 0) {
        return 0;
    }
    
    return errcode.intValue;
    
}

+(id)RequestKpsUsageWithLockId:(int)lockId pageNo:(int)pageNo pageSize:(int)pageSize {
    NSString *url = [NSString stringWithFormat:@"%@/v3/keyboardPwd/listRecords",URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&pageNo=%d&pageSize=%d&date=%@",TTAppkey,[SettingHelper getAccessToken],lockId, pageNo, pageSize, [XYCUtils GetCurrentTimeInMillisecond]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    NSLog(@"获取键盘密码记录的url == %@", url);
    
    
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return @"请求失败";
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"获取键盘密码记录的response == %@", response);
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    
    NSLog(@"发送用户密码errcode = %@", errcode);
    
    if (!errcode || errcode.intValue == 0) {
        NSMutableArray * arrayResult = [[NSMutableArray alloc]init];
        NSArray * array = (NSArray* )[resultsDictionary objectForKey:@"list"];
        for (NSDictionary * item in array) {
            
            NSString * recordId = [item objectForKey:@"id"];
//            NSString * roomId = [item objectForKey:@"roomId"];
            NSString * senderUid = [item objectForKey:@"senderUid"];
            NSString * receiverUid = [item objectForKey:@"receiverUid"];
            NSString * receiverUsername = [item objectForKey:@"receiverUsername"];
            NSString * keyboardPwd = [item objectForKey:@"keyboardPwd"];
            NSString * keyboardPwdVersion = [item objectForKey:@"keyboardPwdVersion"];
            NSString * keyboardPwdType = [item objectForKey:@"keyboardPwdDesc"];
            NSString *  sendDate = [item objectForKey:@"sendDate"];
            
            TimePsRecord * time = [[TimePsRecord alloc] init];
            time.id = recordId.intValue;
//            time.lockId = roomId;
            time.sendUid = senderUid;
            time.receiveUid = receiverUid;
            time.receiveUsername = receiverUsername;
            time.passwordVersion = keyboardPwdVersion.intValue;
            time.passwordType = keyboardPwdType;
            time.date = [NSDate dateWithTimeIntervalSince1970:sendDate.longLongValue/1000];
            time.password = keyboardPwd;
            
            [arrayResult addObject:time];
            
        }
        NSLog(@"arrayResult = %@", arrayResult);
        return arrayResult;
    }
    
    return [NSString stringWithFormat:@"%d", errcode.intValue];
    
    
}


+(int)backUpkeyWithLockId:(int)lockId keyId:(int)keyId adminPs:(NSString *)adminPs nokeyPs:(NSString *)nokeyPs deletePs:(NSString *)deletePs backupPs:(NSString *)backupPs
{
    if (nokeyPs == NULL) {
        nokeyPs = @"";
    }
    if (deletePs == NULL) {
        deletePs = @"";
    }
    NSString *nokeypsStr = @"";
    NSString * deletePsStr = @"";
    if (![nokeyPs isEqualToString:@""]) {
        nokeypsStr = [SecurityUtil encodeBase64String:[TTUtils EncodeSharedKeyValue:nokeyPs]];
    }
    if (![deletePs isEqualToString:@""]) {
        deletePsStr = [SecurityUtil encodeBase64String:[TTUtils EncodeSharedKeyValue:deletePs]];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@/v3/key/backup", URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&keyId=%i&adminPs=%@&nokeyPs=%@&deletePs=%@&md5BackupPs=%@&date=%@", TTAppkey,[SettingHelper getAccessToken],lockId,keyId,adminPs,nokeypsStr,deletePsStr,backupPs, [XYCUtils GetCurrentTimeInMillisecond]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"备份钥匙的body = %@", body);
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSLog(@"备份钥匙的response = %@", response);
    if (!errcode || errcode.intValue == 0) {
        return 0;
    }
    
    return errcode.intValue;
    
    
}

//+(id)downloadBackup_keyWithLockId:(int)lockId keyId:(int)keyId backupPs:(NSString *)backupPs
//{
//    NSString *url = [NSString stringWithFormat:@"%@/v3/key/downloadBackup", URL];
//    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&keyId=%i&md5BackupPs=%@&date=%@", TTAppkey,[SettingHelper getAccessToken],lockId,keyId,backupPs,[XYCUtils GetCurrentTimeInMillisecond]];
//    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
//    [urlRequest setTimeoutInterval:30.0f];
//    [urlRequest setHTTPMethod:@"POST"];
//    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
//    NSLog(@"下载备份钥匙的body = %@", body);
//    
//    NSError *error = nil;
//    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
//    if (data == nil) {
//        NSLog(@"send request failed: %@", error);
//        
//        return [NSString stringWithFormat:@"%d", NET_REQUEST_ERROR_NO_DATA];
//        
//    }
//    
//    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    
//    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
//    
//    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
//    
//    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
//    NSLog(@"下载备份钥匙的response = %@", response);
//    if (!errcode || errcode.intValue == 0) {
//        
//        LockModel *key = [[LockModel alloc] init];
//        
//        key.lockKey = [resultsDictionary objectForKey:@"lockKey"];
//        
//        key.adminPwd = [resultsDictionary objectForKey:@"adminPs"];
//        
//        key.aesKeyStr = [resultsDictionary objectForKey:@"aesKeyStr"];
//        
//        
//        key.lockName = [resultsDictionary objectForKey:@"lockName"];
//        key.lockAlias = key.lockName;
//        key.startDate = [[resultsDictionary objectForKey:@"startDate"] longLongValue] / 1000;
//        key.endDate = [[resultsDictionary objectForKey:@"endDate"] longLongValue] / 1000;
//        key.hasbackup = YES;
//        NSString * nokeypsStr = [SecurityUtil decodeBase64String:[resultsDictionary objectForKey:@"nokeyPs"]];
//        key.noKeyPwd = [TTUtils DecodeSharedKeyValue:nokeypsStr];
//        key.lockMac = [resultsDictionary objectForKey:@"lockMac"];
//        NSString * deletePsStr = [SecurityUtil decodeBase64String:[resultsDictionary objectForKey:@"deletePs"]];
//        key.deletePwd = [TTUtils DecodeSharedKeyValue:deletePsStr];
//        NSString *userType = [resultsDictionary objectForKey:@"userType"];
//        if ([userType isEqual:@"110301"]) {
//            key.isAdmin = YES;
//        }else{
//            key.isAdmin = NO;
//        }
//        NSDictionary *dic = [NSDictionary dictionary];
//        dic = [resultsDictionary objectForKey:@"lockVersion"];
//        
//        key.lockVersion = [NSString stringWithFormat:@"%d.%d.%d.%d.%d", [[dic objectForKey:@"protocolType"] intValue], [[dic objectForKey:@"protocolVersion"] intValue],[[dic objectForKey:@"scene"] intValue],[[dic objectForKey:@"groupId"] intValue],[[dic objectForKey:@"groupId"] intValue]];
//        //        NSNumber *lockFlagPos = [resultsDictionary objectForKey:@"lockFlagPos"];
//        //    key.invalidFlag = lo;
//        return key;
//    }
//    return errcode;
//}



+(int)changeKeyNameWithLockId:(int)lockId lockAlias:(NSString *)lockAlias {
    NSString *url = [NSString stringWithFormat:@"%@/v3/lock/modifyLockInfo", URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&lockAlias=%@&date=%@", TTAppkey,[SettingHelper getAccessToken],lockId, lockAlias,[XYCUtils GetCurrentTimeInMillisecond]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"修改锁名的body = %@", body);
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSLog(@"修改锁名的response = %@", response);
    if (!errcode || errcode.intValue == 0) {
        return 0;
    }
    return errcode.intValue;
}

+(int)resetAllKeyWithLockId:(int)lockId lockFlagPos:(NSString *)lockFlagPos
{
    NSString *url = [NSString stringWithFormat:@"%@/v3/lock/resetAllKey", URL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%d&lockFlagPos=%@&date=%@", TTAppkey, [SettingHelper getAccessToken],lockId,lockFlagPos, [XYCUtils GetCurrentTimeInMillisecond]];
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString: [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:[[NSMutableData alloc]initWithData:[body dataUsingEncoding:NSUTF8StringEncoding]]];
    NSLog(@"重置电子钥匙的body = %@", body);
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSLog(@"重置电子钥匙的response = %@", response);
    if (!errcode || errcode.intValue == 0) {
        return 0;
    }
    
    return errcode.intValue;
    
}
+(NSString *) md5:(NSString *)inPutText
{
    if (!inPutText.length) return nil;
    
    const char *cStr = [inPutText UTF8String];//转换成utf-8
    
    unsigned char result[16];//开辟一个16字节（128位：md5加密出来就是128位/bit）的空间（一个字节=8字位=8个二进制数）
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);
    /*
     extern unsigned char *CC_MD5(const void *data, CC_LONG len, unsigned char *md)官方封装好的加密方法把cStr字符串转换成了32位的16进制数列（这个过程不可逆转） 存储到了result这个空间中
     */
    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];
    /*
     x表示十六进制，%02X  意思是不足两位将用0补齐，如果多余两位则不影响
     NSLog("%02X", 0x888);  //888
     NSLog("%02X", 0x4); //04
     */
}


/**
 
 Open Api V3
 
 */

+(int)initLock:(LockModel*)LockModel
 protocol_type:(NSString*)protocol_type
protocol_version:(NSString*)protocol_version
         scene:(NSString*)scene
      group_id:(NSString*)group_id
        org_id:(NSString*)org_id
{
    
    NSString* date = [XYCUtils GetCurrentTimeInMillisecond];
    NSString *newgroup_id = group_id;
    NSString *neworg_id = org_id;
    if ([group_id  isEqual: @"0"]) {
        newgroup_id = @"1";
    }
    if ([org_id  isEqual: @"0"]) {
        neworg_id = @"1";
    }
    
    // LockModel.lockMac = @"";
    
    
    
    NSString * url = [NSString stringWithFormat:@"%@/v3/lock/bindingAdmin?clientId=%@&accessToken=%@&date=%@&lockKey=%@&lockMac=%@&lockName=%@&lockVersion={\"protocolType\": \"%@\",\"protocolVersion\": \"%@\",\"scene\":\"%@\",\"groupId\":\"%@\",\"orgId\":\"%@\"}&aesKeyStr=%@&lockFlagPos=%d",URL,TTAppkey,[SettingHelper getAccessToken],date,LockModel.lockKey,LockModel.lockMac,LockModel.lockName,protocol_type,protocol_version,scene,newgroup_id,neworg_id,LockModel.aesKeyStr,LockModel.lockFlagPos];
    
    NSLog(@"绑定管理员url:%@",url);
    NSMutableURLRequest *urlRequest=[NSMutableURLRequest requestWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    
    [urlRequest setTimeoutInterval:30.0f];
    [urlRequest setHTTPMethod:@"GET"];
    
    NSError *error = nil;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:&error];
    if (data == nil) {
        NSLog(@"绑定管理员 send request failed: %@", error);
        return NET_REQUEST_ERROR_NO_DATA;
    }
    
    NSString *response = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    //  [MyLog logFormate:@"response:%@",response];
    NSLog(@"绑定管理员的response:%@", response);
    NSData* jsonData = [response dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* resultsDictionary =[NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSString * errcode = [resultsDictionary objectForKey:@"errcode"];
    NSString * errmsg = [resultsDictionary objectForKey:@"errmsg"];
    
    if (!errcode) {
        
        NSString * roomid = [resultsDictionary objectForKey:@"lockId"];
//        NSString * keyid = [resultsDictionary objectForKey:@"keyId"];
        
        LockModel.lockId = roomid.intValue;
//        LockModel.keyId = keyid.intValue;
        return 0;
    }
    NSLog(@"errmsg = %@", errmsg);
    return errcode.intValue;
    
}


@end
