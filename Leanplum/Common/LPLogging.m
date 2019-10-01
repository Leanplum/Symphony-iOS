//
//  LPLog.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPLogging.h"
#import "LPApiConstants.h"
#import "LPConstants.h"
#import "LPLogApi.h"

@implementation LPLogging

void LPLog(LPLogType type, NSString *format, ...) {
    va_list vargs;
    va_start(vargs, format);
    NSString *formattedMessage = [[NSString alloc] initWithFormat:format arguments:vargs];
    va_end(vargs);
    
    NSString *message;
    switch (type) {
        case LPDebug:
#ifdef DEBUG
            message = [NSString stringWithFormat:@"Leanplum DEBUG: %@", formattedMessage];
            printf("%s\n", [message UTF8String]);
#endif
            return;
        case LPVerbose:
            if ([LPApiConstants sharedState].isDevelopmentModeEnabled
                && [LPApiConstants sharedState].verboseLoggingInDevelopmentMode) {
                message = [NSString stringWithFormat:@"Leanplum VERBOSE: %@", formattedMessage];
                printf("%s\n", [message UTF8String]);
                [LPLogging maybeSendLog:message];
            }
            return;
        case LPError:
            message = [NSString stringWithFormat:@"Leanplum ERROR: %@", formattedMessage];
            printf("%s\n", [message UTF8String]);
            [LPLogging maybeSendLog:message];
            return;
        case LPWarning:
            message = [NSString stringWithFormat:@"Leanplum WARNING: %@", formattedMessage];
            printf("%s\n", [message UTF8String]);
            [LPLogging maybeSendLog:message];
            return;
        case LPInfo:
            message = [NSString stringWithFormat:@"Leanplum INFO: %@", formattedMessage];
            printf("%s\n", [message UTF8String]);
            [LPLogging maybeSendLog:message];
            return;
        case LPInternal:
            message = [NSString stringWithFormat:@"Leanplum INTERNAL: %@", formattedMessage];
            [LPLogging maybeSendLog:message];
            return;
        default:
            return;
    }
}

+ (void)maybeSendLog:(NSString *)message {
    if (![LPApiConstants sharedState].loggingEnabled) {
        return;
    }
    
    NSMutableDictionary *threadDict = [[NSThread currentThread] threadDictionary];
    BOOL isLogging = [[[[NSThread currentThread] threadDictionary]
                       objectForKey:LP_IS_LOGGING] boolValue];
    
    if (isLogging) {
        return;
    }
    
    threadDict[LP_IS_LOGGING] = @YES;
    
    @try {
        [LPLogApi logWithMessage:message parameters:nil success:nil failure:^(NSError *error) {
            NSLog(@"Leanplum: Unable to send log: %@", error);
        }];
    } @catch (NSException *exception) {
        NSLog(@"Leanplum: Unable to send log: %@", exception);
    } @finally {
        [threadDict removeObjectForKey:LP_IS_LOGGING];
    }
}


@end
