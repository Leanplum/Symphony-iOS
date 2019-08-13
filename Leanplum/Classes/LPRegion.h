//
//  LPRegions.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
#import "LPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPRegion : LPModel<LPModelProtocol>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double lon;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float version;

@end

NS_ASSUME_NONNULL_END
