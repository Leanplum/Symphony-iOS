//
//  LPRequestQueue.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRequestQueue : NSObject

+ (instancetype)sharedInstance;

- (void)enqueue:(LPRequest *)request;

- (void)sendRequests:(void(^)(void))success failure:(void(^)(NSError *error))failure;

@end

NS_ASSUME_NONNULL_END
