//
//  LPAlert.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAlert.h"
#import "LPAlertKinds.h"
#import "LPAlertValues.h"

@implementation LPAlert

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"kind": @"kind",
                              @"kinds": @"kinds",
                              @"options": @"options",
                              @"values": @"values",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key]) {
            if ([key isEqualToString: @"kinds"]) {
                LPAlertKinds *alertKinds = [[LPAlertKinds alloc] initWithDictionary:responseDict[key]];
                [self setValue:alertKinds forKey:mapping[key]];
            } else if ([key isEqualToString: @"values"]) {
                LPAlertValues *alertValues = [[LPAlertValues alloc] initWithDictionary:responseDict[key]];
                [self setValue:alertValues forKey:mapping[key]];
            } else {
                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
            }
        }
    }
    return self;
}

@end
