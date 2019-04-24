//
//  LPActionDefinition.m
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

//#import "LPActionDefinition.h"
//
//@implementation LPActionDefinition
//
//- (NSDictionary *) classMapping {
//    NSDictionary *mapping = @{@"alert": @"alert",
//                              };
//    return mapping;
//}
//
//- (id) initWithDictionary:(NSDictionary *)responseDict {
//    NSDictionary *mapping = [self classMapping];
//    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
//        if (mapping[key]) {
//            if ([key isEqualToString: @"alert"]) {
//                NSMutableArray *alertArr = [[NSMutableArray alloc] init];
//                for (id alertDict in responseDict[mapping[key]]) {
//                    LPAlert *alert = [[LPAlert alloc] initWithDictionary:alertDict];
//                    [alertArr addObject: alert];
//                }
//                [self setValue:alertArr forKey:mapping[key]];
//            } else {
//                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
//            }
//        }
//    }
//    return self;
//}
//
//@end
