//
//  LPActionManager.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/3/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "NSObject+LeanplumExtension.h"
#import "LPActionManager.h"
#import "LPSwizzle.h"
#import "LeanplumInternal.h"
#import "LPUtils.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface LPActionManager()

@property (nonatomic, strong) NSMutableDictionary *messageImpressionOccurrences;
@property (nonatomic, strong) NSMutableDictionary *messageTriggerOccurrences;
@property (nonatomic, strong) NSMutableDictionary *sessionOccurrences;
@property (nonatomic, strong) NSString *notificationHandled;
@property (nonatomic, strong) NSDate *notificationHandledTime;
@property (nonatomic, strong) LeanplumShouldHandleNotificationBlock shouldHandleNotification;
@property (nonatomic, strong) NSString *displayedTracked;
@property (nonatomic, strong) NSDate *displayedTrackedTime;

@end

@implementation LPActionManager

static LPActionManager *leanplum_sharedActionManager = nil;
static dispatch_once_t leanplum_onceToken;

+ (LPActionManager *)sharedManager
{
    dispatch_once(&leanplum_onceToken, ^{
        leanplum_sharedActionManager = [[self alloc] init];
    });
    return leanplum_sharedActionManager;
}

// Used for unit testing.
+ (void)reset
{
    leanplum_sharedActionManager = nil;
    leanplum_onceToken = 0;
}

- (id)init
{
    if (self = [super init]) {
        [self listenForLocalNotifications];
        _sessionOccurrences = [NSMutableDictionary dictionary];
        _messageImpressionOccurrences = [NSMutableDictionary dictionary];
        _messageTriggerOccurrences = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (void) load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
        [notificationCenter addObserver:self
                               selector:@selector(handleApplicationDidBecomeActive:)
                                   name:UIApplicationDidFinishLaunchingNotification
                                 object:nil];
    });
}

+ (void)handleApplicationDidBecomeActive:(NSNotification *)notification {
    [LPActionManager swizzleAppMethods];
}

#pragma mark - Push Notifications

- (void)sendUserNotificationSettingsIfChanged:(UIUserNotificationSettings *)notificationSettings
{
    // Send settings.
    NSString *settingsKey = [self leanplum_createUserNotificationSettingsKey];
    NSDictionary *existingSettings = [[NSUserDefaults standardUserDefaults] dictionaryForKey:settingsKey];
    NSNumber *types = @([notificationSettings types]);
    NSMutableArray *categories = [NSMutableArray array];
    for (UIMutableUserNotificationCategory *category in [notificationSettings categories]) {
        if ([category identifier]) {
            // Skip categories that have no identifier.
            [categories addObject:[category identifier]];
        }
    }
    NSArray *sortedCategories = [categories sortedArrayUsingSelector:@selector(compare:)];
    NSDictionary *settings = @{LP_PARAM_DEVICE_USER_NOTIFICATION_TYPES: types,
                               LP_PARAM_DEVICE_USER_NOTIFICATION_CATEGORIES: sortedCategories};
    if (![existingSettings isEqualToDictionary:settings]) {
        [[NSUserDefaults standardUserDefaults] setObject:settings forKey:settingsKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
        /*NSString *tokenKey = [Leanplum pushTokenKey];
        NSString *existingToken = [[NSUserDefaults standardUserDefaults] stringForKey:tokenKey];
        NSMutableDictionary *params = [@{
                LP_PARAM_DEVICE_USER_NOTIFICATION_TYPES: types,
                LP_PARAM_DEVICE_USER_NOTIFICATION_CATEGORIES:
                      [LPJSON stringFromJSON:sortedCategories] ?: @""} mutableCopy];
        if (existingToken) {
            params[LP_PARAM_DEVICE_PUSH_TOKEN] = existingToken;
        }
        [Leanplum onStartResponse:^(BOOL success) {
            LP_END_USER_CODE
            LPRequestFactory *reqFactory = [[LPRequestFactory alloc]
                                            initWithFeatureFlagManager:[LPFeatureFlagManager sharedManager]];
            id<LPRequesting> request = [reqFactory setDeviceAttributesWithParams:params];
            [[LPRequestSender sharedInstance] send:request];
            LP_BEGIN_USER_CODE
        }];*/
    }
}

// Block to run to decide whether to show the notification
// when it is received while the app is running.
- (void)setShouldHandleNotification:(LeanplumShouldHandleNotificationBlock)block
{
    _shouldHandleNotification = block;
}

+ (NSString *)messageIdFromUserInfo:(NSDictionary *)userInfo
{
    NSString *messageId = [userInfo[LP_KEY_PUSH_MESSAGE_ID] description];
    if (messageId == nil) {
        messageId = [userInfo[LP_KEY_PUSH_MUTE_IN_APP] description];
        if (messageId == nil) {
            messageId = [userInfo[LP_KEY_PUSH_NO_ACTION] description];
            if (messageId == nil) {
                messageId = [userInfo[LP_KEY_PUSH_NO_ACTION_MUTE] description];
            }
        }
    }
    return messageId;
}

- (BOOL)isDuplicateNotification:(NSDictionary *)userInfo
{
    if ([self.notificationHandled isEqualToString:[LPJSON stringFromJSON:userInfo]] &&
        [[NSDate date] timeIntervalSinceDate:self.notificationHandledTime] < 10.0) {
        return YES;
    }

    self.notificationHandled = [LPJSON stringFromJSON:userInfo];
    self.notificationHandledTime = [NSDate date];
    return NO;
}

// Performs the notification action if
// (a) The app wasn't active before
// (b) The user accepts that they want to view the notification
- (void)maybePerformNotificationActions:(NSDictionary *)userInfo
                                 action:(NSString *)action
                                 active:(BOOL)active
{
    // Don't handle duplicate notifications.
    if ([self isDuplicateNotification:userInfo]) {
        return;
    }
    NSString *messageId = [LPActionManager messageIdFromUserInfo:userInfo];
    NSString *actionName;
    if (action == nil) {
        actionName = LP_VALUE_DEFAULT_PUSH_ACTION;
    } else {
        actionName = [NSString stringWithFormat:@"iOS options.Custom actions.%@", action];
    }
    /*LPActionContext *context;
    if ([LPActionManager areActionsEmbedded:userInfo]) {
        NSMutableDictionary *args = [NSMutableDictionary dictionary];
        if (action) {
            args[actionName] = userInfo[LP_KEY_PUSH_CUSTOM_ACTIONS][action];
        } else {
            args[actionName] = userInfo[LP_KEY_PUSH_ACTION];
        }
        context = [LPActionContext actionContextWithName:LP_PUSH_NOTIFICATION_ACTION
                                                    args:args
                                               messageId:messageId];
        context.preventRealtimeUpdating = YES;
    } else {
        context = [Leanplum createActionContextForMessageId:messageId];
    }
    [context maybeDownloadFiles];

    LeanplumVariablesChangedBlock handleNotificationBlock = ^{
        [context runTrackedActionNamed:actionName];
    };

    if (!active) {
        handleNotificationBlock();
    } else {
        if (self.shouldHandleNotification) {
            self.shouldHandleNotification(userInfo, handleNotificationBlock);
        } else {
            if (userInfo[LP_KEY_PUSH_NO_ACTION] ||
                userInfo[LP_KEY_PUSH_NO_ACTION_MUTE]) {
                handleNotificationBlock();
            } else {
                id message = userInfo[@"aps"][@"alert"];
                if ([message isKindOfClass:NSDictionary.class]) {
                    message = message[@"body"];
                }
                if (message) {
                    [LPUIAlert showWithTitle:APP_NAME
                                     message:message
                           cancelButtonTitle:NSLocalizedString(@"Cancel", nil)
                           otherButtonTitles:@[NSLocalizedString(@"View", nil)]
                                       block:^(NSInteger buttonIndex) {
                                           if (buttonIndex == 1) {
                                               handleNotificationBlock();
                                           }
                                       }];
                }
            }
        }
    }*/
}

- (BOOL)hasTrackedDisplayed:(NSDictionary *)userInfo
{
    if ([self.displayedTracked isEqualToString:[LPJSON stringFromJSON:userInfo]] &&
        [[NSDate date] timeIntervalSinceDate:self.displayedTrackedTime] < 10.0) {
        return YES;
    }

    self.displayedTracked = [LPJSON stringFromJSON:userInfo];
    self.displayedTrackedTime = [NSDate date];
    return NO;
}

+ (BOOL)areActionsEmbedded:(NSDictionary *)userInfo
{
    return userInfo[LP_KEY_PUSH_ACTION] != nil ||
        userInfo[LP_KEY_PUSH_CUSTOM_ACTIONS] != nil;
}

// Handles the notification.
// Makes sure the data is loaded, and then displays the notification.
- (void)handleNotification:(NSDictionary *)userInfo
                withAction:(NSString *)action
                 appActive:(BOOL)active
         completionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    // Don't handle non-Leanplum notifications.
    NSString *messageId = [LPActionManager messageIdFromUserInfo:userInfo];
    if (messageId == nil) {
        return;
    }

    void (^onContent)(void) = ^{
        if (completionHandler) {
            completionHandler(UIBackgroundFetchResultNewData);
        }
        BOOL hasAlert = userInfo[@"aps"][@"alert"] != nil;
        if (hasAlert) {
            UIApplicationState appState = [[UIApplication sharedApplication] applicationState];
            if (appState != UIApplicationStateBackground) {
                [self maybePerformNotificationActions:userInfo action:action active:active];
            }
        }
    };

}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [self didReceiveRemoteNotification:userInfo fetchCompletionHandler:nil];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    [self didReceiveRemoteNotification:userInfo withAction:nil fetchCompletionHandler:completionHandler];
}

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
                          withAction:(NSString *)action
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    
    // If app was inactive, then handle notification because the user tapped it.
    if ([[UIApplication sharedApplication] applicationState] != UIApplicationStateActive) {
        [self handleNotification:userInfo
                      withAction:action
                       appActive:NO
               completionHandler:completionHandler];
        return;
    } else {
        // Application is active.
        // Hide notifications that should be muted.
        if (!userInfo[LP_KEY_PUSH_MUTE_IN_APP] &&
            !userInfo[LP_KEY_PUSH_NO_ACTION_MUTE]) {
            [self handleNotification:userInfo
                          withAction:action
                           appActive:YES
                   completionHandler:completionHandler];
            return;
        }
    }
    // Call the completion handler only for Leanplum notifications.
    NSString *messageId = [LPActionManager messageIdFromUserInfo:userInfo];
    if (messageId && completionHandler) {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    LPInternalState *state = [LPInternalState sharedState];
    state.calledHandleNotification = NO;
    
    LeanplumFetchCompletionBlock leanplumCompletionHandler =
    ^(LeanplumUIBackgroundFetchResult result) {
        completionHandler();
    };
    
    // Prevents handling the notification twice if the original method calls handleNotification
    // explicitly.
    if (!state.calledHandleNotification) {
        [self didReceiveRemoteNotification:userInfo
                                withAction:nil
                    fetchCompletionHandler:leanplumCompletionHandler];
    }
    state.calledHandleNotification = NO;
}

- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification
{
    NSDictionary *userInfo = [localNotification userInfo];
    
    [self didReceiveRemoteNotification:userInfo
                            withAction:nil
                fetchCompletionHandler:nil];
}
 
// Listens for push notifications.
+ (void)swizzleAppMethods
{
    BOOL swizzlingEnabled = [LPUtils isSwizzlingEnabled];
    
    id appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate && [NSStringFromClass([appDelegate class])
                        rangeOfString:@"AppDelegateProxy"].location != NSNotFound) {
        @try {
            SEL selector = NSSelectorFromString(@"originalAppDelegate");
            IMP imp = [appDelegate methodForSelector:selector];
            id (*func)(id, SEL) = (void *)imp;
            id originalAppDelegate = func(appDelegate, selector);
            if (originalAppDelegate) {
                appDelegate = originalAppDelegate;
            }
        }
        @catch (NSException *exception) {
            // Ignore. Means that app delegate doesn't repsond to the selector.
            // Can't use respondsToSelector since proxies override this method so that
            // it doesn't work for this particular selector.
        }
    }
    
    if (swizzlingEnabled)
    {
        // Detect when registered for push notifications.
        swizzledApplicationDidRegisterRemoteNotifications =
        [LPSwizzle hookInto:@selector(application:didRegisterForRemoteNotificationsWithDeviceToken:)
               withSelector:@selector(leanplum_application:didRegisterForRemoteNotificationsWithDeviceToken:)
                  forObject:[appDelegate class]];
        
        // Detect when registered for user notification types.
        swizzledApplicationDidRegisterUserNotificationSettings =
        [LPSwizzle hookInto:@selector(application:didRegisterUserNotificationSettings:)
               withSelector:@selector(leanplum_application:didRegisterUserNotificationSettings:)
                  forObject:[appDelegate class]];
        
        // Detect when couldn't register for push notifications.
        swizzledApplicationDidFailToRegisterForRemoteNotificationsWithError =
        [LPSwizzle hookInto:@selector(application:didFailToRegisterForRemoteNotificationsWithError:)
               withSelector:@selector(leanplum_application:didFailToRegisterForRemoteNotificationsWithError:)
                  forObject:[appDelegate class]];
        
        // Detect push while app is running.
        SEL applicationDidReceiveRemoteNotificationSelector = @selector(application:didReceiveRemoteNotification:);
        Method applicationDidReceiveRemoteNotificationMethod = class_getInstanceMethod(
                                                                                       [appDelegate class],
                                                                                       applicationDidReceiveRemoteNotificationSelector);
        
        void (^swizzleApplicationDidReceiveRemoteNotification)(void) = ^{
            swizzledApplicationDidReceiveRemoteNotification =
            [LPSwizzle hookInto:applicationDidReceiveRemoteNotificationSelector
                   withSelector:@selector(leanplum_application:
                                          didReceiveRemoteNotification:)
                      forObject:[appDelegate class]];
        };
        
        SEL applicationDidReceiveRemoteNotificationFetchCompletionHandlerSelector =
        @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
        Method applicationDidReceiveRemoteNotificationCompletionHandlerMethod = class_getInstanceMethod(
                                                                                                        [appDelegate class],
                                                                                                        applicationDidReceiveRemoteNotificationFetchCompletionHandlerSelector);
        void (^swizzleApplicationDidReceiveRemoteNotificationFetchCompletionHandler)(void) = ^{
            swizzledApplicationDidReceiveRemoteNotificationWithCompletionHandler =
            [LPSwizzle hookInto:applicationDidReceiveRemoteNotificationFetchCompletionHandlerSelector
                   withSelector:@selector(leanplum_application:
                                          didReceiveRemoteNotification:
                                          fetchCompletionHandler:)
                      forObject:[appDelegate class]];
        };
        
        SEL userNotificationCenterDidReceiveNotificationResponseWithCompletionHandlerSelector =
        @selector(userNotificationCenter:didReceiveNotificationResponse:withCompletionHandler:);
        Method userNotificationCenterDidReceiveNotificationResponseWithCompletionHandlerMethod =
        class_getInstanceMethod([appDelegate class],
                                userNotificationCenterDidReceiveNotificationResponseWithCompletionHandlerSelector);
        void (^swizzleUserNotificationDidReceiveNotificationResponseWithCompletionHandler)(void) =^{
            swizzledUserNotificationCenterDidReceiveNotificationResponseWithCompletionHandler =
            [LPSwizzle hookInto:userNotificationCenterDidReceiveNotificationResponseWithCompletionHandlerSelector
                   withSelector:@selector(leanplum_userNotificationCenter:
                                          didReceiveNotificationResponse:
                                          withCompletionHandler:)
                      forObject:[appDelegate class]];
        };
        
        if (!applicationDidReceiveRemoteNotificationMethod
            && !applicationDidReceiveRemoteNotificationCompletionHandlerMethod) {
            swizzleApplicationDidReceiveRemoteNotification();
            swizzleApplicationDidReceiveRemoteNotificationFetchCompletionHandler();
            if (NSClassFromString(@"UNUserNotificationCenter")) {
                swizzleUserNotificationDidReceiveNotificationResponseWithCompletionHandler();
            }
        } else {
            if (applicationDidReceiveRemoteNotificationMethod) {
                swizzleApplicationDidReceiveRemoteNotification();
            }
            if (applicationDidReceiveRemoteNotificationCompletionHandlerMethod) {
                swizzleApplicationDidReceiveRemoteNotificationFetchCompletionHandler();
            }
            if (NSClassFromString(@"UNUserNotificationCenter")) {
                if (userNotificationCenterDidReceiveNotificationResponseWithCompletionHandlerMethod) {
                    swizzleUserNotificationDidReceiveNotificationResponseWithCompletionHandler();
                }
            }
        }
        
        // Detect local notifications while app is running.
        swizzledApplicationDidReceiveLocalNotification =
        [LPSwizzle hookInto:@selector(application:didReceiveLocalNotification:)
               withSelector:@selector(leanplum_application:didReceiveLocalNotification:)
                  forObject:[appDelegate class]];
    }
    
    // Detect receiving notifications.
    [[NSNotificationCenter defaultCenter]
     addObserverForName:UIApplicationDidFinishLaunchingNotification object:nil queue:nil
     usingBlock:^(NSNotification *notification) {
         if (notification.userInfo) {
             NSDictionary *userInfo = notification.userInfo
             [UIApplicationLaunchOptionsRemoteNotificationKey];
             [[LPActionManager sharedManager] handleNotification:userInfo
                                                      withAction:nil
                                                       appActive:NO
                                               completionHandler:nil];
         }
     }];
}

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token
{
    // Format push token.
    NSString *formattedToken = [self hexadecimalStringFromData:token];
    formattedToken = [[[formattedToken stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
       //ToDo: Implementation of messaging
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
   //ToDo: Implementation of messaging
}

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
   //ToDo: Implementation of messaging
}

#pragma mark - Local Notifications
- (void)listenForLocalNotifications
{
    //ToDo: Implementation of messaging
}

#pragma mark - Delivery

- (NSMutableDictionary *)getMessageImpressionOccurrences:(NSString *)messageId
{
    NSMutableDictionary *occurrences = _messageImpressionOccurrences[messageId];
    if (occurrences) {
        return occurrences;
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *savedValue = [defaults objectForKey:
                                [NSString stringWithFormat:LEANPLUM_DEFAULTS_MESSAGE_IMPRESSION_OCCURRENCES_KEY, messageId]];
    if (savedValue) {
        occurrences = [savedValue mutableCopy];
        _messageImpressionOccurrences[messageId] = occurrences;
    }
    return occurrences;
}

// Increment message impression occurrences.
// The @synchronized insures multiple threads create and increment the same
// dictionary. A corrupt dictionary will cause an NSUserDefaults crash.
- (void)incrementMessageImpressionOccurrences:(NSString *)messageId
{
    @synchronized (_messageImpressionOccurrences) {
        NSMutableDictionary *occurrences = [self getMessageImpressionOccurrences:messageId];
        if (occurrences == nil) {
            occurrences = [NSMutableDictionary dictionary];
            occurrences[@"min"] = @(0);
            occurrences[@"max"] = @(0);
            occurrences[@"0"] = @([[NSDate date] timeIntervalSince1970]);
        } else {
            int min = [occurrences[@"min"] intValue];
            int max = [occurrences[@"max"] intValue];
            max++;
            occurrences[[NSString stringWithFormat:@"%d", max]] =
                    @([[NSDate date] timeIntervalSince1970]);
            if (max - min + 1 > MAX_STORED_OCCURRENCES_PER_MESSAGE) {
                [occurrences removeObjectForKey:[NSString stringWithFormat:@"%d", min]];
                min++;
                occurrences[@"min"] = @(min);
            }
            occurrences[@"max"] = @(max);
        }
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:occurrences
                     forKey:[NSString stringWithFormat:LEANPLUM_DEFAULTS_MESSAGE_IMPRESSION_OCCURRENCES_KEY, messageId]];
    }
}

- (NSInteger)getMessageTriggerOccurrences:(NSString *)messageId
{
    NSNumber *occurrences = _messageTriggerOccurrences[messageId];
    if (occurrences) {
        return [occurrences intValue];
    }
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSInteger savedValue = [defaults integerForKey:
                            [NSString stringWithFormat:LEANPLUM_DEFAULTS_MESSAGE_TRIGGER_OCCURRENCES_KEY, messageId]];
    _messageTriggerOccurrences[messageId] = @(savedValue);
    return savedValue;
}

- (void)incrementMessageTriggerOccurrences:(NSString *)messageId
{
    @synchronized (_messageTriggerOccurrences) {
        NSInteger occurrences = [self getMessageTriggerOccurrences:messageId];
        occurrences++;
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setInteger:occurrences
                      forKey:[NSString stringWithFormat:LEANPLUM_DEFAULTS_MESSAGE_TRIGGER_OCCURRENCES_KEY, messageId]];
        _messageTriggerOccurrences[messageId] = @(occurrences);
    }
}


+ (void)addRegionNamesFromTriggers:(NSDictionary *)triggerConfig toSet:(NSMutableSet *)set
{
    NSArray *triggers = triggerConfig[@"children"];
    for (NSDictionary *trigger in triggers) {
        NSString *subject = trigger[@"subject"];
        if ([subject isEqualToString:@"enterRegion"] ||
            [subject isEqualToString:@"exitRegion"]) {
            [set addObject:trigger[@"noun"]];
        }
    }
}


- (BOOL)matchesLimits:(NSDictionary *)limitConfig
            messageId:(NSString *)messageId
{
    if (![limitConfig isKindOfClass:[NSDictionary class]]) {
        return YES;
    }
    NSArray *limits = limitConfig[@"children"];
    if (!limits.count) {
        return YES;
    }
    NSDictionary *impressionOccurrences = [self getMessageImpressionOccurrences:messageId];
    NSInteger triggerOccurrences = [self getMessageTriggerOccurrences:messageId] + 1;
    for (NSDictionary *limit in limits) {
        NSString *subject = limit[@"subject"];
        NSString *noun = limit[@"noun"];
        NSString *verb = limit[@"verb"];

        // E.g. 5 times per session; 2 times per 7 minutes.
        if ([subject isEqualToString:@"times"]) {
            if (![self matchesLimitTimes:[noun intValue]
                                     per:[[limit[@"objects"] firstObject] intValue]
                               withUnits:verb
                             occurrences:impressionOccurrences
                               messageId:messageId]) {
                return NO;
            }
        
        // E.g. On the 5th occurrence.
        } else if ([subject isEqualToString:@"onNthOccurrence"]) {
            int amount = [noun intValue];
            if (triggerOccurrences != amount) {
                return NO;
            }

        // E.g. Every 5th occurrence.
        } else if ([subject isEqualToString:@"everyNthOccurrence"]) {
            int multiple = [noun intValue];
            if (multiple == 0 || triggerOccurrences % multiple != 0) {
                return NO;
            }
        }
    }
    return YES;
}

- (BOOL)matchesLimitTimes:(int)amount
                      per:(int)time
                withUnits:(NSString *)units
              occurrences:(NSDictionary *)occurrences
                messageId:(NSString *)messageId
{
    int existing = 0;
    if ([units isEqualToString:@"limitSession"]) {
        existing = [_sessionOccurrences[messageId] intValue];
    } else {
        if (occurrences == nil) {
            return YES;
        }
        int min = [occurrences[@"min"] intValue];
        int max = [occurrences[@"max"] intValue];
        if ([units isEqualToString:@"limitUser"]) {
            existing = max - min + 1;
        } else {
            int perSeconds = time;
            if ([units isEqualToString:@"limitMinute"]) {
                perSeconds *= 60;
            } else if ([units isEqualToString:@"limitHour"]) {
                perSeconds *= 3600;
            } else if ([units isEqualToString:@"limitDay"]) {
                perSeconds *= 86400;
            } else if ([units isEqualToString:@"limitWeek"]) {
                perSeconds *= 604800;
            } else if ([units isEqualToString:@"limitMonth"]) {
                perSeconds *= 2592000;
            }
            NSTimeInterval now = [[NSDate date] timeIntervalSince1970];
            int matchedOccurrences = 0;
            for (int i = max; i >= min; i--) {
                NSTimeInterval timeAgo = now -
                        [occurrences[[NSString stringWithFormat:@"%d", i]] doubleValue];
                if (timeAgo > perSeconds) {
                    break;
                }
                matchedOccurrences++;
                if (matchedOccurrences >= amount) {
                    return NO;
                }
            }
        }
    }
    return existing < amount;
}

- (void)recordMessageTrigger:(NSString *)messageId
{
    [self incrementMessageTriggerOccurrences:messageId];
}


#pragma mark - Helper methods
- (NSString *)hexadecimalStringFromData:(NSData *)data
{
    NSUInteger dataLength = data.length;
    if (dataLength == 0) {
        return nil;
    }

    const unsigned char *dataBuffer = data.bytes;
    NSMutableString *hexString  = [NSMutableString stringWithCapacity:(dataLength * 2)];
    for (int i = 0; i < dataLength; ++i) {
        [hexString appendFormat:@"%02x", dataBuffer[i]];
    }
    return [hexString copy];
}

@end
