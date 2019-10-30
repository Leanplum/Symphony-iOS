//
//  LPResumeStateApi+Categories.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/22/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPResumeStateApi.h"


@interface LPResumeStateApi (Categories)

+ (void)validate_onResponse:(void (^)(NSDictionary *))response;
+ (void)swizzle_methods;

@end

