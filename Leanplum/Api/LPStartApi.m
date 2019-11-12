//
//  LPStartApi.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 7/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPStartApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"
#import "LPStartResponse.h"
#import "LPApiUtils.h"
#import "LPRequest.h"
#import "LPRequestQueue.h"
#import "LPResultSuccess.h"

@implementation LPStartApi

+ (void) startWithParameters:(NSDictionary *)parameters
                     success:(void (^)(LPStartResponse *))success
                     failure:(void (^)(NSError *error))failure
                     isMulti:(BOOL)isMulti {
    
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSDictionary *resultDict = [LPApiUtils responseDictionaryFromResponse:response];
        LPStartResponse *startResponse = [[LPStartResponse alloc] initWithDictionary:resultDict];
        if (error != nil) {
            failure(error);
        }
        else {
            BOOL successBool = [LPResultSuccess checkSuccess:resultDict];
            if (successBool) {
                success(startResponse);
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
    
    if (isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodStart
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodStart]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
    
}
@end
