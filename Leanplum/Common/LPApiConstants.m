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
        _apiHostName = @"api.leanplum.com";
        _apiServlet = @"api";
        _apiSSL = YES;
        _socketHost = @"dev.leanplum.com";
        _socketPort = 443;
        _networkTimeoutSeconds = 20;
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

#pragma mark - Api Infrastructure
NSString *LP_USER_AGENT = @"User-Agent";
NSString *LP_ACCEPT_LANGUAGE = @"Accept-Language";
NSString *LP_ACCEPT_ENCODING = @"Accept-Encoding";
NSString *LP_EN_US = @"en-us";
