//
//  LPSample.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPSample.h"

@implementation LPSample

- (NSDictionary *) getClasMapping {
    NSDictionary *mapping = @{@"id": @"sampleId",
                              @"title": @"title",
                              @"viewCount": @"viewCount",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self getClasMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
            if (mapping[key]) {
                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
            }
        }
    return self;
}


@end
