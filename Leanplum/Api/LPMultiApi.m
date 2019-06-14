//
//  LPMultiApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPMultiApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPMultiApi

+ (void) multiWithData:(NSArray *)data
            parameters:(NSDictionary *)parameters
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
    // TODO: check why double dictionary here
    if (data) {
        params[LP_PARAM_DATA] = [LPJSON stringFromJSON:@{LP_PARAM_DATA:data}];
    }
    params[LP_PARAM_SDK_VERSION] = [LPApiConstants sharedState].sdkVersion;
    params[LP_PARAM_CLIENT] =  [LPApiConstants sharedState].client;
    params[LP_PARAM_TIME] =  [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];

    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_MULTI
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
