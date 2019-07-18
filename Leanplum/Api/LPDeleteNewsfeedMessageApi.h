//
//  LPDeleteNewsfeedMessageApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPDeleteNewsfeedMessageApi : NSObject

+ (void) deleteNewsfeedMessageWithMessageId:(NSString *)messageId
                                 parameters:(NSDictionary *)parameters
                                    success:(void (^)(void))success
                                    failure:(void (^)(NSError *error))failure;
@end
