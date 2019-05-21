//
//  LPTrackApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPTrackApi : NSObject

+ (void) track:(NSDictionary *)attributes
       success:(void (^)(void))success
       failure:(void (^)(NSError *error))failure;

@end

