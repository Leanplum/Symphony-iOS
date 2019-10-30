//
//  LPResultSuccess.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/24/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPResultSuccess.h"

@implementation LPResultSuccess

+ (BOOL) checkSuccess:(NSDictionary *)resultDict {
    
    if ([resultDict objectForKey:@"success"] == nil) {
        if (resultDict != nil) {
            return true;
        }
    }
    if ([[resultDict objectForKey:@"success"] boolValue]) {
        return true;
    }
    
    return false;
}

@end
