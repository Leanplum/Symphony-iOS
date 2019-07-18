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
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPErrorHelper.h"
#import "LPJSON.h"
#import "LPRequestQueue.h"
#import "LPApiUtils.h"

@implementation LPMarkNewsfeedMessageAsReadApi

+ (void) markNewsfeedMessageAsReadWithMessageId:(NSString *)messageId
                                     parameters:(NSDictionary *)parameters
                                        success:(void (^)(void))success
                                        failure:(void (^)(NSError *error))failure {
    void (^successResponse) (NSDictionary *) = ^(NSDictionary *response) {
        NSError *error = nil;
        NSDictionary *resultDict = [LPApiUtils responseDictionaryFromResponse:response];
        if (error != nil) {
            failure(error);
        }
        else {
            BOOL successBool = [[resultDict objectForKey:@"success"] boolValue];
            if (successBool) {
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

    if ([LPApiConstants sharedState].isMulti) {
        LPRequest *request = [[LPRequest alloc] initWithApiMethod:LPApiMethodMarkInboxMessageAsRead
                                                           params:params
                                                          success:successResponse
                                                          failure:failureResponse];
        [[LPRequestQueue sharedInstance] enqueue:request];
    } else {
        LPWSManager *wsManager = [[LPWSManager alloc] init];
        [wsManager sendPOSTWebService:[LPApiMethods getApiMethod:LPApiMethodMarkInboxMessageAsRead]
                           withParams:params
                         successBlock:successResponse
                         failureBlock:failureResponse];
    }
}

@end
