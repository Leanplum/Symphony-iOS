//
//  NSObject+LeanplumExtension.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/3/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "LeanplumInternal.h"
#import <UserNotifications/UserNotifications.h>


@interface NSObject (LeanplumExtension)

- (void)leanplum_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
- (NSString *)leanplum_createUserNotificationSettingsKey;
- (void)leanplum_application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
- (void)leanplum_application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)leanplum_application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)leanplum_application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
      fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler;
- (void)leanplum_userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
      withCompletionHandler:(void (^)())completionHandler
API_AVAILABLE(ios(10.0)) API_AVAILABLE(ios(10.0));
- (void)leanplum_application:(UIApplication *)application
 didReceiveLocalNotification:(UILocalNotification *)localNotification;
@end
