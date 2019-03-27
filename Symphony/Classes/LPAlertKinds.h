//
//  LPAlertKinds.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAlertKinds : NSObject
@property (nonatomic, copy) NSString *dismissAction;
@property (nonatomic, copy) NSString *dismissText;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;
@end
