//
//  LPPauseStateApi+Categories.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
#import "LPPauseStateApi.h"


@interface LPPauseStateApi (Categories)

+ (void)validate_onResponse:(void (^)(NSDictionary *))response;
+ (void)swizzle_methods;

@end
