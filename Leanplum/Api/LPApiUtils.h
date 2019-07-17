//
//  LPApiUtils.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 7/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPApiUtils : NSObject

+(NSDictionary *)responseDictionaryFromResponse:(NSDictionary *)response;

@end

NS_ASSUME_NONNULL_END
