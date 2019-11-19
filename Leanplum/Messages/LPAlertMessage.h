//
//  LPAlertMessage.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPMessage.h"

@interface LPAlertMessage : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *dismissText;
@property (nonatomic, copy) NSString *dismissAction;

+(instancetype)alertMessageWithTitle:(NSString *)title
                             message:(NSString *)message
                         dismissText:(NSString *)dismissText
                       dismissAction:(NSString *)dismissAction;

@end
