//
//  LPJSON.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * LPJSON
 * Converts between JSON and string/data using NSJSONSerialization class.
 * Made for convenience and readability.
 */
@interface LPJSON : NSObject

/**
 * Returns a string from JSON. nil when errored.
 */
+ (NSString *)stringFromJSON : (id)object;

/**
 * Returns a JSON from NSString. nil when errored.
 */
+ (id)JSONFromString : (NSString *)string;

/**
 * Returns a JSON from NSData. nil when errored.
 */
+ (id)JSONFromData: (NSData *)data;

@end
