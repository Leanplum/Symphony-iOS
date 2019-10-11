//
//  LPDeviceApi+Categories.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPDeviceApi.h"

@interface LPDeviceApi (Categories)

+ (void)validate_onResponse:(void (^)(NSDictionary *))response;
+ (void)swizzle_methods;

@end
