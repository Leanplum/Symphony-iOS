//
//  LPInternalState.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/26/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPInternalState : NSObject

@property(strong, nonatomic) NSMutableArray *startIssuedBlocks;
@property(assign, nonatomic) BOOL calledStart, hasStarted, hasStartedAndRegisteredAsDeveloper,
startSuccessful, issuedStart;
@property(strong, nonatomic) NSString *appVersion;
+ (LPInternalState *)sharedState;

@end
