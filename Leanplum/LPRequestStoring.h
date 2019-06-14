//
//  LPRequestStoring.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 6/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#ifndef LPRequestStoring_h
#define LPRequestStoring_h

@class LPRequest;

@protocol LPRequestStoring <NSObject>

- (void)addRequest:(LPRequest *)request;

- (void)addRequests:(NSArray<LPRequest *> *)requests;

- (LPRequest *)requestWithId:(NSString *)requestId;

- (NSArray<LPRequest *> *)requestsWithLimit:(NSInteger)limit;

- (void)updateRequest:(LPRequest *)request;

- (void)deleteRequestWithId:(NSString *)requestId;

- (void)deleteRequestsWithLimit:(NSInteger)limit;

- (NSInteger)count;

@end

#endif /* LPRequestStoring_h */
