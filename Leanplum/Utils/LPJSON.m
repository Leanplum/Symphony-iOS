//
//  LPJSON.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPJSON.h"

@implementation LPJSON

+ (NSString *)stringFromJSON : (id)object
{
    if (![NSJSONSerialization isValidJSONObject:object]) {
        return nil;
    }
    NSError *error;
    NSData *data = [NSJSONSerialization dataWithJSONObject:object options:0
                                                     error:&error];
    if (error) {
        return nil;
    }
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
