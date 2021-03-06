//
//  LPMessage.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 4/2/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPMessage : NSObject<LPModelProtocol, NSCoding>

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *action;
@property (nonatomic, assign) NSTimeInterval countdown;
@property (nonatomic, assign) BOOL hasImpressionCriteria;
@property (nonatomic, strong) NSString *parentCampaignId;
@property (nonatomic, assign) int priority;
@property (nonatomic, strong) NSArray *vars;
@property (nonatomic, strong) NSArray *whenLimits;
@property (nonatomic, strong) NSArray *whenTriggers;

@end

NS_ASSUME_NONNULL_END
