//
//  LPMessageDisplayManager.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPMessageDisplayManager.h"
#import "LPAlertMessage.h"

@implementation LPMessageDisplayManager

-(UIAlertController *)create:(LPAlertMessage *)message {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:message.title
                                  message:message.message
                                  preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *dismiss = [UIAlertAction
                             actionWithTitle:message.dismissText
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:dismiss];
    return alert;
}

-(void)display:(LPAlertMessage *)message {
}

@end
