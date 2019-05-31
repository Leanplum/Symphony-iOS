//
//  LPMarkNewsfeedMessageAsReadApi.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPMarkNewsfeedMessageAsReadApi.h"
#import "LPWSManager.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"

@implementation LPMarkNewsfeedMessageAsReadApi

+ (void) markNewsfeedMessageAsReadWithMessageId:(NSString *)messageId
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
    params[LP_PARAM_DEVICE_ID] = [LPAPIConfig sharedConfig].deviceId;
    params[LP_PARAM_INBOX_MESSAGE_ID] = messageId;
    LPWSManager *wsManager = [[LPWSManager alloc] init];
    [wsManager sendPOSTWebService:LP_API_METHOD_MARK_INBOX_MESSAGE_AS_READ
                       withParams:params
                     successBlock:successResponse
                     failureBlock:failureResponse];
}

@end
