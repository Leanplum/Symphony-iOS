//
//  LPWSManager+Categories.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 10/9/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPWSManager+Categories.h"
#import "LPSwizzle.h"


@implementation LPWSManager (MethodSwizzling)

+ (void)swizzle_methods
{
    NSError *error;
    
    bool success = [LPSwizzle swizzleClassMethod:@selector(sendGETWebService:withParams:successBlock:failureBlock:)
                             withClassMethod:@selector(swizzle_sendGETWebService:withParams:successBlock:failureBlock:)
                                       error:&error
                                       class:[LPWSManager class]];
    success &= [LPSwizzle swizzleClassMethod:@selector(sendPOSTWebService:withParams:successBlock:failureBlock:)
                             withClassMethod:@selector(swizzle_sendPOSTWebService:withParams:successBlock:failureBlock:)
                                       error:&error
                                       class:[LPWSManager class]];
    if (!success || error) {
        NSLog(@"Failed swizzling methods for LeanplumRequest: %@", error);
    }
}

+ (void)swizzle_sendGETWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSDictionary *successDict = @{@"success" : @1};
    success(successDict);
    return [self swizzle_sendGETWebService:service withParams:params successBlock:success failureBlock:failure];
}

+ (void)swizzle_sendPOSTWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSDictionary *successDict = @{@"success" : @1};
    success(successDict);
    return [self swizzle_sendPOSTWebService:service withParams:params successBlock:success failureBlock:failure];
}



@end
