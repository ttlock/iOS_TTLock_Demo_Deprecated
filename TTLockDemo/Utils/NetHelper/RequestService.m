//
//  RequestService.m
//  BTstackCocoa
//
//  Created by wan on 13-3-7.
//
//

#import "RequestService.h"
#import "DateHelper.h"
#import "Define.h"
#import "UnlockRecord.h"
#import "AppDelegate.h"
#import "KeyboardPwd.h"
#import "CommonCrypto/CommonDigest.h"

@implementation RequestService

+(id)loginWithUsername:(NSString*)username
              password:(NSString*)password{
    
    NSString * contentString = [NSString stringWithFormat:@"client_id=%@&client_secret=%@&username=%@&password=%@",TTAppkey,TTAppSecret,username,[RequestService md5:password]];
    
    contentString = [contentString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    
    NSMutableData *postBody = [[NSMutableData alloc]initWithData:[contentString dataUsingEncoding:NSUTF8StringEncoding]];
    NSString *url = [NSString stringWithFormat:@"%@/oauth2/token",TTLockLoginURL];
    
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
            UIAlertView *alterView = [[UIAlertView alloc]initWithTitle:errmsg?errmsg:@"unkown error" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles:LS(@"words_sure_ok") , nil];
            [alterView show];
        });
        
    }
    return errcode;
    
}

+(NSMutableArray*)requetUnlockRecords_roomID:(int)roomid
                                        page:(int)page

{
    NSString* date = [DateHelper GetCurrentTimeInMillisecond];
    NSString * url = [NSString stringWithFormat:@"%@/lock/listRecords?clientId=%@&accessToken=%@&date=%@&pageNo=%i&lockId=%i&pageSize=20",TTLockURL,TTAppkey,[SettingHelper getAccessToken],date,page,roomid];
    
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


+(id)UseKPSWithLockId:(int)lockId keyboardPwdVersion:(int)keyboardPwdVersion keyboardPwdType:(int)keyboardPwdType receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate{
    
    NSString *url = [NSString stringWithFormat:@"%@/keyboardPwd/get",TTLockURL];
    NSString * body = [NSString stringWithFormat:@"clientId=%@&accessToken=%@&lockId=%@&keyboardPwdVersion=%d&keyboardPwdType=%d&receiverUsername=%@&date=%@&startDate=%@&endDate=%@", TTAppkey, [SettingHelper getAccessToken],[NSString stringWithFormat:@"%d", lockId], keyboardPwdVersion, keyboardPwdType, receiverUsername, [DateHelper GetCurrentTimeInMillisecond],startDate,endDate];
    
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

    if (!errcode || errcode.intValue == 0) {
        NSString * keyboardPwd = (NSString* )[resultsDictionary objectForKey:@"keyboardPwd"];
        return keyboardPwd;
    }
    
    return  [NSNumber numberWithInt:errcode.intValue];
}



+(NSString *) md5:(NSString *)inPutText
{
    if (!inPutText.length) return nil;
    
    const char *cStr = [inPutText UTF8String];
    
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result);

    return [[NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
             result[0], result[1], result[2], result[3],
             result[4], result[5], result[6], result[7],
             result[8], result[9], result[10], result[11],
             result[12], result[13], result[14], result[15]
             ] lowercaseString];

}



@end
