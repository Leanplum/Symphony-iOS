//
//  LPCacheProtocol.h
//  Leanplum
//
//  Created by Grace on 7/29/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPVariable;
@class LPRegion;
@class LPMessage;
@class LPVariant;
@class LPUpdateRule;
@class LPEventRule;
@class LPVariantDebugInfo;

@protocol LPCaching <NSObject>

- (NSArray<LPVariable *> *)loadVariables;
- (void)setVariables:(NSArray<LPVariable *> *)variables;
- (NSArray<LPRegion *> *)loadRegions;
- (void)setRegions:(NSArray<LPRegion *> *)regions;
- (NSArray<LPRegion *> *)regions;
- (NSArray<LPMessage *> *)loadMessages;
- (void)setMessages:(NSArray<LPMessage *> *)messages;
- (NSArray<LPVariant *> *)loadVariants;
- (void)setVariants:(NSArray<LPVariant *> *)variants;
- (NSArray<LPUpdateRule *> *)loadUpdateRules;
- (void)setUpdateRules:(NSArray<LPUpdateRule *> *)updateRules;
- (NSArray<LPEventRule *> *)loadEventRules;
- (void)setEventRules:(NSArray<LPEventRule *> *)eventRules;
- (NSArray<LPVariantDebugInfo *> *)loadVariantDebugInfo;
- (void)setVariantDebugInfo:(NSArray<LPVariantDebugInfo *> *)variantDebugInfo;
- (void)setFileAttributes:(NSArray<LPFileAttribute *> *)fileAttributes;
- (NSArray<LPFileAttribute *> *)fileAttributes;

@end
