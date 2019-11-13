//
//  LPAlertMessage.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPAlertMessage.h"

@implementation LPAlertMessage

+(instancetype)alertMessageWithTitle:(NSString *)title
      message:(NSString *)message
  dismissText:(NSString *)dismissText
                       dismissAction:(NSString *)dismissAction {
    LPAlertMessage *alert = [[LPAlertMessage alloc] init];
    alert.title = title;
    alert.message = message;
    alert.dismissText = dismissText;
    alert.dismissAction = dismissAction;
    return alert;
}

@end
