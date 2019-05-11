//
//  LPDeviceApi.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPDeviceApi : NSObject

+ (void) setDeviceAttributes:(NSString *)deviceId withDeviceAttributes:(NSDictionary *)attributes
                    success:(void (^)(void))success
                    failure:(void (^)(NSError *error))failure;

@end
