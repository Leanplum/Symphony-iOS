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

@interface LPApiConstants : NSObject

@property(strong, nonatomic) NSString *apiHostName;
@property(strong, nonatomic) NSString *apiServlet;
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
@property(assign, nonatomic) BOOL isTestMode;
@property(assign, nonatomic) BOOL isMulti;
@property(assign, nonatomic) BOOL isInPermanentFailureState;
@property(assign, nonatomic) BOOL verboseLoggingInDevelopmentMode;
@property(strong, nonatomic) NSString *client;
@property(strong, nonatomic) NSString *sdkVersion;
@property(assign, nonatomic) BOOL networkActivityIndicatorEnabled;
@property(assign, nonatomic) BOOL isLocationCollectionEnabled;
@property(assign, nonatomic) BOOL isInboxImagePrefetchingEnabled;
// Counts how many user code blocks we're inside, to silence exceptions.
// This is used by LP_BEGIN_USER_CODE and LP_END_USER_CODE, which are threadsafe.
@property(assign, nonatomic) int userCodeBlocks;

+ (LPApiConstants *)sharedState;

@end

#pragma mark - Api Infrastructure
OBJC_EXPORT NSString *LP_USER_AGENT;
OBJC_EXPORT NSString *LP_ACCEPT_LANGUAGE;
OBJC_EXPORT NSString *LP_ACCEPT_ENCODING;
OBJC_EXPORT NSString *LP_EN_US;
