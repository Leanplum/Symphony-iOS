//
//  LPWSManager+Categories.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//


#import "LPWSManager.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPWSManager (Categories)

+ (void)validate_onResponse:(void (^)(NSDictionary *))response;
+ (void)swizzle_methods;

@end

NS_ASSUME_NONNULL_END
