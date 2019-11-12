//
//  LPDeviceApi.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPDeviceApi : NSObject

+ (void) setDeviceId:(NSString *)deviceId
withDeviceAttributes:(NSDictionary *)attributes
             success:(void (^)(void))success
             failure:(void (^)(NSError *error))failure
              isMulti:(BOOL)isMulti;

@end
