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

//ToDo: Implement feature based
- (NSArray<LPEventRule *> *)loadEventRules {
    return nil;
}

//ToDo: Implement feature based
- (NSArray<LPMessage *> *)loadMessages {
     return nil;
}

//ToDo: Implement feature based
- (NSArray<LPRegion *> *)loadRegions {
     return nil;
}

//ToDo: Implement feature based
- (NSArray<LPUpdateRule *> *)loadUpdateRules {
     return nil;
}

//ToDo: Implement feature based
- (NSArray<LPVariable *> *)loadVariables {
     return nil;
}

//ToDo: Implement feature based
- (NSArray<LPVariantDebugInfo *> *)loadVariantDebugInfo {
     return nil;
}

//ToDo: Implement feature based
- (NSArray<LPVariant *> *)loadVariants {
     return nil;
}

//ToDo: Implement feature based
- (void)setEventRules:(NSArray<LPEventRule *> *)eventRules {
}

//ToDo: Implement feature based
- (void)setMessages:(NSArray<LPMessage *> *)messages {
}

//ToDo: Implement feature based
- (void)setUpdateRules:(NSArray<LPUpdateRule *> *)updateRules {
}

//ToDo: Implement feature based
- (void)setVariables:(NSArray<LPVariable *> *)variables {
}

//ToDo: Implement feature based
- (void)setVariantDebugInfo:(NSArray<LPVariantDebugInfo *> *)variantDebugInfo {
}

//ToDo: Implement feature based
- (void)setVariants:(NSArray<LPVariant *> *)variants {
}

- (void)clearCache {
    [self deleteFromKeychainWithKey:LP_KEY_REGIONS];
}



@end
