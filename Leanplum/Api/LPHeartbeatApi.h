//
//  LPHeartbeatApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPHeartbeatApi : NSObject

+ (void) heartbeatWithParameters:(NSDictionary *)parameters
                         success:(void (^)(void))success
                         failure:(void (^)(NSError *error))failure
                         isMulti:(BOOL)isMulti;
@end
