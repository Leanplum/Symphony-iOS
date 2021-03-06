//
//  LPRegisterDeviceApi.m
//  Leanplum
//
//  Created by Grace on 5/14/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRegisterDeviceApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"
#import "LPResultSuccess.h"

@implementation LPRegisterDeviceApi

+ (void) registerDeviceWithParameters:(NSDictionary *)parameters
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
        if ([parameters objectForKey:LP_PARAM_EMAIL]) {
            params[LP_PARAM_EMAIL] = parameters[LP_PARAM_EMAIL];
        }
    }
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;

    if (isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodRegisterForDevelopment
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodRegisterForDevelopment]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
