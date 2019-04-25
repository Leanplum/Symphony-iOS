//
//  LPAlertValues.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
#import "LPValuesDismissAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPAlertValues : NSObject<LPModelProtocol>

@property (nonatomic, strong) LPValuesDismissAction *dismissAction;
@property (nonatomic, copy)   NSString *dismissText;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, copy)   NSString *title;

@end

NS_ASSUME_NONNULL_END
