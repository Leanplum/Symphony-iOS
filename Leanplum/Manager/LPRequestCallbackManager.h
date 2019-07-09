//
//  LPRequestCallbackManager.h
//  Leanplum
//
//  Created by Grace on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPRequestCallbackManager : NSObject

+ (instancetype)sharedManager;

- (void)add:(NSString *)requestId onSuccess:(void (^)(NSDictionary *dictionary))successBlock onFailure:(void (^)(NSError *error))failureBlock;
- (void (^)(NSDictionary *dictionary))retrieveSuccessByRequestId:(NSString *)requestId;
- (void (^)(NSError *error))retrieveFailureByRequestId:(NSString *)requestId;
- (NSDictionary *)clearSuccessBlocks;
- (NSDictionary *)clearFailureBlocks;

@end

NS_ASSUME_NONNULL_END
