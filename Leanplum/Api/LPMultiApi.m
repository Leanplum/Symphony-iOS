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
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"
#import "NSString+NSString_Extended.h"

@implementation LPMultiApi

+ (void) multiWithData:(NSArray *)data
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSArray *responseArray = [response valueForKey:@"response"];
        if (error != nil) {
            failure(error);
        }
        else {
            success(responseArray);
        }
    };
    void (^failureResponse) (NSError *) = ^(NSError *error ){
        failure(error);
    };

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (data) {
        params[LP_PARAM_DATA] = [[LPJSON stringFromJSON:@{LP_PARAM_DATA:data}] urlencode];
    }
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodMulti]
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
