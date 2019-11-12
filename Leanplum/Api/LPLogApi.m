//
//  LPLogApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPLogApi.h"
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

@implementation LPLogApi

+ (void) logWithMessage:(NSString *)message
             parameters:(NSDictionary *)parameters
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure
                isMulti:(BOOL)isMulti {
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
    if (parameters != nil) {
        params = [parameters mutableCopy];
    }
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    params[LP_PARAM_TYPE] = LP_VALUE_SDK_LOG;
    params[LP_PARAM_MESSAGE] = message;

    if (isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodLog
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodLog]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
