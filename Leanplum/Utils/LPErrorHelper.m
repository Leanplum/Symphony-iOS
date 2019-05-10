//
//  LPErrorHelper.m
//  Leanplum
//
//  Created by Grace on 5/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPErrorHelper.h"
#import "LPApiConstants.h"

@implementation LPErrorHelper

+ (NSDictionary *)makeUserInfoDict:(NSDictionary *)responseDict {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    NSString *message = responseDict[@"message"];
    [userInfo setValue:message forKey:NSLocalizedDescriptionKey];
    return userInfo;
}

+ (NSError *)makeHttpError:(long)errorCode withDict:(NSDictionary *)responseDict {
    NSDictionary *userInfo = [self makeUserInfoDict:responseDict];
    return [NSError errorWithDomain:NSURLErrorDomain code:errorCode userInfo:userInfo];
}

+ (NSError *)makeResponseError:(NSDictionary *)responseDict {
    LPApiConstants *lpApiConstants = LPApiConstants.sharedState;
    NSDictionary *userInfo = [self makeUserInfoDict:responseDict];
    return [NSError errorWithDomain:lpApiConstants.apiHostName code:200 userInfo:userInfo];
}

@end
