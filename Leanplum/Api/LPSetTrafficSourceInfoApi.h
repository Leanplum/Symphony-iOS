//
//  LPSetTrafficSourceInfoApi.h
//  Leanplum
//
//  Created by Grace on 5/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPSetTrafficSourceInfoApi : NSObject

+ (void) setTrafficSourceInfoWithInfo:(NSDictionary *)info
                       withParameters:(NSDictionary *)parameters
                              success:(void (^)(void))success
                              failure:(void (^)(NSError *error))failure
                              isMulti:(BOOL)isMulti;

@end

