//
//  LPApiConstants.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPApiConstants.h"

@implementation LPApiConstants

+ (LPApiConstants *)sharedState {
    static LPApiConstants *sharedLPConstantsState = nil;
    static dispatch_once_t onceLPConstantsStateToken;
    dispatch_once(&onceLPConstantsStateToken, ^{
        sharedLPConstantsState = [[self alloc] init];
    });
    return sharedLPConstantsState;
}

- (id)init {
    if (self = [super init]) {
        //_apiHostName = @"api.leanplum.com";
        _apiHostName = @"blah.leanplum.com";
        _apiServlet = @"api";
        _apiSSL = YES;
        _socketHost = @"dev.leanplum.com";
        _socketPort = 443;
        _networkTimeoutSeconds = 10;
        _networkTimeoutSecondsForDownloads = 15;
        _syncNetworkTimeoutSeconds = 5;
        _checkForUpdatesInDevelopmentMode = YES;
        _isDevelopmentModeEnabled = NO;
        _loggingEnabled = NO;
        _canDownloadContentMidSessionInProduction = NO;
        _isTestMode = NO;
        _isInPermanentFailureState = NO;
        _verboseLoggingInDevelopmentMode = NO;
        _networkActivityIndicatorEnabled = YES;
        _client = LEANPLUM_CLIENT;
        _sdkVersion = LEANPLUM_SDK_VERSION;
        _isLocationCollectionEnabled = YES;
        _isInboxImagePrefetchingEnabled = YES;
    }
    return self;
}

@end

#pragma mark - API calls constants

NSString *LP_API_METHOD_START = @"start";
NSString *LP_API_METHOD_GET_VARS = @"getVars";
NSString *LP_API_METHOD_SET_VARS = @"setVars";
NSString *LP_API_METHOD_STOP = @"stop";
NSString *LP_API_METHOD_RESTART = @"restart";
NSString *LP_API_METHOD_TRACK = @"track";
NSString *LP_API_METHOD_TRACK_GEOFENCE = @"trackGeofence";
NSString *LP_API_METHOD_ADVANCE = @"advance";
NSString *LP_API_METHOD_PAUSE_SESSION = @"pauseSession";
NSString *LP_API_METHOD_PAUSE_STATE = @"pauseState";
NSString *LP_API_METHOD_RESUME_SESSION = @"resumeSession";
NSString *LP_API_METHOD_RESUME_STATE = @"resumeState";
NSString *LP_API_METHOD_MULTI = @"multi";
NSString *LP_API_METHOD_REGISTER_FOR_DEVELOPMENT = @"registerDevice";
NSString *LP_API_METHOD_SET_USER_ATTRIBUTES = @"setUserAttributes";
NSString *LP_API_METHOD_SET_DEVICE_ATTRIBUTES = @"setDeviceAttributes";
NSString *LP_API_METHOD_SET_TRAFFIC_SOURCE_INFO = @"setTrafficSourceInfo";
NSString *LP_API_METHOD_UPLOAD_FILE = @"uploadFile";
NSString *LP_API_METHOD_DOWNLOAD_FILE = @"downloadFile";
NSString *LP_API_METHOD_HEARTBEAT = @"heartbeat";
NSString *LP_API_METHOD_SAVE_VIEW_CONTROLLER_VERSION = @"saveInterface";
NSString *LP_API_METHOD_SAVE_VIEW_CONTROLLER_IMAGE = @"saveInterfaceImage";
NSString *LP_API_METHOD_GET_VIEW_CONTROLLER_VERSIONS_LIST = @"getViewControllerVersionsList";
NSString *LP_API_METHOD_LOG = @"log";
NSString *LP_API_METHOD_GET_INBOX_MESSAGES = @"getNewsfeedMessages";
NSString *LP_API_METHOD_MARK_INBOX_MESSAGE_AS_READ = @"markNewsfeedMessageAsRead";
NSString *LP_API_METHOD_DELETE_INBOX_MESSAGE = @"deleteNewsfeedMessage";
