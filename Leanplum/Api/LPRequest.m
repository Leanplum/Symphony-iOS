//
//  LPRequest.m
//  Leanplum
//
//  Created by Grace on 6/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRequest.h"
#import "LPApiMethods.h"

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

@end
