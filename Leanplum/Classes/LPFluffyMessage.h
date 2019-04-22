//
//  LPFluffyMessage.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPFluffyMessage : NSObject
@property (nonatomic, assign) NSInteger color;
@property (nonatomic, copy)   NSString *text;

@end

NS_ASSUME_NONNULL_END
