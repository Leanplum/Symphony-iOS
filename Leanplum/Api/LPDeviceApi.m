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
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"

@implementation LPDeviceApi

+ (void) setDeviceAttributes:(NSString *)deviceId withDeviceAttributes:(NSDictionary *)attributes
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
                NSError *error = [LPErrorHelper makeResponseError:@{@"message": @"Invalid Input"}];
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

    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_DEVICE_ATTRIBUTES
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

+ (void) registerDevice:(NSDictionary *)attributes
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
                NSError *error = [LPErrorHelper makeResponseError:@{@"message": @"Invalid Input"}];
                failure(error);
            }
        }
    };
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (attributes != nil) {
        if ([attributes objectForKey:LP_PARAM_EMAIL]) {
            params[LP_PARAM_EMAIL] = attributes[LP_PARAM_EMAIL];
        }
    }
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_REGISTER_FOR_DEVELOPMENT
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
