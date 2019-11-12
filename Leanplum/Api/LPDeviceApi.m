//
//  LPDeviceApi.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPDeviceApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPApiMethods.h"
#import "LPErrorHelper.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"
#import "LPResultSuccess.h"

@implementation LPDeviceApi

+ (void) setDeviceId:(NSString *)deviceId
withDeviceAttributes:(NSDictionary *)attributes
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
    if (attributes != nil) {
        params = [attributes mutableCopy];
    }
    params[LP_PARAM_DEVICE_ID] = deviceId;

    if (isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodSetDeviceAttributes
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
    
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodSetDeviceAttributes]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
