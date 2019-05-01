//
//  LPAPIConfig.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 5/1/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAPIConfig.h"

@interface LPAPIConfig()

@property (nonatomic, strong) NSString *appId;
@property (nonatomic, strong) NSString *accessKey;

@end

@implementation LPAPIConfig

+ (instancetype)sharedConfig {
    static LPAPIConfig *sharedConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedConfig = [[self alloc] init];
        sharedConfig.token = nil;
    });
    return sharedConfig;
}

- (void)setAppId:(NSString *)appId withAccessKey:(NSString *)accessKey
{
    self.appId = appId;
    self.accessKey = accessKey;
}

@end
