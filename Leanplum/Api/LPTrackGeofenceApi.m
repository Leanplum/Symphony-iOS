//
//  LPTrackGeofenceApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPTrackGeofenceApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPTrackGeofenceApi

+ (void) trackGeofenceEvent:(LPGeofenceEventType)event
                       info:(NSString *)info
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        // TrackGeofence should not be called in background.
        if (![NSThread isMainThread]) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self trackGeofenceEvent:event info:info parameters:parameters success:success failure:failure];
            });
            return;
        }
        NSString *eventName = [self getEventNameFromGeofenceType:event];

        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        if (event) {
            params[LP_PARAM_EVENT] = eventName;
        }
        if (info) {
            params[LP_PARAM_INFO] = info;
        }
        if (parameters) {
            // TODO: recreate the below functionality
            //        params = [Leanplum validateAttributes:params named:@"params" allowLists:NO];
            params[LP_PARAM_PARAMS] = [LPJSON stringFromJSON:params];
        }
        params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;

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
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_TRACK_GEOFENCE
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

+ (NSString *) getEventNameFromGeofenceType:(LPGeofenceEventType)event {
    NSString *result = nil;

    switch(event) {
        case LPEnterRegion:
            result = @"enter_region";
            break;
        case LPExitRegion:
            result = @"exit_region";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected geofenceEventType."];
    }

    return result;
}

    
@end
