//
//  LPAPIConfig.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAPIConfig : NSObject

@property (nonatomic, readonly) NSString *appId;
@property (nonatomic, readonly) NSString *accessKey;

@property (nonatomic, strong) NSString *deviceId;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *token;

+ (instancetype)sharedConfig;

- (void)setAppId:(NSString *)appId withAccessKey:(NSString *)accessKey;

@end
