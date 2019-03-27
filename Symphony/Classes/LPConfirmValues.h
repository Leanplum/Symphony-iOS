//
//  LPConfirmValues.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPConfirmValues : NSObject
@property (nonatomic, strong) LPFluffyAcceptAction *acceptAction;
@property (nonatomic, copy)   NSString *acceptText;
@property (nonatomic, strong) LPPurpleCancelAction *cancelAction;
@property (nonatomic, copy)   NSString *cancelText;
@property (nonatomic, copy)   NSString *message;
@property (nonatomic, copy)   NSString *title;
@end
