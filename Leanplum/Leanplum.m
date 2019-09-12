//
//  Leanplum.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/9/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LeanplumInternal.h"
#import <Foundation/Foundation.h>
#import "Leanplum.h"
#import "LPUserApi.h"
#import "LPApiConstants.h"
#import "LPUtils.h"
#import "LPInternalState.h"
#import "LPConstants.h"
#import "LPAPIConfig.h"

@implementation Leanplum

+ (void)setApiHostName:(NSString *)hostName
       withServletName:(NSString *)servletName
              usingSsl:(BOOL)ssl
{
    if ([LPUtils isNullOrEmpty:hostName]) {
        [self throwError:@"[Leanplum setApiHostName:withServletName:usingSsl:] Empty hostname "
         @"parameter provided."];
        return;
    }
    if ([LPUtils isNullOrEmpty:servletName]) {
        [self throwError:@"[Leanplum setApiHostName:withServletName:usingSsl:] Empty servletName "
         @"parameter provided."];
        return;
    }
    
    [LPApiConstants sharedState].apiHostName = hostName;
    [LPApiConstants sharedState].apiServlet = servletName;
    [LPApiConstants sharedState].apiSSL = ssl;
}

+ (void)setDeviceId:(NSString *)deviceId
{
    if ([LPUtils isBlank:deviceId]) {
        [self throwError:@"[Leanplum setDeviceId:] Empty deviceId parameter provided."];
        return;
    }
    if ([deviceId isEqualToString:LP_INVALID_IDFA]) {
        [self throwError:[NSString stringWithFormat:@"[Leanplum setDeviceId:] Failed to set '%@' "
                          "as deviceId. You are most likely attempting to use the IDFA as deviceId "
                          "when the user has limited ad tracking on iOS10 or above.",
                          LP_INVALID_IDFA]];
        return;
    }
    [LPAPIConfig sharedConfig].deviceId = deviceId;
}

+ (NSString *)deviceId
{
    if (![LPInternalState sharedState].calledStart) {
        [self throwError:@"[Leanplum start] must be called before calling deviceId"];
        return nil;
    }
    return [LPAPIConfig sharedConfig].deviceId;
    return nil;
}

+ (void)onHasStartedAndRegisteredAsDeveloper
{
    //ToDo: Uncomment, once FileManager is implemented.
    /*if ([LPFileManager initializing]) {
        [LPFileManager setResourceSyncingReady:^{
            [self onHasStartedAndRegisteredAsDeveloperAndFinishedSyncing];
        }];
    } else {*/
        [self onHasStartedAndRegisteredAsDeveloperAndFinishedSyncing];
    //}
}

+ (void)onHasStartedAndRegisteredAsDeveloperAndFinishedSyncing
{
    if (![LPInternalState sharedState].hasStartedAndRegisteredAsDeveloper) {
        [LPInternalState sharedState].hasStartedAndRegisteredAsDeveloper = YES;
    }
}

+ (void)setNetworkTimeoutSeconds:(int)seconds
{
    if (seconds < 0) {
        [self throwError:@"[Leanplum setNetworkTimeoutSeconds:] Invalid seconds parameter "
         @"provided."];
        return;
    }
    
    [LPApiConstants sharedState].networkTimeoutSeconds = seconds;
    [LPApiConstants sharedState].networkTimeoutSecondsForDownloads = seconds;
}

+ (void)setNetworkTimeoutSeconds:(int)seconds forDownloads:(int)downloadSeconds
{
    if (seconds < 0) {
        [self throwError:@"[Leanplum setNetworkTimeoutSeconds:forDownloads:] Invalid seconds "
         @"parameter provided."];
        return;
    }
    if (downloadSeconds < 0) {
        [self throwError:@"[Leanplum setNetworkTimeoutSeconds:forDownloads:] Invalid "
         @"downloadSeconds parameter provided."];
        return;
    }
    
    [LPApiConstants sharedState].networkTimeoutSeconds = seconds;
    [LPApiConstants sharedState].networkTimeoutSecondsForDownloads = downloadSeconds;
}

+ (void)setUserAttributes:(NSDictionary *)attributes
              withSuccess:(void (^)(void))success
              withFailure:(void (^)(NSError *error))failure
{
    [self setUserId:@"" withUserAttributes:attributes withSuccess:success withFailure:failure];
}

+ (void)setUserId:(NSString *)userId
      withSuccess:(void (^)(void))success
      withFailure:(void (^)(NSError *error))failure {
    [self setUserId:userId withUserAttributes:@{} withSuccess:success withFailure:failure];
}

+ (void)setUserId:(NSString *)userId withUserAttributes:(NSDictionary *)attributes
      withSuccess:(void (^)(void))success
      withFailure:(void (^)(NSError *error))failure
{
    if (![LPInternalState sharedState].calledStart) {
        //ToDo: Once start with user attributes is implemented , call this.
    }
    
    attributes = [self validateAttributes:attributes named:@"userAttributes" allowLists:YES];
    [self onStartIssued:^{
        [self setUserIdInternal:userId withAttributes:attributes
                    withSuccess:(void (^)(void))success
                    withFailure:(void (^)(NSError *error))failure];
    }];
}

+ (void)setUserIdInternal:(NSString *)userId
           withAttributes:(NSDictionary *)attributes
              withSuccess:(void (^)(void))success
              withFailure:(void (^)(NSError *error))failure
{
    // Some clients are calling this method with NSNumber. Handle it gracefully.
    id tempUserId = userId;
    if ([tempUserId isKindOfClass:[NSNumber class]]) {
        userId = [tempUserId stringValue];
    }
    
    // Attributes can't be nil
    if (!attributes) {
        attributes = @{};
    }
    [LPUserApi setUserId:userId withUserAttributes:attributes success:^{
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (NSDictionary *)validateAttributes:(NSDictionary *)attributes named:(NSString *)argName
                          allowLists:(BOOL)allowLists
{
    NSMutableDictionary *validAttributes = [NSMutableDictionary dictionary];
    for (id key in attributes) {
        if (![key isKindOfClass:NSString.class]) {
            [self throwError:[NSString stringWithFormat:
                              @"%@ keys must be of type NSString.", argName]];
            continue;
        }
        id value = attributes[key];
        if (allowLists &&
            ([value isKindOfClass:NSArray.class] ||
             [value isKindOfClass:NSSet.class])) {
                BOOL valid = YES;
                for (id item in value) {
                    if (![self validateScalarValue:item argName:argName]) {
                        valid = NO;
                        break;
                    }
                }
                if (!valid) {
                    continue;
                }
            } else {
                if ([value isKindOfClass:NSDate.class]) {
                    value = [NSNumber numberWithUnsignedLongLong:
                             [(NSDate *) value timeIntervalSince1970] * 1000];
                }
                if (![self validateScalarValue:value argName:argName]) {
                    continue;
                }
            }
        validAttributes[key] = value;
    }
    return validAttributes;
}

+ (BOOL)validateScalarValue:(id)value argName:(NSString *)argName
{
    if (![value isKindOfClass:NSString.class] &&
        ![value isKindOfClass:NSNumber.class] &&
        ![value isKindOfClass:NSNull.class]) {
        [self throwError:[NSString stringWithFormat:
                          @"%@ values must be of type NSString, NSNumber, or NSNull.", argName]];
        return NO;
    }
    if ([value isKindOfClass:NSNumber.class]) {
        if ([value isEqualToNumber:[NSDecimalNumber notANumber]]) {
            [self throwError:[NSString stringWithFormat:
                              @"%@ values must not be [NSDecimalNumber notANumber].", argName]];
            return NO;
        }
    }
    return YES;
}

+ (void)throwError:(NSString *)reason
{
    if ([LPApiConstants sharedState].isDevelopmentModeEnabled) {
        @throw([NSException
                exceptionWithName:@"Leanplum Error"
                reason:[NSString stringWithFormat:@"Leanplum: %@ This error is only thrown "
                        @"in development mode.", reason]
                userInfo:nil]);
    } else {
        NSLog(@"Leanplum: Error: %@", reason);
    }
}

+ (void)onStartIssued:(LeanplumStartIssuedBlock)block
{
    if ([LPInternalState sharedState].issuedStart) {
        block();
    } else {
        if (![LPInternalState sharedState].startIssuedBlocks) {
            [LPInternalState sharedState].startIssuedBlocks = [NSMutableArray array];
        }
        [[LPInternalState sharedState].startIssuedBlocks addObject:[block copy]];
    }
}

+ (BOOL)hasStarted
{
    return [LPInternalState sharedState].hasStarted;
    return NO;
}

+ (BOOL)hasStartedAndRegisteredAsDeveloper
{
    return [LPInternalState sharedState].hasStartedAndRegisteredAsDeveloper;
    return NO;
}

+ (void)triggerStartIssued
{
    [LPInternalState sharedState].issuedStart = YES;
    for (LeanplumStartIssuedBlock block in [LPInternalState sharedState].startIssuedBlocks.copy) {
        block();
    }
    [[LPInternalState sharedState].startIssuedBlocks removeAllObjects];
}

+ (void)pause
{
    //ToDo: Implement the pause state management.
}

+ (void)resume
{
    //ToDo: Implement the resume state management
}

@end
