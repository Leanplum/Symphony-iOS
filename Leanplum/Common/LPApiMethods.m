//
//  LPApiMethods.m
//  Leanplum
//
//  Created by Grace on 6/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPApiMethods.h"

@implementation LPApiMethods

+ (NSString *)getApiMethod:(LPApiMethod)apiMethodEnum {
    NSString *apiMethod = nil;
    switch(apiMethodEnum) {
        case LPApiMethodStart:
            apiMethod = @"start";
            break;
        case LPApiMethodGetVars:
            apiMethod = @"getVars";
            break;
        case LPApiMethodSetVars:
            apiMethod = @"setVars";
            break;
        case LPApiMethodStop:
            apiMethod = @"stop";
            break;
        case LPApiMethodRestart:
            apiMethod = @"restart";
            break;
        case LPApiMethodTrack:
            apiMethod = @"track";
            break;
        case LPApiMethodTrackGeofence:
            apiMethod = @"trackGeofence";
            break;
        case LPApiMethodAdvance:
            apiMethod = @"advance";
            break;
        case LPApiMethodPauseSession:
            apiMethod = @"pauseSession";
            break;
        case LPApiMethodPauseState:
            apiMethod = @"pauseState";
            break;
        case LPApiMethodResumeSession:
            apiMethod = @"resumeSession";
            break;
        case LPApiMethodResumeState:
            apiMethod = @"resumeState";
            break;
        case LPApiMethodMulti:
            apiMethod = @"multi";
            break;
        case LPApiMethodRegisterForDevelopment:
            apiMethod = @"registerDevice";
            break;
        case LPApiMethodSetUserAttributes:
            apiMethod = @"setUserAttributes";
            break;
        case LPApiMethodSetDeviceAttributes:
            apiMethod = @"setDeviceAttributes";
            break;
        case LPApiMethodSetTrafficSourceInfo:
            apiMethod = @"setTrafficSourceInfo";
            break;
        case LPApiMethodUploadFile:
            apiMethod = @"uploadFile";
            break;
        case LPApiMethodDownloadFile:
            apiMethod = @"downloadFile";
            break;
        case LPApiMethodHeartbeat:
            apiMethod = @"heartbeat";
            break;
        case LPApiMethodSaveViewControllerVersion:
            apiMethod = @"saveInterface";
            break;
        case LPApiMethodSaveViewControllerImage:
            apiMethod = @"saveInterfaceImage";
            break;
        case LPApiMethodGetViewControllerVersionsList:
            apiMethod = @"getViewControllerVersionsList";
            break;
        case LPApiMethodLog:
            apiMethod = @"log";
            break;
        case LPApiMethodGetInboxMessages:
            apiMethod = @"getNewsfeedMessages";
            break;
        case LPApiMethodMarkInboxMessageAsRead:
            apiMethod = @"markNewsfeedMessageAsRead";
            break;
        case LPApiMethodDeleteInboxMessage:
            apiMethod = @"deleteNewsfeedMessage";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected api method"];
    }
    return apiMethod;
}

+ (NSString *)getHttpMethod:(LPApiMethod)apiMethodEnum {
    NSString *httpMethod = nil;
    switch(apiMethodEnum) {
        case LPApiMethodStart:
        case LPApiMethodGetVars:
        case LPApiMethodSetVars:
        case LPApiMethodStop:
        case LPApiMethodRestart:
        case LPApiMethodTrack:
        case LPApiMethodTrackGeofence:
        case LPApiMethodAdvance:
        case LPApiMethodPauseSession:
        case LPApiMethodPauseState:
        case LPApiMethodResumeSession:
        case LPApiMethodResumeState:
        case LPApiMethodMulti:
        case LPApiMethodRegisterForDevelopment:
        case LPApiMethodSetUserAttributes:
        case LPApiMethodSetDeviceAttributes:
        case LPApiMethodSetTrafficSourceInfo:
        case LPApiMethodUploadFile:
        case LPApiMethodDownloadFile:
        case LPApiMethodHeartbeat:
        case LPApiMethodSaveViewControllerVersion:
        case LPApiMethodSaveViewControllerImage:
        case LPApiMethodGetViewControllerVersionsList:
        case LPApiMethodLog:
        case LPApiMethodGetInboxMessages:
        case LPApiMethodMarkInboxMessageAsRead:
        case LPApiMethodDeleteInboxMessage:
            httpMethod = @"POST";
            break;
        default:
            [NSException raise:NSGenericException format:@"Unexpected api method"];
    }
    return httpMethod;
}

@end
