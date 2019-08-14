//
//  LPModel.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/12/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPModel.h"

@implementation LPModel

- (void) initWithMapping:(NSDictionary *)classMapping {
    self.classLevelMapping = classMapping;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        NSDictionary *mapping = self.classLevelMapping;
        for (id key in mapping) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:mapping[key]];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary *mapping = self.classLevelMapping;
    for (id key in mapping) {
        [encoder encodeObject:[self valueForKey:key] forKey:mapping[key]];
    }
}


@end
