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
    NSDictionary *parsedResponseDictionary = response;
    NSArray *responseArray = [response valueForKey:@"response"];
    if (responseArray) {
        parsedResponseDictionary = [responseArray firstObject];
    }
    return parsedResponseDictionary;
}

@end
