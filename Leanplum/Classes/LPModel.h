//
//  LPModel.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/12/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPModel : NSObject <NSCoding> 

- (void) initWithMapping:(NSDictionary *)classMapping;

@end

