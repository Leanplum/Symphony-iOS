//
//  LPSetTrafficSourceInfoApi.m
//  Leanplum
//
//  Created by Grace on 5/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPSetTrafficSourceInfoApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"
#import "LPResultSuccess.h"

@implementation LPSetTrafficSourceInfoApi

+ (void) setTrafficSourceInfoWithInfo:(NSDictionary *)info
                       withParameters:(NSDictionary *)parameters
                              success:(void (^)(void))success
                              failure:(void (^)(NSError *error))failure
                              isMulti:(BOOL)isMulti{
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        
        NSDictionary *resultDict = [LPApiUtils responseDictionaryFromResponse:response];
        BOOL successBool = [LPResultSuccess checkSuccess:resultDict];
        if (successBool) {
            success();
        } else {
            NSError *error = [LPErrorHelper makeResponseError:resultDict];
            failure(error);
        }
    };
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (parameters != nil) {
        params = [parameters mutableCopy];
    }
    params[LP_PARAM_TRAFFIC_SOURCE] = info;
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;

    if (isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetTrafficSourceInfo
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodSetTrafficSourceInfo]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
