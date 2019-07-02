//
//  LPRequestManager.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRequestManager : NSObject

/**
 * Add event to database.
 */
+ (void)addRequest:(LPRequest *) request;

/**
 * Add multiple events to database.
 */
+ (void)addRequests:(NSArray<LPRequest *> *)requests;

/**
 * Fetch events with limit.
 * Usually you pass the maximum events server can handle.
 */
+ (NSArray<NSDictionary *> *)requestsWithLimit:(NSInteger)limit;

/**
 * Delete first X events using limit.
 */
+ (void)deleteRequestsWithLimit:(NSInteger)limit;

/**
 * Delete request by requestId.
 */
+ (void)deleteRequestsWithRequestId:(NSString *)requestId;

/**
 * Returns the number of total events stored.
 */
+ (NSInteger)count;

@end

NS_ASSUME_NONNULL_END
