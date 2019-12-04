//
//  LPMessageDisplayManager.m
//  Leanplum
//
//  Created by Mayank Sanganeria on 11/13/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPMessageDisplayManager.h"
#import "LPAlertMessage.h"
#import "LPCenterPopupMessage.h"
#import "LPConfirmationMessage.h"

#define LPMT_DISMISS_BUTTON_SIZE 32

#define LPMT_ACCEPT_BUTTON_WIDTH 50
#define LPMT_ACCEPT_BUTTON_HEIGHT 15
#define LPMT_ACCEPT_BUTTON_MARGIN 10

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

-(UIView *)createCenterPopup:(LPCenterPopupMessage *)message {
    UIView *popupGroup = [[UIView alloc] init];
    UIView *popupView = [[UIView alloc] init];

    popupGroup.backgroundColor = [UIColor clearColor];
    [popupGroup addSubview:popupView];
    UIView *popupBackground = [[UIImageView alloc] init];
    [popupView addSubview:popupBackground];
    popupBackground.contentMode = UIViewContentModeScaleAspectFill;
    popupView.layer.cornerRadius = 12;
    popupView.clipsToBounds = YES;

    // Accept button.
    UIButton *acceptButton = [UIButton buttonWithType:UIButtonTypeCustom];
    acceptButton.layer.cornerRadius = 6;
    acceptButton.adjustsImageWhenHighlighted = YES;
    acceptButton.layer.masksToBounds = YES;
    acceptButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [popupView addSubview:acceptButton];

    // Title.
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.backgroundColor = [UIColor clearColor];
    [popupView addSubview:titleLabel];

    // Message.
    UILabel *messageLabel = [[UILabel alloc] init];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    messageLabel.numberOfLines = 0;
    messageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    messageLabel.backgroundColor = [UIColor clearColor];
    [popupView addSubview:messageLabel];

    // Overlay.
    UIButton *overlayView = [UIButton buttonWithType:UIButtonTypeCustom];
    overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.7];


    [popupGroup addSubview:overlayView];

    [acceptButton addTarget:self action:@selector(accept)
                forControlEvents:UIControlEventTouchUpInside];


    UIButton *dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    dismissButton.bounds = CGRectMake(0, 0, LPMT_DISMISS_BUTTON_SIZE, LPMT_DISMISS_BUTTON_SIZE);
    [dismissButton setBackgroundImage:[self dismissImage:[UIColor colorWithWhite:.9 alpha:.9] withSize:LPMT_DISMISS_BUTTON_SIZE] forState:UIControlStateNormal];
    [dismissButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    dismissButton.adjustsImageWhenHighlighted = YES;
    dismissButton.layer.masksToBounds = YES;
    dismissButton.titleLabel.font = [UIFont systemFontOfSize:13];
    dismissButton.layer.borderWidth = 0;
    dismissButton.layer.cornerRadius = LPMT_DISMISS_BUTTON_SIZE / 2;
    [popupGroup addSubview:dismissButton];

    [dismissButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;

    UIEdgeInsets safeAreaInsets = [self safeAreaInsets];

    CGFloat statusBarHeight = safeAreaInsets.top;

    UIInterfaceOrientation orientation;
    orientation = UIInterfaceOrientationPortrait;
    CGAffineTransform orientationTransform;
    switch (orientation) {
        case UIDeviceOrientationPortraitUpsideDown:
            orientationTransform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIDeviceOrientationLandscapeLeft:
            orientationTransform = CGAffineTransformMakeRotation(M_PI / 2);
            break;
        case UIDeviceOrientationLandscapeRight:
            orientationTransform = CGAffineTransformMakeRotation(-M_PI / 2);
            break;
        default:
            orientationTransform = CGAffineTransformIdentity;
    }
    popupGroup.transform = orientationTransform;

    CGSize screenSize = window.screen.bounds.size;
    popupGroup.frame = CGRectMake(0, 0, screenSize.width, screenSize.height);

    CGFloat screenWidth = screenSize.width;
    CGFloat screenHeight = screenSize.height;

    if (orientation == UIDeviceOrientationLandscapeLeft ||
        orientation == UIDeviceOrientationLandscapeRight) {
        screenWidth = screenSize.height;
        screenHeight = screenSize.width;
    }
    popupView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    popupView.frame = CGRectMake(0, 0, message.width, message.height);
    popupView.center = CGPointMake(screenWidth / 2.0, screenHeight / 2.0);
//    [self updateNonWebPopupLayout:statusBarHeight isPushAskToAsk:isPushAskToAsk];
    overlayView.frame = CGRectMake(0, 0, screenWidth, screenHeight);
    CGFloat leftSafeAreaX = safeAreaInsets.left;
    CGFloat dismissButtonX = screenWidth - dismissButton.frame.size.width - LPMT_ACCEPT_BUTTON_MARGIN / 2;
    CGFloat dismissButtonY = statusBarHeight + LPMT_ACCEPT_BUTTON_MARGIN / 2;
    dismissButtonX = popupView.frame.origin.x + popupView.frame.size.width - 3 * dismissButton.frame.size.width / 4;
    dismissButtonY = popupView.frame.origin.y - dismissButton.frame.size.height / 4;

    dismissButton.frame = CGRectMake(dismissButtonX - leftSafeAreaX, dismissButtonY, dismissButton.frame.size.width, dismissButton.frame.size.height);

    return popupGroup;
}

-(UIEdgeInsets)safeAreaInsets
{
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
    if (@available(iOS 11.0, *)) {
        insets = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
    } else {
        insets.top = [[UIApplication sharedApplication] isStatusBarHidden] ? 0 : 20.0;
    }
    return insets;
}

-(void)displayCenterPopup:(LPCenterPopupMessage *)message {
}

- (void)accept
{
//    [self closePopupWithAnimation:YES actionNamed:LPMT_ARG_ACCEPT_ACTION track:YES];
}

- (void)dismiss
{
//    LP_TRY
//    [self closePopupWithAnimation:YES];
//    LP_END_TRY
}

// Creates the X icon used in the popup's dismiss button.
- (UIImage *)dismissImage:(UIColor *)color withSize:(int)size
{
    CGRect rect = CGRectMake(0, 0, size, size);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    int margin = size * 3 / 8;

    CGContextSetStrokeColorWithColor(context, [UIColor blackColor].CGColor);
    CGContextSetLineWidth(context, 1.5);
    CGContextMoveToPoint(context, margin, margin);
    CGContextAddLineToPoint(context, size - margin, size - margin);
    CGContextMoveToPoint(context, size - margin, margin);
    CGContextAddLineToPoint(context, margin, size - margin);
    CGContextStrokePath(context);

    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

@end
