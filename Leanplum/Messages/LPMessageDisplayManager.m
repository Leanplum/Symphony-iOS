//
//  LPMessageDisplayManager.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPMessageDisplayManager.h"
#import "LPAlertMessage.h"
#import "LPConfirmationMessage.h"

@implementation LPMessageDisplayManager

-(UIAlertController *)createAlert:(LPAlertMessage *)message {
    UIAlertController * alert = [UIAlertController
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

-(void)displayAlert:(LPAlertMessage *)message {
}

-(UIAlertController *)createConfirmation:(LPConfirmationMessage *)message {
    UIAlertController *alert = [UIAlertController
                                alertControllerWithTitle:message.title
                                message:message.message
                                preferredStyle:UIAlertControllerStyleAlert];

    UIAlertAction *accept = [UIAlertAction
                             actionWithTitle:message.acceptText
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    UIAlertAction *cancel = [UIAlertAction
                             actionWithTitle:message.cancelText
                             style:UIAlertActionStyleDefault
                             handler:^(UIAlertAction * action) {
        [alert dismissViewControllerAnimated:YES completion:nil];
    }];
    [alert addAction:accept];
    [alert addAction:cancel];
    return alert;
}

-(void)displayConfirmation:(LPConfirmationMessage *)message {
}

@end
