//
//  LPTrackGeofenceApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LPEnterRegion,
    LPExitRegion
} LPGeofenceEventType;

@interface LPTrackGeofenceApi : NSObject

+ (void) trackGeofenceEvent:(LPGeofenceEventType)event
                       info:(NSString *)info
                 parameters:(NSDictionary *)parameters
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure;
@end
