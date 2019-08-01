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
- (void)saveVariables:(NSArray<LPVariable *> *)variables;
- (NSArray<LPRegion *> *)loadRegions;
- (void)saveRegions:(NSArray<LPRegion *> *)regions;
- (NSArray<LPMessage *> *)loadMessages;
- (void)saveMessages:(NSArray<LPMessage *> *)messages;
- (NSArray<LPVariant *> *)loadVariants;
- (void)saveVariants:(NSArray<LPVariant *> *)variants;
- (NSArray<LPUpdateRule *> *)loadUpdateRules;
- (void)saveUpdateRules:(NSArray<LPUpdateRule *> *)updateRules;
- (NSArray<LPEventRule *> *)loadEventRules;
- (void)saveEventRules:(NSArray<LPEventRule *> *)eventRules;
- (NSArray<LPVariantDebugInfo *> *)loadVariantDebugInfo;
- (void)saveVariantDebugInfo:(NSArray<LPVariantDebugInfo *> *)variantDebugInfo;

@end
