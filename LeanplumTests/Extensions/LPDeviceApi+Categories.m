//
//  LPDeviceApi+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/11/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPDeviceApi+Categories.h"
#import "LPSwizzle.h"

@implementation LPDeviceApi (Categories)

static void (^responseSuccess)(NSDictionary *);

+ (void)swizzle_methods
{
    NSError *error;
    
    bool success = [LPSwizzle swizzleClassMethod:@selector(setDeviceId:withDeviceAttributes:success:failure:isMulti:)
                             withClassMethod:@selector(swizzle_setDeviceId:withDeviceAttributes:success:failure:isMulti:)
                                       error:&error
                                       class:[LPDeviceApi class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)validate_onResponse:(void (^)(NSDictionary *))response {
    responseSuccess = response;
}

+ (void)swizzle_setDeviceId:(NSString*)service withDeviceAttributes:(NSMutableDictionary *)params success:(void (^)(NSDictionary *))success failure:(void (^)(NSError *))failure isMulti:(BOOL)isMulti {
    NSDictionary *successDict = @{@"success" : @1};
    responseSuccess(successDict);
    return [self swizzle_setDeviceId:service withDeviceAttributes:params success:success failure:failure isMulti:NO];
}

@end
