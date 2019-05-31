//
//  LPUserApi.m
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
#import "LPUserApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPErrorHelper.h"
#import "LPAPIConfig.h"
#import "LPJSON.h"

@implementation LPUserApi

+ (void) setUserId:(NSString *)userId
withUserAttributes:(NSDictionary *)attributes
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSArray *responseArray = [response valueForKey:@"response"];
        NSDictionary *resultDict = responseArray[0];
        if (error != nil) {
            failure(error);
        }
        else {
            BOOL successBool = [[resultDict objectForKey:@"success"] boolValue];
            if (successBool) {
                success();
            } else {
                NSError *error = [LPErrorHelper makeResponseError:resultDict];
                failure(error);
            }
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ) {
        failure(error);
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[LP_PARAM_USER_ID] = userId;
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    
    if (attributes != nil) {
        params[LP_PARAM_USER_ATTRIBUTES] =  [LPJSON stringFromJSON:attributes];
    }
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}


@end
