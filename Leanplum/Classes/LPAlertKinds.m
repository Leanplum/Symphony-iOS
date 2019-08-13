//
//  LPAlertKinds.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAlertKinds.h"

@implementation LPAlertKinds

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"dismissAction": @"dismissAction",
                              @"dismissText": @"dismissText",
                              @"message": @"message",
                              @"title": @"title",
                              };
    [super initWithMapping:mapping];
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
