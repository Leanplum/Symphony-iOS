//
//  LPAlert.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
#import "LPAlertKinds.h"
#import "LPAlertValues.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAlert : NSObject<LPModelProtocol>

@property (nonatomic, assign) NSInteger kind;
@property (nonatomic, strong) LPAlertKinds *kinds;
@property (nonatomic, nullable, copy) NSDictionary *options;
@property (nonatomic, strong) LPAlertValues *values;

@end

NS_ASSUME_NONNULL_END
