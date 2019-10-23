//
//  Leanplum.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Leanplum.
FOUNDATION_EXPORT double LeanplumVersionNumber;

//! Project version string for Leanplum.
FOUNDATION_EXPORT const unsigned char LeanplumVersionString[];


@interface Leanplum : NSObject

/**
 * @defgroup _ Callback Blocks
 * Those blocks are used when you define callbacks.
 * @{
 */
typedef void (^LeanplumStartBlock)(BOOL success);
typedef void (^LeanplumHandleNotificationBlock)(void);
typedef void (^LeanplumShouldHandleNotificationBlock)(NSDictionary *userInfo, LeanplumHandleNotificationBlock response);
typedef NSUInteger LeanplumUIBackgroundFetchResult; // UIBackgroundFetchResult
typedef void (^LeanplumFetchCompletionBlock)(LeanplumUIBackgroundFetchResult result);
typedef void (^LeanplumPushSetupBlock)(void);
/**@}*/

 /*
 * Must call either this or {@link setAppId:withProductionKey:}
 * before issuing any calls to the API, including start.
 * @param appId Your app ID.
 * @param accessKey Your development key.
 */
+ (void)setAppId:(NSString *)appId withDevelopmentKey:(NSString *)accessKey;

/**
 * Must call either this or {@link Leanplum::setAppId:withDevelopmentKey:}
 * before issuing any calls to the API, including start.
 * @param appId Your app ID.
 * @param accessKey Your production key.
 */
+ (void)setAppId:(NSString *)appId withProductionKey:(NSString *)accessKey;

/**@}*/


/**
 * Optional. Sets the API server. The API path is of the form http[s]://hostname/servletName
 * @param hostName The name of the API host, such as api.leanplum.com
 * @param servletName The name of the API servlet, such as api
 * @param ssl Whether to use SSL
 */
+ (void)setApiHostName:(NSString *)hostName withServletName:(NSString *)servletName usingSsl:(BOOL)ssl;

/** Devices **/
/**
 * Sets a custom device ID. For example, you may want to pass the advertising ID to do attribution.
 * By default, the device ID is the identifier for vendor.
 */
+ (void)setDeviceId:(NSString *)deviceId;

/**
 * By default, Leanplum reports the version of your app using CFBundleVersion, which
 * can be used for reporting and targeting on the Leanplum dashboard.
 * If you wish to use CFBundleShortVersionString or any other string as the version,
 * you can call this before your call to [Leanplum start]
 */
+ (void)setAppVersion:(NSString *)appVersion;

/**
 * Returns the deviceId in the current Leanplum session. This should only be called after
 * [Leanplum start].
 */
+ (NSString *)deviceId;

/**
 * @{
 * Call this when your application starts.
 * This will initiate a call to Leanplum's servers to get the values
 * of the variables used in your app.
 */

+ (void)start;
+ (void)startWithResponseHandler:(LeanplumStartBlock)response;
+ (void)startWithUserAttributes:(NSDictionary *)attributes;
+ (void)startWithUserId:(NSString *)userId;
+ (void)startWithUserId:(NSString *)userId responseHandler:(LeanplumStartBlock)response;
+ (void)startWithUserId:(NSString *)userId userAttributes:(NSDictionary *)attributes;
+ (void)startWithUserId:(NSString *)userId
         userAttributes:(NSDictionary *)attributes
            withSuccess:(void (^)(void))success
            withFailure:(void (^)(NSError *error))failure;

/**
 * Returns whether or not Leanplum has finished starting and the device is registered
 * as a developer.
 */
+ (BOOL)hasStartedAndRegisteredAsDeveloper;
/**@}*/

/**
 * Block to call when the start call finishes, and variables are returned
 * back from the server. Calling this multiple times will call each block
 * in succession.
 */
+ (void)onStartResponse:(LeanplumStartBlock)block;

/**
 * Types of location accuracy. Higher value implies better accuracy.
 */
typedef enum {
    LPLocationAccuracyIP = 0,
    LPLocationAccuracyCELL = 1,
    LPLocationAccuracyGPS = 2
} LPLocationAccuracyType;


/**
 * Optional. Adjusts the network timeouts.
 * The default timeout is 10 seconds for requests, and 15 seconds for file downloads.
 * @{
 */
+ (void)setNetworkTimeoutSeconds:(int)seconds;
+ (void)setNetworkTimeoutSeconds:(int)seconds forDownloads:(int)downloadSeconds;

/**
 * Sets additional user attributes after the session has started.
 * Variables retrieved by start won't be targeted based on these attributes, but
 * they will count for the current session for reporting purposes.
 * Only those attributes given in the dictionary will be updated. All other
 * attributes will be preserved.
 */
+ (void)setUserAttributes:(NSDictionary *)attributes
              withSuccess:(void (^)(void))success
              withFailure:(void (^)(NSError *error))failure;

/**
 * Updates a user ID after session start.
 */
+ (void)setUserId:(NSString *)userId
      withSuccess:(void (^)(void))success
      withFailure:(void (^)(NSError *error))failure;

/**
 * Updates a user ID after session start with a dictionary of user attributes.
 */
+ (void)setUserId:(NSString *)userId withUserAttributes:(NSDictionary *)attributes
      withSuccess:(void (^)(void))success
      withFailure:(void (^)(NSError *error))failure;

/**
 * Pauses the current state.
 * You can use this if your game has a "pause" mode. You shouldn't call it
 * when someone switches out of your app because that's done automatically.
 */
+ (void)pauseState;

/**
 * Resumes the current state.
 */
+ (void)resumeState;

/**
 * Handles a push notification for apps that use Background Notifications.
 * Without background notifications, Leanplum handles them automatically.
 * Deprecated. Leanplum calls handleNotification automatically now. If you
 * implement application:didReceiveRemoteNotification:fetchCompletionHandler:
 * in your app delegate, you should remove any calls to [Leanplum handleNotification]
 * and call the completion handler yourself.
 */
+ (void)handleNotification:(NSDictionary *)userInfo
    fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler
    __attribute__((deprecated("Leanplum calls handleNotification automatically now. If you "
        "implement application:didReceiveRemoteNotification:fetchCompletionHandler: in your app "
        "delegate, you should remove any calls to [Leanplum handleNotification] and call the "
        "completion handler yourself.")));

+ (void)didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)token;
+ (void)didFailToRegisterForRemoteNotificationsWithError:(NSError *)error;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wstrict-prototypes"
+ (void)didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings;
#pragma clang diagnostic pop
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo;
+ (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler;
+ (void)didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler API_AVAILABLE(ios(10.0));
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wstrict-prototypes"
+ (void)didReceiveLocalNotification:(UILocalNotification *)localNotification;
#pragma clang diagnostic pop


@end
