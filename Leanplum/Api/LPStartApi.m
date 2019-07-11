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


@implementation LPStartApi

+ (void) startWithParameters:(NSDictionary *)parameters
                     success:(void (^)(LPStartResponse *))success
                     failure:(void (^)(NSError *error))failure {
    
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSArray *responseArray = [response valueForKey:@"response"];
        NSDictionary *resultDict = responseArray[0];
        LPStartResponse *startResponse = [[LPStartResponse alloc] initWithDictionary:resultDict];
        if (error != nil) {
            failure(error);
        }
        else {
            BOOL successBool = [[resultDict objectForKey:@"success"] boolValue];
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
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodStart]
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
    
}
@end
