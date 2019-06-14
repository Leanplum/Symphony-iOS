//
//  LPTrack.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPTrackApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPTrackApi

+ (void) trackWithEvent:(NSString *)event
                  value:(double)value
                   info:(NSString *)info
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
    if (value) {
        params[LP_PARAM_VALUE] = [NSString stringWithFormat:@"%f", value];;
    }
    if (event) {
        params[LP_PARAM_EVENT] = event;
    }
    if (info) {
        params[LP_PARAM_INFO] = info;
    }
    if (parameters) {
        params[LP_PARAM_PARAMS] = [LPJSON stringFromJSON:params];
    }
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_TRACK
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
