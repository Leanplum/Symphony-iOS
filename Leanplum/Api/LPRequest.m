//
//  LPRequest.m
//  Leanplum
//
//  Created by Grace on 6/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRequest.h"
#import "LPApiMethods.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPApiConstants.h"
#import "LPRequestManager.h"

@implementation LPRequest

- (instancetype)initWithApiMethod:(LPApiMethod)apiMethod
                           params:(NSDictionary *)params
                          success:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSError *error))failure {
    self = [super init];
    if (self) {
        _httpMethod = [LPApiMethods getHttpMethod:apiMethod];
        _apiMethod = apiMethod;
        _params = params;
        _successResponse = success;
        _failureResponse = failure;
        _requestId = [[NSUUID UUID] UUIDString];
    }
    return self;
}

- (NSMutableDictionary *)createArgsDictionaryForRequest
{
    LPAPIConfig *constants = [LPAPIConfig sharedConfig];
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    NSMutableDictionary *args = [@{
                                   LP_PARAM_ACTION: [LPApiMethods getApiMethod:self.apiMethod],
                                   LP_PARAM_DEVICE_ID: constants.deviceId ?: @"",
                                   LP_PARAM_USER_ID: [LPAPIConfig sharedConfig].deviceId,
                                   LP_PARAM_SDK_VERSION: [LPApiConstants sharedState].sdkVersion,
                                   LP_PARAM_CLIENT: [LPApiConstants sharedState].client,
                                   LP_PARAM_DEV_MODE: @(YES),
                                   LP_PARAM_TIME: timestamp,
                                   LP_PARAM_REQUEST_ID: self.requestId,
                                   } mutableCopy];
    if ([LPAPIConfig sharedConfig].token) {
        args[LP_PARAM_TOKEN] = [LPAPIConfig sharedConfig].token;
    }
    [args addEntriesFromDictionary:self.params];
    return args;
}

@end
