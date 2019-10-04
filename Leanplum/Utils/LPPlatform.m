//
//  LPPlatform.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 9/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPPlatform.h"
#import <UIKit/UIKit.h>
#include <sys/sysctl.h>

@implementation LPPlatform

+ (NSString *)platform
{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *answer = malloc(size);
    sysctlbyname("hw.machine", answer, &size, NULL, 0);
    
    NSString *results = [NSString stringWithCString:answer encoding: NSUTF8StringEncoding];
    
    free(answer);
    
    if ([results isEqualToString:@"i386"] ||
        [results isEqualToString:@"x86_64"]) {
        results = [[UIDevice currentDevice] model];
    }
    
    return results;
}

@end
