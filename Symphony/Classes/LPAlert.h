//
//  LPAlert.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPAlert : NSObject
@property (nonatomic, assign)         NSInteger kind;
@property (nonatomic, strong)         LPAlertKinds *kinds;
@property (nonatomic, nullable, copy) id options;
@property (nonatomic, strong)         LPAlertValues *values;
@end
