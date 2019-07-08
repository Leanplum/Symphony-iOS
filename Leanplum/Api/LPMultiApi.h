//
//  LPMultiApi.h
//  Leanplum
//
//  Created by Mayank Sanganeria on 5/21/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPMultiApi : NSObject

+ (void) multiWithData:(NSArray<NSDictionary *> *)data
               success:(void (^)(NSArray<NSDictionary *> *))success
               failure:(void (^)(NSError *error))failure;
@end
