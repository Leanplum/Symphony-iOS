//
//  LPUserApi.m
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
#import "LPUserApi.h"
#import "LPWSManager.h"
#import "LPApiConstants.h"

@implementation LPUserApi

+ (void) setUsersAttributes:(NSString *)userId withUserAttributes:(NSDictionary *)attributes
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSArray *responseArray = [response valueForKey:@"response"];
        NSDictionary *resultDict = responseArray[0];
        NSLog(@"responseDict %@",resultDict);
        if (error != nil) {
            failure(error);
        }
        else {
            if ([resultDict objectForKey:@"success"]) {
                success();
            } else {
                error = [[NSError alloc] initWithDomain:@"com.leanplumsdk" code:200 userInfo:@{@"Error reason": @"Invalid Input"}];
                failure(error);
            }
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                                  userParams:nil successBlock:successResponse failureBlock:failureResponse];
    
}

+ (void) getUsersAttributes:(NSString *)userId withUserAttributes:(NSDictionary *)attributes
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure {
    
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSArray *responseArray = [response valueForKey:@"response"];
        NSDictionary *resultDict = responseArray[0];
        NSLog(@"responseDict %@",resultDict);
        if (error != nil) {
            failure(error);
        }
        else {
            if ([resultDict objectForKey:@"success"]) {
                success();
            } else {
                error = [[NSError alloc] initWithDomain:@"com.leanplumsdk" code:200 userInfo:@{@"Error reason": @"Invalid Input"}];
                failure(error);
            }
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendGETWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                       userParams:nil successBlock:successResponse failureBlock:failureResponse];
    
}

@end
