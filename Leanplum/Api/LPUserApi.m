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
#import "LPErrorHelper.h"

@implementation LPUserApi

+ (void) setUserAttributes:(NSString *)userId withUserAttributes:(NSDictionary *)attributes
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
    params[LP_PARAM_USER_ID] = userId;
    if (attributes != nil) {
        params[LP_PARAM_USER_ATTRIBUTES] = attributes;
    }
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                       withParams:nil
                     successBlock:successResponse
                     failureBlock:failureResponse];
}


@end
