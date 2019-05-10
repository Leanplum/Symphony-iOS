//
//  LPApiConstants.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LEANPLUM_SDK_VERSION @"2.4.1"
#define LEANPLUM_CLIENT @"ios"

@interface LPApiConstants : NSObject {
    NSString *_apiHostName;
    NSString *_apiServlet;
    BOOL _apiSSL;
    NSString *_socketHost;
    int _socketPort;
    int _networkTimeoutSeconds;
    int _networkTimeoutSecondsForDownloads;
    int _syncNetworkTimeoutSeconds;
    BOOL _checkForUpdatesInDevelopmentMode;
    BOOL _isDevelopmentModeEnabled;
    BOOL _loggingEnabled;
    BOOL _canDownloadContentMidSessionInProduction;
    BOOL _isTestMode;
    BOOL _isInPermanentFailureState;
    BOOL _verboseLoggingInDevelopmentMode;
    BOOL _networkActivityIndicatorEnabled;
    NSString *_client;
    NSString *_sdkVersion;
    // Counts how many user code blocks we're inside, to silence exceptions.
    // This is used by LP_BEGIN_USER_CODE and LP_END_USER_CODE, which are threadsafe.
    int _userCodeBlocks;
}

@property(strong, nonatomic) NSString *apiHostName;
@property(strong, nonatomic) NSString *socketHost;
@property(assign, nonatomic) int socketPort;
@property(assign, nonatomic) BOOL apiSSL;
@property(assign, nonatomic) int networkTimeoutSeconds;
@property(assign, nonatomic) int networkTimeoutSecondsForDownloads;
@property(assign, nonatomic) int syncNetworkTimeoutSeconds;
@property(assign, nonatomic) BOOL checkForUpdatesInDevelopmentMode;
@property(assign, nonatomic) BOOL isDevelopmentModeEnabled;
@property(assign, nonatomic) BOOL loggingEnabled;
@property(assign, nonatomic) BOOL canDownloadContentMidSessionInProduction;
@property(strong, nonatomic) NSString *apiServlet;
@property(assign, nonatomic) BOOL isTestMode;
@property(assign, nonatomic) BOOL isInPermanentFailureState;
@property(assign, nonatomic) BOOL verboseLoggingInDevelopmentMode;
@property(strong, nonatomic) NSString *client;
@property(strong, nonatomic) NSString *sdkVersion;
@property(assign, nonatomic) BOOL networkActivityIndicatorEnabled;
@property(assign, nonatomic) BOOL isLocationCollectionEnabled;
@property(assign, nonatomic) BOOL isInboxImagePrefetchingEnabled;

+ (LPApiConstants *)sharedState;

@end

#pragma mark - Api Infrastructure
OBJC_EXPORT NSString *LP_USER_AGENT;
OBJC_EXPORT NSString *LP_ACCEPT_LANGUAGE;
OBJC_EXPORT NSString *LP_ACCEPT_ENCODING;
OBJC_EXPORT NSString *LP_EN_US;


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

