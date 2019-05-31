//
//  LPAdvanceApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAdvanceApi : NSObject

+ (void) advanceToState:(NSString *)state
         withParameters:(NSDictionary *)parameters
                success:(void (^)(void))success
                failure:(void (^)(NSError *error))failure;
@end
