//
//  LPWSManager.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPWSManager : NSObject

- (void)sendGETWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure;
- (void)sendPOSTWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure;

@end
