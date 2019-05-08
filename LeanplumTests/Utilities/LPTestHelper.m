//
//  LPTestHelper.m
//  LeanplumTests
//
//  Created by Hrishikesh Amravatkar on 5/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPTestHelper.h"
#import "LPApiConstants.h"

NSString *APPLICATION_ID = @"app_ve9UCNlqI8dy6Omzfu1rEh6hkWonNHVZJIWtLLt6aLs";
NSString *DEVELOPMENT_KEY = @"dev_cKF5HMpLGqhbovlEGMKjgTuf8AHfr2Jar6rrnNhtzQ0";
NSString *PRODUCTION_KEY = @"prod_XYpURdwPAaxJyYLclXNfACe9Y8hs084dBx2pB8wOnqU";

NSString *API_HOST = @"api.leanplum.com";

NSInteger DISPATCH_WAIT_TIME = 4;


@implementation LPTestHelper

+ (void)runWithApiHost:(NSString *)host withBlock:(void (^)(void))block {
    NSString *oldHost = [[LPApiConstants sharedState] apiHostName];
    [LPApiConstants sharedState].apiHostName = host;
    @try {
        block();
    } @finally {
        [LPApiConstants sharedState].apiHostName = oldHost;
    }
}

@end

