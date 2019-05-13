//
//  LPDeviceApi.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@interface LPDeviceApi : NSObject

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wstrict-prototypes"

+ (void) setDeviceAttributes:(NSString *)deviceId withNotificationSettings:(UIUserNotificationSettings *)notificationSettings withPushToken:(NSString *)pushToken
                     success:(void (^)(void))success
                     failure:(void (^)(NSError *error))failure;
#pragma clang diagnostic pop

@end
