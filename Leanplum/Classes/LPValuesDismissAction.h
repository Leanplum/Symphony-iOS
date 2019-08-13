//
//  LPValuesDismissAction.h
//  Symphony
//
//  Created by Grace on 4/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
#import "LPModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPValuesDismissAction : LPModel<LPModelProtocol>

@property (nonatomic, copy) NSString *name;

@end

NS_ASSUME_NONNULL_END
