//
//  NSObject+LeanplumExtension.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/3/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "NSObject+LeanplumExtension.h"
#import "LPSwizzle.h"
#import "LPActionManager.h"
#import "LPAPIConfig.h"
#import <objc/runtime.h>
#import <objc/message.h>


@implementation NSObject (LeanplumExtension)

- (void)leanplum_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [[LPActionManager sharedManager] didRegisterForRemoteNotificationsWithDeviceToken:deviceToken];

    // Call overridden method.
    if (swizzledApplicationDidRegisterRemoteNotifications && [self respondsToSelector:@selector(leanplum_application:didRegisterForRemoteNotificationsWithDeviceToken:)]) {
        [self performSelector:@selector(leanplum_application:didRegisterForRemoteNotificationsWithDeviceToken:)
                   withObject:application withObject:deviceToken];
    }
}

- (NSString *)leanplum_createUserNotificationSettingsKey
{
    return [NSString stringWithFormat:
            LEANPLUM_DEFAULTS_USER_NOTIFICATION_SETTINGS_KEY,
            [LPAPIConfig sharedConfig].appId, [LPAPIConfig sharedConfig].userId, [LPAPIConfig sharedConfig].deviceId];
}

- (void)leanplum_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    [[LPActionManager sharedManager] didRegisterUserNotificationSettings:notificationSettings];

    // Call overridden method.
    if (swizzledApplicationDidRegisterUserNotificationSettings &&
        [self respondsToSelector:@selector(leanplum_application:didRegisterUserNotificationSettings:)]) {
        [self performSelector:@selector(leanplum_application:didRegisterUserNotificationSettings:)
                   withObject:application withObject:notificationSettings];
    }
}

- (void)leanplum_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    [[LPActionManager sharedManager] didFailToRegisterForRemoteNotificationsWithError:error];

    // Call overridden method.
    if (swizzledApplicationDidFailToRegisterForRemoteNotificationsWithError &&
        [self respondsToSelector:@selector(leanplum_application:didFailToRegisterForRemoteNotificationsWithError:)]) {
        [self performSelector:@selector(leanplum_application:didFailToRegisterForRemoteNotificationsWithError:)
                   withObject:application withObject:error];
    }
}

- (void)leanplum_application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                                       withAction:nil
                                           fetchCompletionHandler:nil];

    // Call overridden method.
    if (swizzledApplicationDidReceiveRemoteNotification && [self respondsToSelector:@selector(leanplum_application:didReceiveRemoteNotification:)]) {
        [self performSelector:@selector(leanplum_application:didReceiveRemoteNotification:)
                   withObject:application withObject:userInfo];
    }
}

- (void)leanplum_application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
{
    LPInternalState *state = [LPInternalState sharedState];
    state.calledHandleNotification = NO;
    LeanplumFetchCompletionBlock leanplumCompletionHandler;

    // Call overridden method.
    if (swizzledApplicationDidReceiveRemoteNotificationWithCompletionHandler && [self respondsToSelector:@selector(leanplum_application:didReceiveRemoteNotification:fetchCompletionHandler:)]) {
        leanplumCompletionHandler = nil;
        [self leanplum_application:application didReceiveRemoteNotification:userInfo fetchCompletionHandler:completionHandler];
    } else {
        leanplumCompletionHandler = completionHandler;
    }

    // Prevents handling the notification twice if the original method calls handleNotification
    // explicitly.
    if (!state.calledHandleNotification) {
        [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                                           withAction:nil
                                               fetchCompletionHandler:leanplumCompletionHandler];
    }
    state.calledHandleNotification = NO;
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (void)leanplum_userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
      withCompletionHandler:(void (^)())completionHandler
API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0)){

    // Call overridden method.
    SEL selector = @selector(leanplum_userNotificationCenter:didReceiveNotificationResponse:
                             withCompletionHandler:);

    if (swizzledUserNotificationCenterDidReceiveNotificationResponseWithCompletionHandler &&
        [self respondsToSelector:selector]) {
        [self leanplum_userNotificationCenter:center
               didReceiveNotificationResponse:response
                        withCompletionHandler:completionHandler];
    }
    
    [[LPActionManager sharedManager] didReceiveNotificationResponse:response withCompletionHandler:completionHandler];
}
#pragma clang diagnostic pop

- (void)leanplum_application:(UIApplication *)application
 didReceiveLocalNotification:(UILocalNotification *)localNotification
{
    NSDictionary *userInfo = [localNotification userInfo];

    [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                                       withAction:nil
                                           fetchCompletionHandler:nil];

    if (swizzledApplicationDidReceiveLocalNotification &&
        [self respondsToSelector:@selector(leanplum_application:didReceiveLocalNotification:)]) {
        [self performSelector:@selector(leanplum_application:didReceiveLocalNotification:)
                   withObject:application withObject:localNotification];
    }
}

@end
