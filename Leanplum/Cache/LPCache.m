//
//  LPCache.m
//  Leanplum
//
//  Created by Grace on 7/23/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPCache.h"
#import "NSObject+Keychain.h"
#import "LPConstants.h"
#import "LPRegion.h"
#import "LPFileAttribute.h"

@implementation LPCache

+ (instancetype)sharedCache {
    static LPCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (void)setRegions:(NSArray<LPRegion *> *)regions {
    [regions storeToKeychainWithKey:LP_KEY_REGIONS];
}

- (NSArray<LPRegion *> *)regions {
    NSArray<LPRegion *> *regions  = (NSArray<LPRegion *> *) [NSObject dictionaryFromKeychainWithKey:LP_KEY_REGIONS];
    return regions;
}

- (void)setFileAttributes:(NSArray<LPFileAttribute *> *)fileAttributes {
    [fileAttributes storeToKeychainWithKey:LP_KEY_FILE_ATTRIBUTES];
}

- (NSArray<LPFileAttribute *> *)fileAttributes {
    NSArray<LPFileAttribute *> *regions  = (NSArray<LPFileAttribute *> *) [NSObject dictionaryFromKeychainWithKey:LP_KEY_FILE_ATTRIBUTES];
    return regions;
}


@end
