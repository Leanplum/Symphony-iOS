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

- (NSArray<LPEventRule *> *)loadEventRules {
    return nil;
}


- (NSArray<LPMessage *> *)loadMessages {
     return nil;
}


- (NSArray<LPRegion *> *)loadRegions {
     return nil;
}


- (NSArray<LPUpdateRule *> *)loadUpdateRules {
     return nil;
}


- (NSArray<LPVariable *> *)loadVariables {
     return nil;
}


- (NSArray<LPVariantDebugInfo *> *)loadVariantDebugInfo {
     return nil;
}


- (NSArray<LPVariant *> *)loadVariants {
     return nil;
}


- (void)setEventRules:(NSArray<LPEventRule *> *)eventRules {
}


- (void)setMessages:(NSArray<LPMessage *> *)messages {
}


- (void)setUpdateRules:(NSArray<LPUpdateRule *> *)updateRules {
}


- (void)setVariables:(NSArray<LPVariable *> *)variables {
}


- (void)setVariantDebugInfo:(NSArray<LPVariantDebugInfo *> *)variantDebugInfo {
}


- (void)setVariants:(NSArray<LPVariant *> *)variants {
}

- (void)clearCache {
    [self deleteFromKeychainWithKey:LP_KEY_REGIONS];
}



@end
