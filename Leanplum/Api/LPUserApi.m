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
#import "LPApiMethods.h"
#import "LPErrorHelper.h"
#import "LPAPIConfig.h"
#import "LPJSON.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"
#import "LPResultSuccess.h"

@implementation LPUserApi

+ (void) setUserId:(NSString *)userId
withUserAttributes:(NSDictionary *)attributes
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        //ToDo: Use the data
        NSDictionary *resultDict = [LPApiUtils responseDictionaryFromResponse:response];
        BOOL successBool = [LPResultSuccess checkSuccess:resultDict];
        
        if (successBool) {
            success();
        } else {
            NSError *error = [LPErrorHelper makeResponseError:resultDict];
            failure(error);
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

    if ([LPApiConstants sharedState].isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetUserAttributes
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodSetUserAttributes]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}


@end
