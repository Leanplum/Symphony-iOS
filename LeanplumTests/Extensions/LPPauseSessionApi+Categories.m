//
//  LPPauseSessionApi+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPPauseSessionApi+Categories.h"
#import "LPSwizzle.h"

@implementation LPPauseSessionApi (Categories)

static void (^responseSuccess)(NSDictionary *);

+ (void)swizzle_methods
{
    NSError *error;
    
    bool success = [LPSwizzle swizzleClassMethod:@selector(pauseSessionWithParameters:success:failure:isMulti:)
                                 withClassMethod:@selector(swizzle_pauseSessionWithParameters:success:failure:isMulti:)
                                       error:&error
                                       class:[LPPauseSessionApi class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)validate_onResponse:(void (^)(NSDictionary *))response {
    responseSuccess = response;
}

+ (void)swizzle_pauseSessionWithParameters:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure isMulti:(_Bool)isMulti {    NSDictionary *successDict = @{@"success" : @1};
    responseSuccess(successDict);
    return [self swizzle_pauseSessionWithParameters:params success:success failure:failure isMulti:NO];
}

@end
