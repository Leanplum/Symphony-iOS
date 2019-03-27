//
//  LPConfirmKinds.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPConfirmKinds : NSObject
@property (nonatomic, copy) NSString *acceptAction;
@property (nonatomic, copy) NSString *acceptText;
@property (nonatomic, copy) NSString *cancelAction;
@property (nonatomic, copy) NSString *cancelText;
@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *title;
@end
