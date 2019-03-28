//
//  LPMagentaChild.h
//  Symphony
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPMagentaChild : NSObject
@property (nonatomic, copy) NSString *noun;
@property (nonatomic, copy) NSArray *objects;
@property (nonatomic, copy) NSString *secondaryVerb;
@property (nonatomic, copy) NSString *subject;
@property (nonatomic, copy) NSString *verb;
@end

NS_ASSUME_NONNULL_END
