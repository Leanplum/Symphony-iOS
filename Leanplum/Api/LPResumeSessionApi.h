//
//  LPResumeSessionApi.h
//  Leanplum
//
//  Created by Grace on 5/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPResumeSessionApi : NSObject

+ (void) resumeSessionWithParameters:(NSDictionary *)parameters
                             success:(void (^)(void))success
                             failure:(void (^)(NSError *error))failure;


@end

