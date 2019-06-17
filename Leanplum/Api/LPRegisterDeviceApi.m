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

@implementation LPRegisterDeviceApi

+ (void) registerDeviceWithParameters:(NSDictionary *)parameters
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
        if ([parameters objectForKey:LP_PARAM_EMAIL]) {
            params[LP_PARAM_EMAIL] = parameters[LP_PARAM_EMAIL];
        }
    }
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodRegisterForDevelopment]
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
