//
//  LeanplumInternal.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "Leanplum.h"
#import "LPConstants.h"
#import "LPJSON.h"
#import "LPInternalState.h"

@interface Leanplum ()

typedef void (^LeanplumStartIssuedBlock)(void);
typedef void (^LeanplumEventsChangedBlock)(void);
typedef void (^LeanplumHandledBlock)(BOOL success);

+ (void)throwError:(NSString *)reason;

+ (void)onHasStartedAndRegisteredAsDeveloper;

+ (void)pause;
+ (void)resume;

@end



