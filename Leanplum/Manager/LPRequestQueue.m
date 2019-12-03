//
//  LPRequestQueue.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRequestQueue.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPRequestManager.h"
#import "LPRequestCallbackManager.h"
#import "LPMultiApi.h"

@interface LPRequestQueue()

@property (nonatomic, strong) LPRequestCallbackManager *callbackManager;

@end

@implementation LPRequestQueue

+ (instancetype)sharedInstance {
    static LPRequestQueue *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (instancetype)init {
    if (self = [super init]) {
        _callbackManager = [LPRequestCallbackManager sharedManager];
    }
    return self;
}

- (void)enqueue:(LPRequest *)request {
    @synchronized (self) {
        LP_TRY
        [LPRequestManager addRequest:request];
        [self.callbackManager add:request.requestId
                        onSuccess:request.successResponse
                        onFailure:request.failureResponse];
        LP_END_TRY
    }
}

- (void)sendRequests:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    //get current count of requests
    NSInteger totalRequestCount = [LPRequestManager count];
    if (totalRequestCount == 0) {
        return;
    }
    //Todo: currently send all requests.
    NSArray *requests = [LPRequestManager requestsWithLimit:MAX_EVENTS_PER_API_CALL];

    [LPMultiApi multiWithData:requests success:^(NSArray *results) {
        for (NSDictionary *result in results) {
            NSString *reqId = result[LP_PARAM_REQUEST_ID];
            if ([result[@"success"] boolValue]
                && !result[@"error"]) {
                [LPRequestManager deleteRequestsWithRequestId:reqId];
                
                void (^successCallback)(NSDictionary *dictionary) = [[LPRequestCallbackManager sharedManager] retrieveSuccessByRequestId:reqId];
                if (successCallback) {
                    successCallback(result);
                }
            } else {
                void (^failureCallback)(NSError *error) = [[LPRequestCallbackManager sharedManager] retrieveFailureByRequestId:reqId];
                LP_TRY
                if (failureCallback) {
                    // TODO: figure out correct NSError to run
                    NSString *errorMessage = @"Uknown error";
                    if (result[@"error"][@"message"]) {
                        errorMessage = result[@"error"][@"message"];
                    }
                    NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:500 userInfo:errorMessage];
                    failureCallback(error);
                }
                LP_END_TRY
            }
        }

        if (totalRequestCount >= requests.count) {
            [[LPRequestQueue sharedInstance] sendRequests:^{
                NSLog(@"LPRequestQueue successfully processed");
            } failure:^(NSError * _Nonnull error) {
                NSLog(@"LPRequestQueue failure %@", error);
            }];
        }
        if (success) {
            success();
        }
    } failure:^(NSError *error) {
        NSLog(@"Todo multi failure %@", error);
        if (failure) {
            failure(error);
        }
    }];
}

@end
