//
//  LPApiConstants.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPApiConstants : NSObject

@end

#pragma mark - The rest of the Leanplum Api methods

OBJC_EXPORT NSString *LP_API_METHOD_START;
OBJC_EXPORT NSString *LP_API_METHOD_GET_VARS;
OBJC_EXPORT NSString *LP_API_METHOD_SET_VARS;
OBJC_EXPORT NSString *LP_API_METHOD_STOP;
OBJC_EXPORT NSString *LP_API_METHOD_RESTART;
OBJC_EXPORT NSString *LP_API_METHOD_TRACK;
OBJC_EXPORT NSString *LP_API_METHOD_TRACK_GEOFENCE;
OBJC_EXPORT NSString *LP_API_METHOD_ADVANCE;
OBJC_EXPORT NSString *LP_API_METHOD_PAUSE_SESSION;
OBJC_EXPORT NSString *LP_API_METHOD_PAUSE_STATE;
OBJC_EXPORT NSString *LP_API_METHOD_RESUME_SESSION;
OBJC_EXPORT NSString *LP_API_METHOD_RESUME_STATE;
OBJC_EXPORT NSString *LP_API_METHOD_MULTI;
OBJC_EXPORT NSString *LP_API_METHOD_REGISTER_FOR_DEVELOPMENT;
OBJC_EXPORT NSString *LP_API_METHOD_SET_USER_ATTRIBUTES;
OBJC_EXPORT NSString *LP_API_METHOD_SET_DEVICE_ATTRIBUTES;
OBJC_EXPORT NSString *LP_API_METHOD_SET_TRAFFIC_SOURCE_INFO;
OBJC_EXPORT NSString *LP_API_METHOD_UPLOAD_FILE;
OBJC_EXPORT NSString *LP_API_METHOD_DOWNLOAD_FILE;
OBJC_EXPORT NSString *LP_API_METHOD_HEARTBEAT;
OBJC_EXPORT NSString *LP_API_METHOD_SAVE_VIEW_CONTROLLER_VERSION;
OBJC_EXPORT NSString *LP_API_METHOD_SAVE_VIEW_CONTROLLER_IMAGE;
OBJC_EXPORT NSString *LP_API_METHOD_GET_VIEW_CONTROLLER_VERSIONS_LIST;
OBJC_EXPORT NSString *LP_API_METHOD_LOG;
OBJC_EXPORT NSString *LP_API_METHOD_GET_INBOX_MESSAGES;
OBJC_EXPORT NSString *LP_API_METHOD_MARK_INBOX_MESSAGE_AS_READ;
OBJC_EXPORT NSString *LP_API_METHOD_DELETE_INBOX_MESSAGE;

