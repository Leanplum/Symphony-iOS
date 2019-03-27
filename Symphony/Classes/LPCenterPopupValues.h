//
//  LPCenterPopupValues.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPCenterPopupValues : NSObject
@property (nonatomic, strong) LPPurpleAcceptAction *acceptAction;
@property (nonatomic, strong) LPPurpleAcceptButton *acceptButton;
@property (nonatomic, assign) NSInteger backgroundColor;
@property (nonatomic, copy)   NSString *backgroundImage;
@property (nonatomic, strong) LPPurpleLayout *layout;
@property (nonatomic, strong) LPPurpleMessage *message;
@property (nonatomic, strong) LPPurpleTitle *title;
@end

