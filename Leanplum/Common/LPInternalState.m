//
//  LPInternalState.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/26/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPInternalState.h"

@implementation LPInternalState

+ (LPInternalState *)sharedState {
    static LPInternalState *sharedLPInternalState = nil;
    static dispatch_once_t onceLPInternalStateToken;
    dispatch_once(&onceLPInternalStateToken, ^{
        sharedLPInternalState = [[self alloc] init];
    });
    return sharedLPInternalState;
}

- (id)init {
    if (self = [super init]) {
        _calledStart = NO;
        _hasStarted = NO;
        _hasStartedAndRegisteredAsDeveloper = NO;
        _startSuccessful = NO;
        _startIssuedBlocks = [NSMutableArray array];
    }
    return self;
}

@end

