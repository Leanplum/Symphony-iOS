//
//  Leanplum.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/9/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Leanplum.h"
#import "LPUserApi.h"
#import "LPApiConstants.h"
#import "LPUtils.h"

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
    attributes = [self validateAttributes:attributes named:@"userAttributes" allowLists:YES];
    [self setUserIdInternal:userId withAttributes:attributes
                withSuccess:(void (^)(void))success
                withFailure:(void (^)(NSError *error))failure];
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
    [LPUserApi setUsersAttributes:userId withUserAttributes:attributes success:^{
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

@end
