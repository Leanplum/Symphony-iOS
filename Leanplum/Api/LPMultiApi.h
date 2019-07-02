//
//  LPMultiApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPMultiApi : NSObject

+ (void) multiWithData:(NSArray *)data
               success:(void (^)(NSArray *))success
               failure:(void (^)(NSError *error))failure;
@end
