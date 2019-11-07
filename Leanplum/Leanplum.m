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
#import "LPStopApi.h"
#import "LPPauseSessionApi.h"
#import "LPPauseStateApi.h"
#import "LPResumeSessionApi.h"
#import "LPResumeStateApi.h"
#import "LPApiConstants.h"
#import "LPUtils.h"
#import "LPInternalState.h"
#import "LPConstants.h"
#import "LPAPIConfig.h"
#import "UIDevice+IdentifierAddition.h"
#import "LPCache.h"
#import "LPPushUtils.h"
#import "LPActionManager.h"
#import "LPSwizzle.h"
#import "NSExtensionContext+Leanplum.h"

__weak static NSExtensionContext *_extensionContext = nil;

BOOL inForeground = NO;

@implementation Leanplum

+ (void)setAppId:(NSString *)appId withDevelopmentKey:(NSString *)accessKey
{
    if ([LPUtils isNullOrEmpty:appId]) {
        [self throwError:@"[Leanplum setAppId:withDevelopmentKey:] Empty appId parameter "
         @"provided."];
        return;
    }
    if ([LPUtils isNullOrEmpty:accessKey]) {
        [self throwError:@"[Leanplum setAppId:withDevelopmentKey:] Empty accessKey parameter "
         @"provided."];
        return;
    }
    
    [LPApiConstants sharedState].isDevelopmentModeEnabled = YES;
    [[LPAPIConfig sharedConfig] setAppId:appId withAccessKey:accessKey];
    //ToDo: Initialize Static Variables
}

+ (void)setAppId:(NSString *)appId withProductionKey:(NSString *)accessKey
{
    if ([LPUtils isNullOrEmpty:appId]) {
        [self throwError:@"[Leanplum setAppId:withProductionKey:] Empty appId parameter provided."];
        return;
    }
    if ([LPUtils isNullOrEmpty:accessKey]) {
        [self throwError:@"[Leanplum setAppId:withProductionKey:] Empty accessKey parameter "
         @"provided."];
        return;
    }
    
    [LPApiConstants sharedState].isDevelopmentModeEnabled = NO;
    [[LPAPIConfig sharedConfig] setAppId:appId withAccessKey:accessKey];
    //ToDo: Initialize Static Variables
}

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

+ (void)setAppVersion:(NSString *)appVersion
{
    [LPInternalState sharedState].appVersion = appVersion;
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
    } isMuti:NO];
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

+ (void)onStartResponse:(LeanplumStartBlock)block
{
    if (!block) {
        [self throwError:@"[Leanplum onStartResponse:] Nil block parameter provided."];
        return;
    }

    if ([LPInternalState sharedState].hasStarted) {
        block([LPInternalState sharedState].startSuccessful);
    } else {
        if (![LPInternalState sharedState].startBlocks) {
            [LPInternalState sharedState].startBlocks = [NSMutableArray array];
        }
        [[LPInternalState sharedState].startBlocks addObject:[block copy]];
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
        [self triggerStartResponse:YES];
        response(true);
    } withFailure:^(NSError *error){
        [self triggerStartResponse:NO];
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
    if (!deviceId) {
        deviceId = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
    }
    if (!deviceId) {
        deviceId = [[UIDevice currentDevice] leanplum_uniqueGlobalDeviceIdentifier];
    }
    
    [[LPAPIConfig sharedConfig] setDeviceId:deviceId];
    
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
                                     LP_PARAM_DEVICE_MODEL: device.platform,
                                     LP_PARAM_DEVICE_SYSTEM_NAME: device.systemName,
                                     LP_PARAM_DEVICE_SYSTEM_VERSION: device.systemVersion,
                                     LP_KEY_LOCALE: currentLocaleString,
                                     LP_KEY_TIMEZONE: [localTimeZone name],
                                     LP_KEY_TIMEZONE_OFFSET_SECONDS: timezoneOffsetSeconds,
                                     LP_KEY_COUNTRY: LP_VALUE_DETECT,
                                     LP_KEY_REGION: LP_VALUE_DETECT,
                                     LP_KEY_CITY: LP_VALUE_DETECT,
                                     LP_KEY_LOCATION: LP_VALUE_DETECT,
                                     LP_PARAM_RICH_PUSH_ENABLED: @([LPPushUtils isRichPushEnabled])
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
    
    params[LP_PARAM_NEW_USER_ID] = userId;
    
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
        [[LPCache sharedCache] setRegions:response.regions];
        success();
    } failure:^(NSError *error) {
        failure(error);
    } isMulti:NO];
    
    // Pause.
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationDidEnterBackgroundNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *notification) {
                    if (![[[[NSBundle mainBundle] infoDictionary]
                            objectForKey:@"UIApplicationExitsOnSuspend"] boolValue]) {
                        [Leanplum pause];
                    }
                }];
    
    // Resume.
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationWillEnterForegroundNotification
                    object:nil
                     queue:nil
                usingBlock:^(NSNotification *notification) {
                    if ([[UIApplication sharedApplication]
                            respondsToSelector:@selector(currentUserNotificationSettings)]) {
                        [[LPActionManager sharedManager] sendUserNotificationSettingsIfChanged:
                                                             [[UIApplication sharedApplication]
                                                                 currentUserNotificationSettings]];
                    }
                    [Leanplum resume];
                    if (startedInBackground && !inForeground) {
                        inForeground = YES;
                        // ToDo: These are message filters need to be implemented.
                        /*[self maybePerformActions:@[@"start", @"resume"]
                                    withEventName:nil
                                       withFilter:kLeanplumActionFilterAll
                                    fromMessageId:nil
                             withContextualValues:nil];*/
                        //ToDo: Attribute changes
                        //[self recordAttributeChanges];
                    } else {
                        // ToDo: These are message filters need to be implemented.
                        /*[self maybePerformActions:@[@"resume"]
                                    withEventName:nil
                                       withFilter:kLeanplumActionFilterAll
                                    fromMessageId:nil
                             withContextualValues:nil];*/
                    }
                }];

    // Stop.
    [[NSNotificationCenter defaultCenter]
        addObserverForName:UIApplicationWillTerminateNotification
        object:nil
        queue:nil
        usingBlock:^(NSNotification *notification) {
        //ToDo: E2-2071, we need to add a proper flag for multi and non multi and use the below value.
        /*BOOL exitOnSuspend = [[[[NSBundle mainBundle] infoDictionary]
                       objectForKey:@"UIApplicationExitsOnSuspend"] boolValue];*/
        [LPStopApi stopWithParameters:@{} success:^{
            NSLog(@"LPStopApi successful");
        } failure:^(NSError *error) {
            NSLog(@"LPStopApi Error %@", error);
        } isMulti:YES];
    }];
    
    // Extension close.
    if (_extensionContext) {
        [LPSwizzle
            swizzleMethod:@selector(completeRequestReturningItems:completionHandler:)
               withMethod:@selector(leanplum_completeRequestReturningItems:completionHandler:)
                    error:nil
                    class:[NSExtensionContext class]];
        [LPSwizzle swizzleMethod:@selector(cancelRequestWithError:)
                      withMethod:@selector(leanplum_cancelRequestWithError:)
                           error:nil
                           class:[NSExtensionContext class]];
    }
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

+ (void)triggerStartResponse:(BOOL)success
{
    for (LeanplumStartBlock block in [LPInternalState sharedState].startBlocks.copy) {
        block(success);
    }
    [[LPInternalState sharedState].startBlocks removeAllObjects];
}

+ (void)pause
{
    UIApplication *application = [UIApplication sharedApplication];
    UIBackgroundTaskIdentifier __block backgroundTask;
    
    // Block that finish task.
    void (^finishTaskHandler)(void) = ^(){
        [application endBackgroundTask:backgroundTask];
        backgroundTask = UIBackgroundTaskInvalid;
    };
    
    // Start background task to make sure it runs when the app is in background.
    backgroundTask = [application beginBackgroundTaskWithExpirationHandler:finishTaskHandler];
    
    // Send pause event.
    [LPPauseSessionApi pauseSessionWithParameters:nil success:^{
        finishTaskHandler();
    } failure:^(NSError *error) {
        finishTaskHandler();
    } isMulti:YES];
}

+ (void)resume
{
    [LPResumeSessionApi resumeSessionWithParameters:@{} success:^{
        NSLog(@"LPResumeSessionApi success");
    } failure:^(NSError *error) {
        NSLog(@"LPResumeSessionApi failure %@", error);
    } isMulti:YES];
}

+ (void)pauseState
{
    if (![LPInternalState sharedState].calledStart) {
        [self throwError:@"You cannot call pauseState before calling start"];
        return;
    }

    [self onStartIssued:^{
        [self pauseStateInternal];
    }];
}

+ (void)pauseStateInternal
{
    [LPPauseStateApi pauseStateWithParameters:@{} success:^{
        NSLog(@"pausedStateInternal API successful ");
    } failure:^(NSError *error) {
        NSLog(@"pausedStateInternalFailure %@", error);
    } isMulti:YES];
}

+ (void)resumeState
{
    if (![LPInternalState sharedState].calledStart) {
        [self throwError:@"You cannot call resumeState before calling start"];
        return;
    }

    [self onStartIssued:^{
        [self resumeStateInternal];
    }];
}

+ (void)resumeStateInternal
{
    [LPResumeStateApi resumeStateWithParameters:@{} success:^{
        NSLog(@"resumeStateWithParameters API successful ");
    } failure:^(NSError *error) {
        NSLog(@"resumeStateWithParameters %@", error);
    } isMulti:YES];
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

//Handle Action Manager Swizzled methods

+ (void)handleNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    [LPInternalState sharedState].calledHandleNotification = YES;
    [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                                       withAction:nil
                                           fetchCompletionHandler:completionHandler];
}

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didRegisterForRemoteNotificationsWithDeviceToken:token];
    }
}

+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didFailToRegisterForRemoteNotificationsWithError:error];
    }
}

+ (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didRegisterUserNotificationSettings:notificationSettings];
    }
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo];
    }
}

+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                               fetchCompletionHandler:completionHandler];
    }
}

+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
                 withCompletionHandler:(void (^)(void))completionHandler
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didReceiveNotificationResponse:response
                                                  withCompletionHandler:completionHandler];
    }
}

+ (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
{
    if (![LPUtils isSwizzlingEnabled])
    {
        [[LPActionManager sharedManager] didReceiveLocalNotification:localNotification];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
+ (void)handleActionWithIdentifier:(NSString *)identifier
              forLocalNotification:(UILocalNotification *)notification
                 completionHandler:(void (^)())completionHandler
{
    [[LPActionManager sharedManager] didReceiveRemoteNotification:[notification userInfo]
                                                       withAction:identifier
                                           fetchCompletionHandler:completionHandler];
}
#pragma clang diagnostic pop

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
+ (void)handleActionWithIdentifier:(NSString *)identifier
             forRemoteNotification:(NSDictionary *)notification
                 completionHandler:(void (^)())completionHandler
{
    [[LPActionManager sharedManager] didReceiveRemoteNotification:notification
                                                       withAction:identifier
                                           fetchCompletionHandler:completionHandler];
}
@end
