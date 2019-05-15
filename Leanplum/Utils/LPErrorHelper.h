//
//  LPErrorHelper.h
//  Leanplum
//
//  Created by Grace on 5/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPErrorHelper : NSObject

+ (NSError *)makeHttpError:(long)errorCode withResponseDict:(NSDictionary *)responseDict;
+ (NSError *)makeResponseError:(NSDictionary *)responseDict;

@end
