//
//  LPPauseStateApi+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPPauseStateApi+Categories.h"
#import "LPSwizzle.h"

@implementation LPPauseStateApi (Categories)

static void (^responseSuccess)(NSDictionary *);

+ (void)swizzle_methods
{
    NSError *error;
    
    bool success = [LPSwizzle swizzleClassMethod:@selector(pauseStateWithParameters:success:failure:isMulti:)
                             withClassMethod:@selector(swizzle_pauseStateWithParameters:success:failure:isMulti:)
                                       error:&error
                                       class:[LPPauseStateApi class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)validate_onResponse:(void (^)(NSDictionary *))response {
    responseSuccess = response;
}

+ (void)swizzle_pauseStateWithParameters:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure isMulti:(BOOL)isMulti{
    NSDictionary *successDict = @{@"success" : @1};
    responseSuccess(successDict);
    return [self swizzle_pauseStateWithParameters:params success:success failure:failure isMulti:NO];
}

@end
