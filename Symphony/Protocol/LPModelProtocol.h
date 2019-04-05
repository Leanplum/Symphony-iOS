//
//  LPModelProtocol.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LPModelProtocol <NSObject>

- (NSDictionary *) getClasMapping;
- (id) initWithDictionary:(NSDictionary *)responseDict;

@end
