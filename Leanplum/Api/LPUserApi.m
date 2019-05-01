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
                    success:(void (^)(NSString* httpCode))success
                    failure:(void (^)(NSError *error))failure {
    
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSData *data_response = response[@"response"];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data_response options:0 error:&error];
        NSLog(@"responseDict %@",responseDict);
        if (error != nil) {
            failure(error);
        }
        else {
            success(nil);
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                                  userParams:nil successBlock:successResponse failureBlock:failureResponse];
    
}

//ToDo: Later
/*
+ (void) getUsersAttributes:(LPUser *)user
                    success:(void (^)(LPUser *))success
                    failure:(void (^)(NSError *error))failure
{
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSData *data_response = response[@"response"];
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:data_response options:0 error:&error];
        NSLog(@"responseDict %@",responseDict);
        if (error != nil) {
            failure(error);
        }
        else {
            LPUser *valueObject = [[LPUser alloc] initWithDictionary:responseDict];
            success(valueObject);
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    LPWSManager *wsManager = [[KWWSManager alloc] init];
    [wsManager sendAsynchronousGETWebService:@"/rest/users/me"
                                  userParams:nil successBlock:successResponse failureBlock:failureResponse];
}*/
@end
