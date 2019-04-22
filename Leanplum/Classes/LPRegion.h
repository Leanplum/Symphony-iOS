//
//  LPRegions.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPRegion : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *lon;
@property (nonatomic, strong) NSString *lat;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float version;

@end

NS_ASSUME_NONNULL_END
