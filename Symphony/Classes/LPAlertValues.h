//
//  LPAlertValues.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAlertValues : NSObject
//@property (nonatomic, strong) LPValuesDismissAction *dismissAction;
@property (nonatomic, copy)   NSString *dismissText;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, copy)   NSString *title;
@end
