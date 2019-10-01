//
//  LPLog.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPLogging : NSObject

typedef enum {
    LPError,
    LPWarning,
    LPInfo,
    LPVerbose,
    LPInternal,
    LPDebug
} LPLogType;


void LPLog(LPLogType type, NSString* format, ...);

@end
