//
//  LPAlertKinds.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAlertKinds : NSObject<LPModelProtocol>

@property (nonatomic, copy) NSString *dismissAction;
@property (nonatomic, copy) NSString *dismissText;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;

@end

NS_ASSUME_NONNULL_END
