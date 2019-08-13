//
//  LPModel.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/12/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPModel.h"

@interface LPModel (private)

@property (nonatomic, retain) NSDictionary *classMapping;

@end

@implementation LPModel

- (void) initWithMapping:(NSDictionary *)classMapping {
    self.classMapping = classMapping;
}

- (id)initWithCoder:(NSCoder *)decoder {
    if (self = [super init]) {
        NSDictionary *mapping = self.classMapping;
        for (id key in mapping) {
            [self setValue:[decoder decodeObjectForKey:key] forKey:mapping[key]];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    NSDictionary *mapping = self.classMapping;
    for (id key in mapping) {
        [encoder encodeObject:[self valueForKey:key] forKey:mapping[key]];
    }
}


@end
