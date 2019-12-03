//
//  LPConfirmationMessage.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/19/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPMessage.h"

@interface LPConfirmationMessage : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *acceptText;
@property (nonatomic, copy) NSString *acceptAction;
@property (nonatomic, copy) NSString *cancelText;
@property (nonatomic, copy) NSString *cancelAction;

+(instancetype)confirmationMessageWithTitle:(NSString *)title
                                    message:(NSString *)message
                                 acceptText:(NSString *)acceptText
                                acceptAction:(NSString *)acceptAction
                                 cancelText:(NSString *)cancelText
                               cancelAction:(NSString *)cancelAction;

@end
