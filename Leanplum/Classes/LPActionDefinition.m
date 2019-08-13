//
//  LPActionDefinition.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPActionDefinition.h"
#import "LPAlert.h"

@implementation LPActionDefinition

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"alert": @"alert",
                              };
    [super initWithMapping:mapping];
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key]) {
            if ([key isEqualToString: @"alert"]) {
                LPAlert *alert = [[LPAlert alloc] initWithDictionary:responseDict[key]];
                [self setValue:alert forKey:mapping[key]];
            } else {
                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
            }
        }
    }
    return self;
}

@end
