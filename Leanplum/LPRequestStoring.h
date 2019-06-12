//
//  LPRequestStoring.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 6/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#ifndef LPRequestStoring_h
#define LPRequestStoring_h

@protocol LPRequestStoring <NSObject>

+ (void)addRequestWithId:(NSString *)requestId
                apiMethod:(NSString *)apiMethod
                   params:(NSDictionary *)params
                     sent:(BOOL)sent;

+ (NSDictionary *)requestWithId:(NSString *)requestId;

+ (NSArray<NSDictionary *> *)requestsWithLimit:(NSInteger)limit;

+ (void)updateRequestWithId:(NSString *)requestId
                  apiMethod:(NSString *)apiMethod
                     params:(NSDictionary *)params
                       sent:(BOOL)sent;

+ (void)deleteRequestWithId:(NSString *)requestId;

+ (void)deleteRequestsWithLimit:(NSInteger)limit;

+ (NSInteger)count;

@end

#endif /* LPRequestStoring_h */
