//
//  LPApiMethods.h
//  Leanplum
//
//  Created by Grace on 6/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LPApiMethodStart,
    LPApiMethodGetVars,
    LPApiMethodSetVars,
    LPApiMethodStop,
    LPApiMethodRestart,
    LPApiMethodTrack,
    LPApiMethodTrackGeofence,
    LPApiMethodAdvance,
    LPApiMethodPauseSession,
    LPApiMethodPauseState,
    LPApiMethodResumeSession,
    LPApiMethodResumeState,
    LPApiMethodMulti,
    LPApiMethodRegisterForDevelopment,
    LPApiMethodSetUserAttributes,
    LPApiMethodSetDeviceAttributes,
    LPApiMethodSetTrafficSourceInfo,
    LPApiMethodUploadFile,
    LPApiMethodDownloadFile,
    LPApiMethodHeartbeat,
    LPApiMethodSaveViewControllerVersion,
    LPApiMethodSaveViewControllerImage,
    LPApiMethodGetViewControllerVersionsList,
    LPApiMethodLog,
    LPApiMethodGetInboxMessages,
    LPApiMethodMarkInboxMessageAsRead,
    LPApiMethodDeleteInboxMessage
} LPApiMethod;

NS_ASSUME_NONNULL_BEGIN

@interface LPApiMethods : NSObject

+ (NSString *)getApiMethod:(LPApiMethod)apiMethodEnum;
+ (NSString *)getHttpMethod:(LPApiMethod)apiMethodEnum;

@end

NS_ASSUME_NONNULL_END
