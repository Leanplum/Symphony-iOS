//
//  LPCache.m
//  Leanplum
//
//  Created by Grace on 7/23/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPCache.h"
#import "LPAES.h"

@implementation LPCache

+ (instancetype)sharedCache {
    static LPCache *sharedCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedCache = [[self alloc] init];
    });
    return sharedCache;
}

- (NSData *)encrypt:(NSData *)data {
    return [LPAES encryptedDataFromData:data];
}

- (NSData *)decrypt:(NSData *)data {
    return [LPAES decryptedDataFromData:data];
}

- (NSData *)encodeIntoBinary:(NSArray *)data {
    //TODO
    return [NSData new];
}

- (NSArray *)decodeFromBinary:(NSData *)data {
    //TODO
    return [NSArray new];
}

- (void)persist:(NSData *)data forKey:(NSString *)key {
    //TODO
}

- (void)save:(NSArray *)data forKey:(NSString *)key {
    NSData *encoded = [self encodeIntoBinary:data];
    NSData *encrypted = [self encrypt:encoded];
    [self persist:encrypted forKey:key];
}

- (NSArray<LPVariable *> *)loadVariables {
    return [NSArray new];
}

- (void)saveVariables:(NSArray<LPVariable *> *)variables {
    [self save:variables forKey:@"variables"];
}

- (NSArray<LPRegion *> *)loadRegions {
    //TODO
    return [NSArray new];
}

- (void)saveRegions:(NSArray<LPRegion *> *)regions {
    [self save:regions forKey:@"regions"];
}

- (NSArray<LPMessage *> *)loadMessages {
    //TODO
    return [NSArray new];
}

- (void)saveMessages:(NSArray<LPMessage *> *)messages {
    [self save:messages forKey:@"messages"];
}

- (NSArray<LPVariant *> *)loadVariants {
    //TODO
    return [NSArray new];
}

- (void)saveVariants:(NSArray<LPVariant *> *)variants {
    [self save:variants forKey:@"variants"];
}

- (NSArray<LPUpdateRule *> *)loadUpdateRules {
    //TODO
    return [NSArray new];
}

- (void)saveUpdateRules:(NSArray<LPUpdateRule *> *)updateRules {
    [self save:updateRules forKey:@"updateRules"];
}

- (NSArray<LPEventRule *> *)loadEventRules {
    //TODO
    return [NSArray new];
}

- (void)saveEventRules:(NSArray<LPEventRule *> *)eventRules {
    [self save:eventRules forKey:@"eventRules"];
}

- (NSArray<LPVariantDebugInfo *> *)loadVariantDebugInfo {
    //TODO
    return [NSArray new];
}

- (void)saveVariantDebugInfo:(NSArray<LPVariantDebugInfo *> *)variantDebugInfo {
    [self save:variantDebugInfo forKey:@"variantDebugInfo"];
}

@end
