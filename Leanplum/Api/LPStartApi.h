//
//  LPStartApi.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 7/10/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPStartResponse.h"

@interface LPStartApi : NSObject

+ (void) startWithParameters:(NSDictionary *)parameters
                    success:(void (^)(LPStartResponse *))success
                    failure:(void (^)(NSError *error))failure
                    isMulti:(BOOL)isMulti;

@end
