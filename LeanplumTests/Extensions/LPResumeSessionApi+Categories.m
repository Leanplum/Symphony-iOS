//
//  LPResumeSessionApi+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPResumeSessionApi+Categories.h"
#import "LPSwizzle.h"

@implementation LPResumeSessionApi (Categories)

static void (^responseSuccess)(NSDictionary *);

+ (void)swizzle_methods
{
    NSError *error;

    bool success = [LPSwizzle swizzleClassMethod:@selector(resumeSessionWithParameters:success:failure:isMulti:)
                             withClassMethod:@selector(swizzle_resumeSessionWithParameters:success:failure:isMulti:)
                                       error:&error
                                       class:[LPResumeSessionApi class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)validate_onResponse:(void (^)(NSDictionary *))response {
    responseSuccess = response;
}

+ (void)swizzle_resumeSessionWithParameters:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure isMulti:(BOOL)isMulti{
    NSDictionary *successDict = @{@"success" : @1};
    responseSuccess(successDict);
    return [self swizzle_resumeSessionWithParameters:params success:success failure:failure isMulti:NO];
}

@end
