//
//  LPRegisterForPush.h
//  Symphony
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPRegisterForPush : NSObject
@property (nonatomic, assign)         NSInteger kind;
@property (nonatomic, copy)           NSDictionary<NSString *, id> *kinds;
@property (nonatomic, nullable, copy) id options;
@property (nonatomic, copy)           NSDictionary<NSString *, id> *values;
@end

NS_ASSUME_NONNULL_END
