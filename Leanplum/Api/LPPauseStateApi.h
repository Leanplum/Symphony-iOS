//
//  LPPauseStateApi.h
//  Leanplum
//
//  Created by Grace on 5/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPauseStateApi : NSObject

+ (void) pauseStateWithParameters:(NSDictionary *)parameters
                          success:(void (^)(void))success
                          failure:(void (^)(NSError *error))failure
                          isMulti:(BOOL)isMulti;

@end

