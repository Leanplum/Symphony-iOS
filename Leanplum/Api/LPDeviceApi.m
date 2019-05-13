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
#import "LPErrorHelper.h"

#import <objc/runtime.h>
#import <objc/message.h>

@implementation LPDeviceApi

+ (void) setDeviceAttributes:(NSString *)deviceId withAttributes:(NSDictionary *)attributes 
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
    NSMutableDictionary *params = [attributes mutableCopy];
    
                                  
                

    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_SET_DEVICE_ATTRIBUTES
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
    
}

@end
