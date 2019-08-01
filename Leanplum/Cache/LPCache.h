//
//  LPCache.h
//  Leanplum
//
//  Created by Grace on 7/23/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPCaching.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPCache : NSObject<LPCaching>

+ (instancetype)sharedCache;

@end

NS_ASSUME_NONNULL_END
