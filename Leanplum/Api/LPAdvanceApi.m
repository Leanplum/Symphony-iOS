//
//  LPAdvanceApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAdvanceApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPAdvanceApi

+ (void) advanceToState:(NSString *)state
         withParameters:(NSDictionary *)parameters
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
            if ([resultDict objectForKey:@"success"]) {
                success();
            } else {
                NSError *error = [LPErrorHelper makeResponseError:resultDict];
                failure(error);
            }
        }
    };
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (parameters != nil) {
        params = [parameters mutableCopy];
    }
    params[LP_PARAM_STATE] = state ? state : @"";
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodAdvance]
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end