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
#import "LPStartApi.h"
#import "LPApiConstants.h"
#import "LPUtils.h"
#import "LPInternalState.h"
#import "LPConstants.h"
#import "LPAPIConfig.h"
#import "UIDevice+IdentifierAddition.h"
#include <sys/sysctl.h>

__weak static NSExtensionContext *_extensionContext = nil;

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

+ (BOOL)isRichPushEnabled
{
    NSString *plugInsPath = [NSBundle mainBundle].builtInPlugInsPath;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtPath:plugInsPath];
    NSString *filePath;
    while (filePath = [enumerator nextObject]) {
        if([filePath hasSuffix:@".appex/Info.plist"]) {
            NSString *newPath = [[plugInsPath stringByAppendingPathComponent:filePath]
                                 stringByDeletingLastPathComponent];
            NSBundle *currentBundle = [NSBundle bundleWithPath:newPath];
            NSDictionary *extensionKey =
            [currentBundle objectForInfoDictionaryKey:@"NSExtension"];
            if ([[extensionKey objectForKey:@"NSExtensionPrincipalClass"]
                 isEqualToString:@"NotificationService"]) {
                return YES;
            }
        }
    }
    return NO;
}

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
}

+ (NSString *)pushTokenKey
{
    return [NSString stringWithFormat: LEANPLUM_DEFAULTS_PUSH_TOKEN_KEY,
            [LPAPIConfig sharedConfig].appId, [LPAPIConfig sharedConfig].userId, [LPAPIConfig sharedConfig].deviceId];
}

+ (void)start
{
    [self startWithUserId:nil userAttributes:nil withSuccess:nil withFailure:nil];
}

+ (void)startWithResponseHandler:(LeanplumStartBlock)response
{
    [self startWithUserId:nil userAttributes:nil withSuccess:^{
        response(true);
    } withFailure:^(NSError *error){
        response(false);
    }];
}

+ (void)startWithUserAttributes:(NSDictionary *)attributes
{
    [self startWithUserId:nil userAttributes:attributes withSuccess:nil withFailure:nil];
}

+ (void)startWithUserId:(NSString *)userId
{
    [self startWithUserId:userId userAttributes:nil withSuccess:nil withFailure:nil];
}

+ (void)startWithUserId:(NSString *)userId responseHandler:(LeanplumStartBlock)response
{
    [self startWithUserId:userId userAttributes:nil withSuccess:^{
        response(true);
    } withFailure:^(NSError *error){
        response(false);
    }];
}

+ (void)startWithUserId:(NSString *)userId userAttributes:(NSDictionary *)attributes
{
    [self startWithUserId:userId userAttributes:attributes withSuccess:nil withFailure:nil];
}

+ (void)startWithUserId:(NSString *)userId
            userAttributes:(NSDictionary *)attributes
            withSuccess:(void (^)(void))success
            withFailure:(void (^)(NSError *error))failure {
   
    if ([LPAPIConfig sharedConfig].appId == nil) {
        [self throwError:@"Please provide your app ID using one of the [Leanplum setAppId:] "
         @"methods."];
        return;
    }
    
    // Leanplum should not be started in background.
    if (![NSThread isMainThread]) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self startWithUserId:userId userAttributes:attributes withSuccess:success withFailure:failure];
        });
        return;
    }
    
    attributes = [self validateAttributes:attributes named:@"userAttributes" allowLists:YES];
    
    // Set device ID.
    NSString *deviceId = [LPAPIConfig sharedConfig].deviceId;
    
    LPInternalState *state = [LPInternalState sharedState];
    //ToDo: IS_NOOP logic, need to decide the reason for this logic and if needed
    
    if (state.calledStart) {
        [self throwError:@"Already called start."];
    }
    state.calledStart = YES;
    // This is the device ID set when the MAC address is used on iOS 7.
    // This is to allow apps who upgrade to the new ID to forget the old one.
    if ([deviceId isEqualToString:@"0f607264fc6318a92b9e13c65db7cd3c"]) {
        deviceId = nil;
    }
    if (!deviceId) {
        if ([LPAPIConfig sharedConfig].deviceId) {
            deviceId = [LPAPIConfig sharedConfig].deviceId;
        } else {
            deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        }
        if (!deviceId) {
            deviceId = [[UIDevice currentDevice] leanplum_uniqueGlobalDeviceIdentifier];
        }
        [[LPAPIConfig sharedConfig] setDeviceId:deviceId];
    }
    
    // Set user ID.
    if (!userId) {
        userId = [LPAPIConfig sharedConfig].userId;
        if (!userId) {
            userId = [LPAPIConfig sharedConfig].deviceId;
        }
    }
    [[LPAPIConfig sharedConfig] setUserId:userId];
    
    // Setup parameters.
    NSString *versionName = [LPApiConstants sharedState].sdkVersion;
    if (!versionName) {
        versionName = [[[NSBundle mainBundle] infoDictionary]
                       objectForKey:@"CFBundleVersion"];
    }
    UIDevice *device = [UIDevice currentDevice];
    NSLocale *currentLocale = [NSLocale currentLocale];
    NSString *currentLocaleString = [NSString stringWithFormat:@"%@_%@",
                                     [[NSLocale preferredLanguages] objectAtIndex:0],
                                     [currentLocale objectForKey:NSLocaleCountryCode]];
    // Set the device name. But only if running in development mode.
    NSString *deviceName = @"";
    if ([LPApiConstants sharedState].isDevelopmentModeEnabled) {
        deviceName = device.name ?: @"";
    }
    NSTimeZone *localTimeZone = [NSTimeZone localTimeZone];
    NSNumber *timezoneOffsetSeconds =
    [NSNumber numberWithInteger:[localTimeZone secondsFromGMTForDate:[NSDate date]]];
    NSMutableDictionary *params = [@{
                                     LP_PARAM_INCLUDE_DEFAULTS: @(NO),
                                     LP_PARAM_VERSION_NAME: versionName,
                                     LP_PARAM_DEVICE_NAME: deviceName,
                                     LP_PARAM_DEVICE_MODEL: [self platform],
                                     LP_PARAM_DEVICE_SYSTEM_NAME: device.systemName,
                                     LP_PARAM_DEVICE_SYSTEM_VERSION: device.systemVersion,
                                     LP_KEY_LOCALE: currentLocaleString,
                                     LP_KEY_TIMEZONE: [localTimeZone name],
                                     LP_KEY_TIMEZONE_OFFSET_SECONDS: timezoneOffsetSeconds,
                                     LP_KEY_COUNTRY: LP_VALUE_DETECT,
                                     LP_KEY_REGION: LP_VALUE_DETECT,
                                     LP_KEY_CITY: LP_VALUE_DETECT,
                                     LP_KEY_LOCATION: LP_VALUE_DETECT,
                                     LP_PARAM_RICH_PUSH_ENABLED: @([self isRichPushEnabled])
                                     } mutableCopy];
    //Todo: Variant debug. Please check old sdk.
    BOOL startedInBackground = NO;
    if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground &&
        !_extensionContext) {
        params[LP_PARAM_BACKGROUND] = @(YES);
        startedInBackground = YES;
    }
    
    if (attributes != nil) {
        params[LP_PARAM_USER_ATTRIBUTES] = attributes ?
        [LPJSON stringFromJSON:attributes] : @"";
    }
    if ([LPApiConstants sharedState].isDevelopmentModeEnabled) {
        params[LP_PARAM_DEV_MODE] = @(YES);
    }
    
    NSDictionary *timeParams = [self initializePreLeanplumInstall];
    if (timeParams) {
        [params addEntriesFromDictionary:timeParams];
    }
    //ToDo, Inbox messageIds
    
    // Push token.
    NSString *pushTokenKey = [Leanplum pushTokenKey];
    NSString *pushToken = [[NSUserDefaults standardUserDefaults] stringForKey:pushTokenKey];
    if (pushToken) {
        params[LP_PARAM_DEVICE_PUSH_TOKEN] = pushToken;
    }
    
    [LPStartApi startWithParameters:params success:^(LPStartResponse *response) {
        success();
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+ (BOOL)hasStartedAndRegisteredAsDeveloper
{
    return [LPInternalState sharedState].hasStartedAndRegisteredAsDeveloper;
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

// On first run with Leanplum, determine if this app was previously installed without Leanplum.
// This is useful for detecting if the user may have already rejected notifications.
+ (NSDictionary *)initializePreLeanplumInstall
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([[[defaults dictionaryRepresentation] allKeys]
         containsObject:LEANPLUM_DEFAULTS_PRE_LEANPLUM_INSTALL_KEY]) {
        return nil;
    } else {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSURL *urlToDocumentsFolder = [[fileManager URLsForDirectory:NSDocumentDirectory
                                                           inDomains:NSUserDomainMask] lastObject];
        __autoreleasing NSError *error;
        NSDate *installDate =
        [[fileManager attributesOfItemAtPath:urlToDocumentsFolder.path error:&error]
         objectForKey:NSFileCreationDate];
        NSString *pathToInfoPlist = [[NSBundle mainBundle] pathForResource:@"Info" ofType:@"plist"];
        NSString *pathToAppBundle = [pathToInfoPlist stringByDeletingLastPathComponent];
        NSDate *updateDate = [[fileManager attributesOfItemAtPath:pathToAppBundle error:&error]
                              objectForKey:NSFileModificationDate];
        
        // Considered pre-Leanplum install if its been more than a day (86400 seconds) since
        // install.
        NSTimeInterval secondsBetween = [updateDate timeIntervalSinceDate:installDate];
        [[NSUserDefaults standardUserDefaults] setBool:(secondsBetween > 86400)
                                                forKey:LEANPLUM_DEFAULTS_PRE_LEANPLUM_INSTALL_KEY];
        return @{
                 LP_PARAM_INSTALL_DATE:
                     [NSString stringWithFormat:@"%f", [installDate timeIntervalSince1970]],
                 LP_PARAM_UPDATE_DATE:
                     [NSString stringWithFormat:@"%f", [updateDate timeIntervalSince1970]]
                 };
    }
}


@end
