//
//  LPRegisterDeviceApi.h
//  Leanplum
//
//  Created by Grace on 5/14/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPRegisterDeviceApi : NSObject

+ (void) registerDeviceWithParameters:(NSDictionary *)parameters
                              success:(void (^)(void))success
                              failure:(void (^)(NSError *error))failure
                              isMulti:(BOOL)isMulti;

@end

