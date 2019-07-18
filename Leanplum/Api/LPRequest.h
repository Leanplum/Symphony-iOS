//
//  LPRequest.h
//  Leanplum
//
//  Created by Grace on 6/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPApiMethods.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRequest : NSObject

@property (nonatomic, strong) NSString *requestId;
@property (nonatomic, strong) NSString *httpMethod;
@property (nonatomic, assign) LPApiMethod apiMethod;
@property (nonatomic, strong, nullable) NSDictionary *params;
@property (atomic) BOOL sent;
@property (nonatomic, copy, nullable) void (^successResponse) (NSDictionary *);
@property (nonatomic, copy, nullable) void (^failureResponse) (NSError *);

- (instancetype)initWithApiMethod:(LPApiMethod)apiMethod
                           params:(nullable NSDictionary *)params
                          success:(void (^)(NSDictionary *dictionary))success
                          failure:(void (^)(NSError *error))failure;

- (NSMutableDictionary *)createArgsDictionaryForRequest;

@end

NS_ASSUME_NONNULL_END
