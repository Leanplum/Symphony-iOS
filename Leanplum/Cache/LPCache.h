//
//  LPCache.h
//  Leanplum
//
//  Created by Grace on 7/23/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPRegion.h"
#import "LPFileAttribute.h"

@interface LPCache : NSObject

+ (instancetype)sharedCache;

- (void)setRegions:(NSArray<LPRegion *> *)regions;
- (NSArray<LPRegion *> *)regions;
- (void)setFileAttributes:(NSArray<LPFileAttribute *> *)regions;
- (NSArray<LPFileAttribute *> *)fileAttributes;

@end

