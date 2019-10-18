//
//  LPAlertKinds.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"

@interface LPAlertKinds : NSObject<LPModelProtocol, NSCoding>

@property (nonatomic, copy) NSString *dismissAction;
@property (nonatomic, copy) NSString *dismissText;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;

@end

