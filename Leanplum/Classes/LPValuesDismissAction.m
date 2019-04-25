//
//  LPValuesDismissAction.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPValuesDismissAction.h"

@implementation LPValuesDismissAction

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"name": @"name",
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
