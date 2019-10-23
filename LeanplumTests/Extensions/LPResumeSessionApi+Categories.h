//
//  LPResumeSessionApi+Categories.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
#import "LPResumeSessionApi.h"


@interface LPResumeSessionApi (Categories)

+ (void)validate_onResponse:(void (^)(NSDictionary *))response;
+ (void)swizzle_methods;

@end

