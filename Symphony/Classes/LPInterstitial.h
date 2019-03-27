//
//  LPInterstitial.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LPInterstitial : NSObject
@property (nonatomic, assign)         NSInteger kind;
@property (nonatomic, strong)         LPInterstitialKinds *kinds;
@property (nonatomic, nullable, copy) id options;
@property (nonatomic, strong)         LPInterstitialValues *values;
@end
