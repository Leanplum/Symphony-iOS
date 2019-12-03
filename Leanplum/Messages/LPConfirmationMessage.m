//
//  LPConfirmationMessage.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/19/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPConfirmationMessage.h"

@implementation LPConfirmationMessage

+(instancetype)confirmationMessageWithTitle:(NSString *)title
                                    message:(NSString *)message
                                 acceptText:(NSString *)acceptText
                               acceptAction:(NSString *)acceptAction
                                 cancelText:(NSString *)cancelText
                               cancelAction:(NSString *)cancelAction {
    LPConfirmationMessage *confirmation = [[LPConfirmationMessage alloc] init];
    confirmation.title = title;
    confirmation.message = message;
    confirmation.acceptText = acceptText;
    confirmation.acceptAction = acceptAction;
    confirmation.cancelText = cancelText;
    confirmation.cancelAction = cancelAction;
    return confirmation;
}

@end
