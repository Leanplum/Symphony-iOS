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

@end