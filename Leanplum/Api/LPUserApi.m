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
        NSArray *responseArray = [response valueForKey:@"response"];
        NSDictionary *resultDict = responseArray[0];
        NSLog(@"responseDict %@",resultDict);
        if (error != nil) {
            failure(error);
        }
        else {
            success(resultDict[@"success"]);
        }
    };
    
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };
    
    
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_USER_ATTRIBUTES
                                  userParams:nil successBlock:successResponse failureBlock:failureResponse];
    
}

@end
