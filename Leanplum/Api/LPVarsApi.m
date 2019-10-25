//
//  LPSetVarsApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPVarsApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"
#import "LPResultSuccess.h"

@implementation LPVarsApi

+ (void) setVarsWithVars:(NSDictionary *)vars
                 success:(void (^)(void))success
                 failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSDictionary *resultDict = [LPApiUtils responseDictionaryFromResponse:response];
        if (error != nil) {
            failure(error);
        }
        else {
            BOOL successBool = [LPResultSuccess checkSuccess:resultDict];
            if (successBool) {
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
    if ([LPAPIConfig sharedConfig].deviceId && ![[LPAPIConfig sharedConfig].deviceId isEqualToString:@""]) {
        params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    }

    if ([LPApiConstants sharedState].isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetVars
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodSetVars]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
