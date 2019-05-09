//
//  LPTestHelper.h
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 5/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPTestHelper : NSObject

extern NSString *APPLICATION_ID;
extern NSString *DEVELOPMENT_KEY;
extern NSString *PRODUCTION_KEY;

/// host of the api
extern NSString *API_HOST;

/// default dispatch time
extern NSInteger DISPATCH_WAIT_TIME;

+ (void)setup;
+ (void)setup:(NSString *)applicationId withAccessKey:(NSString *)accessKey withDeviceId:(NSString *)deviceId;
+ (void)setupStub:(NSString *)filename;
+ (void)runWithApiHost:(NSString *)host withBlock:(void (^)(void))block;

@end
