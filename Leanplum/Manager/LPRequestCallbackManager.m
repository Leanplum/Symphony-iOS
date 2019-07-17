//
//  LPRequestCallbackManager.m
//  Leanplum
//
//  Created by Grace on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRequestCallbackManager.h"

@interface LPRequestCallbackManager()

@property (nonatomic, copy) NSMutableDictionary *successBlocks;
@property (nonatomic, copy) NSMutableDictionary *failureBlocks;

@end

@implementation LPRequestCallbackManager

+ (instancetype)sharedManager {
    static LPRequestCallbackManager *sharedLPRequestCallbackManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedLPRequestCallbackManager = [[self alloc] init];
    });
    return sharedLPRequestCallbackManager;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _successBlocks = [NSMutableDictionary new];
        _failureBlocks = [NSMutableDictionary new];
    }
    return self;
}

- (void)add:(NSString *)requestId onSuccess:(void (^)(NSDictionary *dictionary))successBlock onFailure:(void (^)(NSError *error))failureBlock {
        self.successBlocks[requestId] = successBlock;
        self.failureBlocks[requestId] = failureBlock;
}

- (void (^)(NSDictionary *dictionary))retrieveSuccessByRequestId:(NSString *)requestId {
    void (^successCallback) (NSDictionary *) = self.successBlocks[requestId];
    if (successCallback) {
        [self removeCallbackByRequestId:requestId];
    }
    return successCallback;
}

- (void (^)(NSError *error))retrieveFailureByRequestId:(NSString *)requestId {
    void (^failureCallback) (NSError *) = self.failureBlocks[requestId];
    if (failureCallback) {
        [self removeCallbackByRequestId:requestId];
    }
    return failureCallback;
}

- (void)removeCallbackByRequestId:(NSString *)requestId {
    [self.successBlocks removeObjectForKey:requestId];
    [self.failureBlocks removeObjectForKey:requestId];
}

- (NSDictionary *)clearSuccessBlocks {
    NSDictionary *successCallbacks = self.successBlocks;
    self.successBlocks = [NSMutableDictionary new];
    return successCallbacks;
}

- (NSDictionary *)clearFailureBlocks {
    NSDictionary *failureCallbacks = self.failureBlocks;
    self.failureBlocks = [NSMutableDictionary new];
    return failureCallbacks;
}

@end
