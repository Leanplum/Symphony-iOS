//
//  LPUserApi.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPUserApi : NSObject

+ (void) setUserId:(NSString *)userId
withUserAttributes:(NSDictionary *)attributes
           success:(void (^)(void))success
           failure:(void (^)(NSError *error))failure;

@end

