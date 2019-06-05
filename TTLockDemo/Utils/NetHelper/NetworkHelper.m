//
//  NetworkHelper.m
//  TTLockDemo
//
//  Created by LXX on 17/2/7.
//  Copyright © 2017年 wjj. All rights reserved.
//

#import "NetworkHelper.h"
#import "SettingHelper.h"
#import "DateHelper.h"
#import <MJExtension/MJExtension.h>


static NSString *const AppDomain = @"AppDomain";
@implementation NetworkHelper

+ (void)lockInitializeWithlockAlias:(NSString *)lockAlias lockData:(NSString*)lockData completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    
    parame[@"lockAlias"] = lockAlias;
    parame[@"lockData"] = lockData;
    
    [NetworkHelper apiPost:@"lock/initialize" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
    
}

+ (void)listOfLock:(NSInteger)pageNo completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"pageNo"] = @(pageNo);
    parame[@"pageSize"] = @(20);
    [NetworkHelper apiPost:@"lock/list" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)keyListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"pageNo"] = @(pageNo);
    parame[@"pageSize"] = @(20);
    parame[@"lockId"] = @(lockId);
    [NetworkHelper apiPost:@"lock/listKey" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)deleteAllKey:(NSInteger)lockId completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    [NetworkHelper apiPost:@"lock/deleteAllKey" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)keyboardPwdListOfLock:(NSInteger)lockId pageNo:(NSInteger)pageNo completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"pageNo"] = @(pageNo);
    parame[@"pageSize"] = @(20);
    parame[@"lockId"] = @(lockId);
    [NetworkHelper apiPost:@"lock/listKeyboardPwd" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}

+ (void)changeAdminKeyboardPwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"password"] = password;
    [NetworkHelper apiPost:@"lock/changeAdminKeyboardPwd" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}

+ (void)changeDeletePwd:(NSString*)password lockId:(NSInteger)lockId completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    
    parame[@"lockId"] = @(lockId);
    parame[@"password"] = password;
    [NetworkHelper apiPost:@"lock/changeDeletePwd" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)rename:(NSString*)lockAlias lockId:(NSInteger)lockId completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"lockAlias"] = lockAlias;
    [NetworkHelper apiPost:@"lock/rename" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)resetKey:(NSInteger)lockFlagPos lockId:(NSInteger)lockId completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"lockFlagPos"] = @(lockFlagPos);
    [NetworkHelper apiPost:@"lock/resetKey" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)resetKeyboardPwd:(NSString*)pwdInfo lockId:(NSInteger)lockId timestamp:(NSString*)timestamp completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"pwdInfo"] = pwdInfo;
    parame[@"timestamp"] = timestamp;
    [NetworkHelper apiPost:@"lock/resetKeyboardPwd" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)getKeyboardPwdVersion:(NSInteger)lockId completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    [NetworkHelper apiPost:@"lock/getKeyboardPwdVersion" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}


+ (void)sendKey:(NSInteger)lockId receiverUsername:(NSString *)receiverUsername startDate:(NSString*)startDate endDate:(NSString*)endDate remarks:(NSString *)remarks completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"receiverUsername"] = receiverUsername;
    if (startDate)
        parame[@"startDate"] = startDate;
    if (endDate)
        parame[@"endDate"] = endDate;
    if (remarks)
        parame[@"remarks"] = remarks;
    [NetworkHelper apiPost:@"key/send" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)getkeyListWithCompletion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lastUpdateDate"] = @(0);
    [NetworkHelper apiPost:@"key/syncData" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)deleteKey:(NSInteger)keyId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"keyId"] = @(keyId);
    [NetworkHelper apiPost:@"key/delete" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

};

+ (void)freezeKey:(NSInteger)keyId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"keyId"] = @(keyId);
    [NetworkHelper apiPost:@"key/freeze" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}

+ (void)unFreezeKey:(NSInteger)keyId completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"keyId"] = @(keyId);
    [NetworkHelper apiPost:@"key/unfreeze" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}

+ (void)changeKeyPeriod:(NSInteger)keyId startDate:(NSString*)startDate endDate:(NSString*)endDate completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"keyId"] = @(keyId);
    parame[@"startDate"] = startDate;
    parame[@"endDate"] = endDate;
    [NetworkHelper apiPost:@"key/changePeriod" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}


+(void)getKeyboardPwd:(NSInteger)lockId keyboardPwdVersion:(NSInteger)keyboardPwdVersion keyboardPwdType:(NSInteger)keyboardPwdType startDate:(NSString *)startDate endDate:(NSString *)endDate completion:(RequestBlock)completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = @(lockId);
    parame[@"keyboardPwdVersion"] = @(keyboardPwdVersion);
    parame[@"keyboardPwdType"] = @(keyboardPwdType);
    parame[@"startDate"] = startDate;
    parame[@"endDate"] = endDate;
    
    [NetworkHelper apiPost:@"keyboardPwd/get" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}


+ (void)deleteKeyboardPwd:(NSInteger)keyboardPwdId lockId:(NSInteger)lockId deleteType:(NSInteger)deleteType completion:(RequestBlock) completion
{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"keyboardPwdId"] = @(keyboardPwdId);
    parame[@"lockId"] = @(lockId);
    parame[@"deleteType"] = @(deleteType);
    [NetworkHelper apiPost:@"keyboardPwd/delete" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];

}

+ (void)getUidWithCompletion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [NetworkHelper apiPost:@"user/getUid" parameters:parame completion:completion];
}
+ (void)isInitSuccessWithGatewayNetMac:(NSString*)gatewayNetMac completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:gatewayNetMac forKey:@"gatewayNetMac"];
    [NetworkHelper apiPost:@"gateway/isInitSuccess" parameters:parame completion:completion];
}
+ (void)getGatewayListWithCompletion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:@(1) forKey:@"pageNo"];
    [parame setObject:@100 forKey:@"pageSize"];
    [NetworkHelper apiPost:@"gateway/list" parameters:parame completion:completion];

}
+ (void)getGatewayListLockWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:gatewayId forKey:@"gatewayId"];
     [NetworkHelper apiPost:@"gateway/listLock" parameters:parame completion:completion];
}
+ (void)deleteGatewayWithGatewayId:(NSNumber*)gatewayId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:gatewayId forKey:@"gatewayId"];
    [NetworkHelper apiPost:@"gateway/delete" parameters:parame completion:completion];
}
+ (void)lockQueryDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:lockId forKey:@"lockId"];
    [NetworkHelper apiPost:@"lock/queryDate" parameters:parame completion:completion];
}
+ (void)lockUpdateDateWithLockId:(NSNumber*)lockId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    [parame setObject:lockId forKey:@"lockId"];
    [NetworkHelper apiPost:@"lock/updateDate" parameters:parame completion:completion];
}

+(void)lockUpgradeCheckWithLockId:(int)lockId
                 completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = [NSNumber numberWithInt:lockId] ;
  
      [NetworkHelper apiPost:@"lock/upgradeCheck" parameters:parame completion:completion];
    
}
+(void)getRecoverDataWithClientId:(NSString*)clientId
                      accessToken:(NSString*)accessToken
                           lockId:(int)lockId
                       completion:(RequestBlock)completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = [NSNumber numberWithInt:lockId] ;
    
    [NetworkHelper apiPost:@"lock/getRecoverData" parameters:parame completion:completion];

    
}
+(void)lockUpgradeRecheckWithLockId:(int)lockId
                   modelNum:(NSString*)modelNum
           hardwareRevision:(NSString*)hardwareRevision
           firmwareRevision:(NSString*)firmwareRevision
               specialValue:(long long)specialValue
                 completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = [NSNumber numberWithInt:lockId] ;
    if (specialValue != -1) parame[@"specialValue"] = @(specialValue);
    if (modelNum.length>0) parame[@"modelNum"] = modelNum;
    if (hardwareRevision.length>0) parame[@"hardwareRevision"] = hardwareRevision;
    if (firmwareRevision.length>0) parame[@"firmwareRevision"] =  firmwareRevision;
    [NetworkHelper apiPost:@"lock/upgradeRecheck" parameters:parame completion:completion];
    
}
+(void)roomUpgradeRecheckWithLockId:(int)lockId
                      specialValue:(int)specialValue
                        completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = [NSNumber numberWithInt:lockId] ;
    parame[@"specialValue"] = [NSNumber numberWithInt:specialValue] ;
    [NetworkHelper apiPost:@"room/updateSuccess" parameters:parame completion:completion];
  
}
+(void)gatewayUpgradeCheckWithGatewayId:(NSNumber *)gatewayId
                             completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"gatewayId"] = gatewayId;
    [NetworkHelper apiPost:@"gateway/upgradeCheck" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+(void)gatewayuploadDetailWithGatewayId:(NSNumber *)gatewayId
                               modelNum:(NSString*)modelNum
                       hardwareRevision:(NSString*)hardwareRevision
                       firmwareRevision:(NSString*)firmwareRevision
                            networkName:(NSString *)networkName
                             completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"gatewayId"] = gatewayId;
    parame[@"modelNum"] = modelNum;
    parame[@"hardwareRevision"] = hardwareRevision;
    parame[@"firmwareRevision"] = firmwareRevision;
    parame[@"networkName"] = networkName;
    [NetworkHelper apiPost:@"gateway/uploadDetail" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}


+(void)addWirelessKeypadName:(NSString *)name
                      number:(NSString *)number
                         mac:(NSString *)mac
                specialValue:(long long)specialValue
                      lockId:(NSNumber *)lockId
                  completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = lockId;
    parame[@"wirelessKeyboardNumber"] = number;
    parame[@"wirelessKeyboardName"] = name;
    parame[@"wirelessKeyboardMac"] = mac;
    parame[@"wirelessKeyboardSpecialValue"] = @(specialValue);
    [NetworkHelper apiPost:@"wirelessKeyboard/add" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)deleteWirelessKeypadWithID:(NSString *)ID completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"wirelessKeyboardId"] = ID;
    [NetworkHelper apiPost:@"wirelessKeyboard/delete" parameters:parame completion:^(id info, NSError *error) {
        completion(info,error);
    }];
}

+ (void)getWirelessKeypadListWithLockId:(NSNumber *)lockId completion:(RequestBlock) completion{
    NSMutableDictionary *parame = [NetworkHelper initParame];
    parame[@"lockId"] = lockId;
    [NetworkHelper apiPost:@"wirelessKeyboard/listByLock" parameters:parame completion:^(id info, NSError *error) {
        completion(info[@"list"],error);
    }];
}


#pragma mark - parame
+ (NSMutableDictionary*)initParame
{
    NSMutableDictionary *parame = [NSMutableDictionary new];
    parame[@"clientId"] = TTAppkey;
    parame[@"accessToken"] = [SettingHelper getAccessToken];
    parame[@"date"] = [DateHelper GetCurrentTimeInMillisecond]; 
    return parame;
}


#pragma mark - AFNetworking
+ (NSMutableDictionary*)V3_DefaultParam
{
    NSMutableDictionary *parame = [NSMutableDictionary new];
    //    KKUserModel *userModel = [KKUserManager getUserModel];
    //    if ([userModel.accessToken length]) {
    //        parame[@"accessToken"] = userModel.accessToken;
    //    }
//    parame[@"uniqueid"] = [PTHelper uuid];
    long long date =[[NSDate date] timeIntervalSince1970]*1000;
    parame[@"date"] = @(date);
    return parame;
}

+ (void)apiPost:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion{
    
    NSMutableDictionary* defaultParams = [NetworkHelper V3_DefaultParam];
    if ([defaultParams count])
        [parameters addEntriesFromDictionary:defaultParams];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",TTLockURL,method];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    AFHTTPSessionManager *manager = [NetworkHelper apiRequestSeesion:serializer];
    NSURLRequest *request = [serializer requestWithMethod:@"POST" URLString:url parameters:parameters error:nil];
    
    [manager POST:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSError *error = nil;
        id valueData = [self apiResponseParse:responseObject error:&error];

        [NetworkHelper logDebugInfoWithResponse:responseObject url:url error:error];
        if (completion)
            completion(valueData,error);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
  
        [NetworkHelper logDebugInfoWithResponse:nil url:url error:error];
        
        if (completion)
            completion(nil, error);
    }];
    

    
    [NetworkHelper logDebugInfoWithRequest:request apiName:method requestParams:parameters httpMethod:@"POST"];
}

+ (void)apiGet:(NSString *)method parameters:(NSMutableDictionary *)parameters completion:(RequestBlock)completion{
    
    NSMutableDictionary* defaultParams = [NetworkHelper V3_DefaultParam];
    if ([defaultParams count])
        [parameters addEntriesFromDictionary:defaultParams];
    
    NSString *url = [NSString stringWithFormat:@"%@/%@",TTLockURL,method];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    
    AFHTTPSessionManager *manager = [NetworkHelper apiRequestSeesion:serializer];
    NSURLRequest *request = [serializer requestWithMethod:@"GET" URLString:url parameters:parameters error:nil];
    
    [manager GET:url parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *error = nil;
        id valueData = [self apiResponseParse:responseObject error:&error];
     
        [NetworkHelper logDebugInfoWithResponse:responseObject url:url error:error];
        if (completion)
            completion(valueData,error);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [NetworkHelper logDebugInfoWithResponse:nil url:url error:error];
        if (completion)
            completion(nil, error);
    }];
    
    [NetworkHelper logDebugInfoWithRequest:request apiName:method requestParams:parameters httpMethod:@"GET"];
}

- (NSMutableURLRequest*)apiRequestPOST:(NSString*)method withJSONData:(NSDictionary*)dict files:(NSArray*)files {
    NSMutableDictionary* params = [NetworkHelper V3_DefaultParam];
    if ([dict count]) {
        [params addEntriesFromDictionary:dict];
    }
    AFHTTPRequestSerializer* httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [httpRequestSerializer multipartFormRequestWithMethod:@"POST" URLString:TTLockURL parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        for (id filePath in files) {
            if ([filePath isKindOfClass:[NSString class]]) {
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath isDirectory:NO] name:@"file" fileName:@"file" mimeType:@"image/png" error:nil];
            }
            else if ([filePath isKindOfClass:[NSData class]]) {
                [formData appendPartWithFileData:filePath name:@"file" fileName:@"file" mimeType:@"application/octet-stream"];
            }
        }
    } error:nil];
    request.timeoutInterval = 20.f;
    NSLog(request.URL.absoluteString, nil);
    return request;
}


+ (AFHTTPSessionManager *)apiRequestSeesion:(AFHTTPRequestSerializer *)serializer{
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    NSString *accessToken = [SettingHelper getAccessToken];
//    NSString* date = [DateHelper GetCurrentTimeInMillisecond];
//    [serializer setValue:TTAppkey forHTTPHeaderField:@"clientId"];
//    [serializer setValue:accessToken forHTTPHeaderField:@"accessToken"];
//    [serializer setValue:date forHTTPHeaderField:@"date"];
//    serializer.timeoutInterval = 20.f;
//    manager.requestSerializer = serializer;
    
    return manager;
}


+ (id)apiResponseParse:(id)responseObject error:(NSError **)error
{
    

      NSDictionary *data = responseObject;
      NSString * errorCode = responseObject[@"errcode"];
      NSString * errorMsg  = responseObject[@"errmsg"];

    if (errorCode.intValue < 0) {
 
         [SSToastHelper showToastWithStatus:errorMsg];
    }
        id valueData = nil;
        BOOL isValid = (errorCode == nil || [errorCode intValue] == 0);
        valueData = data;
        if (!isValid) {
            if (nil != error) {
                *error = [NSError errorWithDomain:AppDomain code:[errorCode integerValue] userInfo:@{NSLocalizedDescriptionKey:errorMsg}];
                
                if ([errorCode intValue] == 10004) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"invalid grant" object:nil];
                }
            }
            valueData = nil;
        }
        if ([valueData isKindOfClass:[NSNull class]]) {
            valueData = nil;
        }
        return valueData;
}

+ (void)logDebugInfoWithRequest:(NSURLRequest *)request apiName:(NSString *)apiName requestParams:(NSDictionary *)requestParams httpMethod:(NSString *)httpMethod
{
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n**************************************************************\n*                       Request Start                        *\n**************************************************************\n\n"];
    
    [logString appendFormat:@"API Name:\t\t%@\n", TTLockURL];
    [logString appendFormat:@"Method:\t\t%@\n",httpMethod];
    [logString appendFormat:@"URL:\t\t%@\n",request.URL];
    [logString appendFormat:@"Params:\n%@", requestParams];
    
    [logString appendFormat:@"\n\nHTTP Header:\n%@", request.allHTTPHeaderFields];
    
    [logString appendFormat:@"\n*********************************\tRequest End\t*********************************\n\n\n\n"];
    NSLog(@"%@", logString);
}

+ (void)logDebugInfoWithResponse:(id)response url:(NSString *)url error:(NSError *)error
{
    BOOL shouldLogError = error ? YES : NO;
    
    NSMutableString *logString = [NSMutableString stringWithString:@"\n\n==============================================================\n=                        API Response                        =\n==============================================================\n"];
    [logString appendFormat:@"\nHTTP URL:\n\t%@", url];
    [logString appendFormat:@"\nResponseContent:\n\t%@\n\n", response];
    if (shouldLogError) {
        
        [logString appendFormat:@"Error Domain:\t\t\t\t\t\t\t%@\n", error.domain];
        [logString appendFormat:@"Error Domain Code:\t\t\t\t\t\t%ld\n", (long)error.code];
        [logString appendFormat:@"Error Localized Description:\t\t\t%@\n", error.localizedDescription];
         [SSToastHelper showToastWithStatus:error.localizedDescription];
        //        [logString appendFormat:@"Error Localized Failure Reason:\t\t\t%@\n", error.localizedFailureReason];
        //        [logString appendFormat:@"Error Localized Recovery Suggestion:\t%@\n\n", error.localizedRecoverySuggestion];
    }
    
    [logString appendFormat:@"\n============================================\tResponse End\t===========================================\n\n\n\n"];
    
    NSLog(@"%@", logString);
}




@end
