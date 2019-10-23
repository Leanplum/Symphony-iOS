//
//  LPResumeStateApi+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPResumeStateApi+Categories.h"
#import "LPSwizzle.h"


@implementation LPResumeStateApi (Categories)

static void (^responseSuccess)(NSDictionary *);

+ (void)swizzle_methods
{
    NSError *error;
    
    bool success = [LPSwizzle swizzleClassMethod:@selector(resumeStateWithParameters:success:failure:)
                             withClassMethod:@selector(swizzle_resumeStateWithParameters:success:failure:)
                                       error:&error
                                       class:[LPResumeStateApi class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)validate_onResponse:(void (^)(NSDictionary *))response {
    responseSuccess = response;
}

+ (void)swizzle_resumeStateWithParameters:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure {
    NSDictionary *successDict = @{@"success" : @1};
    responseSuccess(successDict);
    return [self swizzle_resumeStateWithParameters:params success:success failure:failure];
}

@end
