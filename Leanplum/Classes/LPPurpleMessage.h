//
//  LPPurpleMessage.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LPPurpleMessage : NSObject
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, copy)   NSString *text;
@end
