//
//  LPResponse.m
//  Leanplum
//
//  Created by Grace Gu on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPStartResponse.h"
#import "LPRegion.h"
#import "LPMessage.h"
#import "LPFileAttribute.h"

@implementation LPStartResponse

- (NSDictionary *) classMapping {
    NSDictionary *mapping = @{@"success": @"success",
                              @"syncNewsfeed": @"syncNewsfeed",
                              @"token": @"token",
                              @"regions": @"regions",
                              @"messages": @"messages",
                              @"fileAttributes": @"fileAttributes",
                              };
    return mapping;
}

- (id) initWithDictionary:(NSDictionary *)responseDict {
    NSDictionary *mapping = [self classMapping];
    for (id key in (responseDict[@"response"] ? responseDict[@"response"] : responseDict)) {
        if (mapping[key]) {
            if ([key isEqualToString: @"regions"]) {
                NSMutableArray *regionArr = [[NSMutableArray alloc] init];
                for (id regionDict in responseDict[mapping[key]]) {
                    LPRegion *region = [[LPRegion alloc] initWithDictionary:regionDict];
                    [regionArr addObject: region];
                }
                [self setValue:regionArr forKey:mapping[key]];
            } else if ([key isEqualToString: @"messages"]) {
                NSMutableArray *messageArr = [[NSMutableArray alloc] init];
                for (id messageDict in responseDict[mapping[key]]) {
                    LPMessage *message = [[LPMessage alloc] initWithDictionary:messageDict];
                    [messageArr addObject: message];
                }
                [self setValue:messageArr forKey:mapping[key]];
            } else if ([key isEqualToString: @"fileAttributes"]) {
                NSMutableArray *fileAttributeArr = [[NSMutableArray alloc] init];
                for (id fileAttributeDict in responseDict[mapping[key]]) {
                    LPFileAttribute *fileAttribute = [[LPFileAttribute alloc] initWithDictionary:fileAttributeDict];
                    [fileAttributeArr addObject: fileAttribute];
                }
                [self setValue:fileAttributeArr forKey:mapping[key]];
            } else {
                [self setValue:[responseDict objectForKey:key] forKey:mapping[key]];
            }
        }
    }
    return self;
}

@end