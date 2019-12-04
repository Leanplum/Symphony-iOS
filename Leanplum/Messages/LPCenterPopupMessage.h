//
//  LPCenterPopupMessage.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 12/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LPCenterPopupMessage : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) UIColor *titleColor;

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) UIColor *messageColor;

@property (nonatomic, copy) UIImage *backgroundImage;
@property (nonatomic, copy) UIColor *backgroundColor;

@property (nonatomic, copy) NSString *acceptText;
@property (nonatomic, copy) NSString *acceptAction;
@property (nonatomic, copy) UIColor *acceptTextColor;

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;

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
                          width:(CGFloat )width;

@end
