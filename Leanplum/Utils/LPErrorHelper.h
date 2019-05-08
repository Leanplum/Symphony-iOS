//
//  LPErrorHelper.h
//  Leanplum
//
//  Created by Grace on 5/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPErrorHelper : NSObject

+ (NSDictionary *)makeUserInfoDict:(NSDictionary *)responseDict;
+ (NSError *)makeHttpError:(long)errorCode withDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
