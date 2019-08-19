//
//  LPAlertValues.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAlertValues.h"
#import "LPValuesDismissAction.h"

@implementation LPAlertValues

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"dismissAction": @"dismissAction",
                              @"dismissText": @"dismissText",
                              @"message": @"message",
                              @"title": @"title",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key]) {
            if ([key isEqualToString: @"dismissAction"]) {
                LPValuesDismissAction *valuesDismissAction = [[LPValuesDismissAction alloc] initWithDictionary:responseDict[key]];
                [self setValue:valuesDismissAction forKey:mapping[key]];
            } else {
                NSLog(@"key is %@", key);
                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
            }
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
