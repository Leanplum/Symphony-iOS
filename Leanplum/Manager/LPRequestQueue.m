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
#import "LPMultiApi.h"

@implementation LPRequestQueue

+ (instancetype)sharedInstance {
    static LPRequestQueue *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void)enqueue:(LPRequest *)request {
    @synchronized (self) {
        [LPRequestManager addRequest:request];
        
        //Add callback code here.
    }
}

- (void)sendRequests:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    //get current count of requests
    NSInteger maxCount = [LPRequestManager count];
    //Todo: currently send all requests.
    NSArray *requests = [LPRequestManager requestsWithLimit:maxCount];
    [LPMultiApi multiWithData:requests success:^{
        [LPRequestManager deleteRequestsWithLimit:maxCount];
        success();
    } failure:^(NSError *error) {
        NSLog(@"Todo multi failure %@", error);
        failure(error);
    }];

}

@end
