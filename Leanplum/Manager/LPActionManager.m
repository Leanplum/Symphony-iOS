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
#import "LPDeviceApi.h"
#import "LPAPIConfig.h"
#import <objc/runtime.h>
#import <objc/message.h>


@interface LPActionManager()

@property (nonatomic, strong) NSString *notificationHandled;
@property (nonatomic, strong) NSDate *notificationHandledTime;
@property (nonatomic, strong) LeanplumShouldHandleNotificationBlock shouldHandleNotification;

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

// Handles the notification.
// Makes sure the data is loaded, and then displays the notification.
- (void)handleNotification:(NSDictionary *)userInfo
                withAction:(NSString *)action
                 appActive:(BOOL)active
         completionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    //ToDo:
     completionHandler(UIBackgroundFetchResultNewData);
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
    //ToDo: Notifications data
    [self handleNotification:userInfo
                  withAction:action
                   appActive:YES
           completionHandler:completionHandler];
    return;
}

- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler
{
    LP_TRY
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
    LP_END_TRY
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
    LP_TRY
    // Format push token.
    NSString *formattedToken = [self hexadecimalStringFromData:token];
    formattedToken = [[[formattedToken stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
       // Send push token if we don't have one and when the token changed.
       // We no longer send in start's response because saved push token will be send in start too.
       NSString *tokenKey = [Leanplum pushTokenKey];
       NSString *existingToken = [[NSUserDefaults standardUserDefaults] stringForKey:tokenKey];
       if (!existingToken || ![existingToken isEqualToString:formattedToken]) {
           
           [[NSUserDefaults standardUserDefaults] setObject:formattedToken forKey:tokenKey];
           [[NSUserDefaults standardUserDefaults] synchronize];
          
           [LPDeviceApi setDeviceId:[LPAPIConfig sharedConfig].deviceId withDeviceAttributes:@{LP_PARAM_DEVICE_PUSH_TOKEN: formattedToken} success:^ {
               NSLog(@"Device Registered");
           } failure:^(NSError *error) {
            NSLog(@"Device Registration failed!");
           } isMulti:YES];
       }
    LP_END_TRY
}

- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
   //ToDo: Implementation of messaging
}

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
   //ToDo: Implementation of messaging
    //[self leanplum_disableAskToAsk];
    [self sendUserNotificationSettingsIfChanged:notificationSettings];
}

#pragma mark - Local Notifications
- (void)listenForLocalNotifications
{
    //ToDo: Implementation of messaging
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
        NSString *tokenKey = [Leanplum pushTokenKey];
        NSString *existingToken = [[NSUserDefaults standardUserDefaults] stringForKey:tokenKey];
        NSMutableDictionary *params = [@{
                LP_PARAM_DEVICE_USER_NOTIFICATION_TYPES: types,
                LP_PARAM_DEVICE_USER_NOTIFICATION_CATEGORIES:
                      [LPJSON stringFromJSON:sortedCategories] ?: @""} mutableCopy];
        if (existingToken) {
            params[LP_PARAM_DEVICE_PUSH_TOKEN] = existingToken;
        }
        [Leanplum onStartResponse:^(BOOL success) {
            [LPDeviceApi setDeviceId:[LPAPIConfig sharedConfig].deviceId
                withDeviceAttributes:params
                             success:^{
                NSLog(@"setDevice success");
            } failure:^(NSError *error) {
                NSLog(@"setDevice failure. %@", error);
            }
            isMulti:YES];
        }];
    }
}

- (NSString *)leanplum_createUserNotificationSettingsKey
{
    return [NSString stringWithFormat:
            LEANPLUM_DEFAULTS_USER_NOTIFICATION_SETTINGS_KEY,
            [LPAPIConfig sharedConfig].appId, [LPAPIConfig sharedConfig].userId, [LPAPIConfig sharedConfig].deviceId];
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
