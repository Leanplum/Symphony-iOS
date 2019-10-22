//
//  LPActionManager.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/3/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "Leanplum.h"

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>


static BOOL swizzledApplicationDidRegisterRemoteNotifications = NO;
static BOOL swizzledApplicationDidRegisterUserNotificationSettings = NO;
static BOOL swizzledApplicationDidFailToRegisterForRemoteNotificationsWithError = NO;
static BOOL swizzledApplicationDidReceiveRemoteNotification = NO;
static BOOL swizzledApplicationDidReceiveRemoteNotificationWithCompletionHandler = NO;
static BOOL swizzledApplicationDidReceiveLocalNotification = NO;
static BOOL swizzledUserNotificationCenterDidReceiveNotificationResponseWithCompletionHandler = NO;

typedef enum {
    kLeanplumActionFilterForeground = 0b1,
    kLeanplumActionFilterBackground = 0b10,
    kLeanplumActionFilterAll = 0b11
} LeanplumActionFilter;

@interface LPActionManager : NSObject

+ (LPActionManager*) sharedManager;

#pragma mark - Push Notifications

- (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token;
- (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler;
- (void)didReceiveNotificationResponse:(UNNotificationResponse *)response
                 withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wstrict-prototypes"
- (void)didReceiveLocalNotification:(UILocalNotification *)localNotification;

- (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;

#pragma clang diagnostic pop

- (void)setShouldHandleNotification:(LeanplumShouldHandleNotificationBlock)block;
- (void)sendUserNotificationSettingsIfChanged:(UIUserNotificationSettings *)notificationSettings;

- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
                          withAction:(NSString *)action
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler;
@end

