//
//  LPCenterPopupMessage.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 12/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPCenterPopupMessage.h"

@implementation LPCenterPopupMessage

+(instancetype)messageWithTitle:(NSString *)title
                     titleColor:(UIColor *)titleColor
                        message:(NSString *)message
                   messageColor:(UIColor *)messageColor
                backgroundImage:(UIImage *)backgroundImage
                backgroundColor:(UIColor *)backgroundColor
                     acceptText:(NSString *)acceptText
                   acceptAction:(NSString *)acceptAction
                acceptTextColor:(UIColor *)acceptTextColor
                         height:(CGFloat)height
                          width:(CGFloat)width {
    LPCenterPopupMessage *centerPopup = [[LPCenterPopupMessage alloc] init];
    centerPopup.title = title;
    centerPopup.titleColor = titleColor;
    centerPopup.message = message;
    centerPopup.messageColor = messageColor;
    centerPopup.backgroundImage = backgroundImage;
    centerPopup.backgroundColor = backgroundColor;
    centerPopup.acceptText = acceptText;
    centerPopup.acceptAction = acceptAction;
    centerPopup.acceptText = acceptText;
    centerPopup.acceptAction = acceptAction;
    centerPopup.acceptTextColor = acceptTextColor;
    centerPopup.height = height;
    centerPopup.width = width;
    return centerPopup;


}

@end
