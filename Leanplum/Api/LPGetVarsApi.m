//
//  LPGetVarsApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPGetVarsApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPGetVarsApi

+ (void) getVarsWithParameters:(NSDictionary *)parameters
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
    params[LP_PARAM_INCLUDE_DEFAULTS] = @(NO);
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    //TODO: what to do about below params
    //    params[LP_PARAM_INBOX_MESSAGES] = [[self inbox] messagesIds];
    //    if ([LPInternalState sharedState].isVariantDebugInfoEnabled) {
    //        params[LP_PARAM_INCLUDE_VARIANT_DEBUG_INFO] = @(YES);
    //    }

    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_GET_VARS
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
