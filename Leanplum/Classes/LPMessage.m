//
//  LPMessage.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 4/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
//  Edit by Grace on 4/20/19

#import "LPMessage.h"

@implementation LPMessage

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"id": @"id",
                              @"action": @"action",
                              @"countdown": @"countdown",
                              @"hasImpressionCriteria": @"hasImpressionCriteria",
                              @"parentCampaignId": @"parentCampaignId",
                              @"priority": @"priority",
                              @"vars": @"vars",
                              @"whenLimits": @"whenLimits",
                              @"whenTriggers": @"whenTriggers",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key] && !([key isEqualToString:@"vars"])  && !([key isEqualToString:@"whenTriggers"])
            && !([key isEqualToString:@"whenLimits"])) {
            [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
        }
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        NSDictionary *mapping = [self classMapping];
        for (id key in mapping) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:mapping[key]];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary *mapping = [self classMapping];
    for (id key in mapping) {
        [encoder encodeObject:[self valueForKey:key] forKey:mapping[key]];
    }
}

@end

