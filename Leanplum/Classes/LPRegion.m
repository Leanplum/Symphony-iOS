//
//  LPRegions.m
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRegion.h"

@implementation LPRegion

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"name": @"name",
                              @"lon": @"lon",
                              @"lat": @"lat",
                              @"radius": @"radius",
                              @"version": @"version",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key]) {
            [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
        }
    }
    return self;
}

@end
