//
//  LPTrackGeofenceApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTrackGeofenceApi : NSObject

+ (void) trackWithEvent:(NSString *)event
                  value:(double)value
                   info:(NSString *)info
             parameters:(NSDictionary *)parameters
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;
@end
