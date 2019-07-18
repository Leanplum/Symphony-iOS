//
//  LPApiUtils.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 7/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPApiUtils.h"

@implementation LPApiUtils

+(NSDictionary *)responseDictionaryFromResponse:(NSDictionary *)response {
    if ([self containsArrayOfResponses:response]) {
        return [[response valueForKey:@"response"] firstObject];
    }
    return response;
}

+(BOOL)containsArrayOfResponses:(NSDictionary *)response {
    return [response valueForKey:@"response"];
}

@end
