//
//  LPSample.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"
NS_ASSUME_NONNULL_BEGIN

@interface LPSample : NSObject <LPModelProtocol>
@property (nonatomic,retain) NSString *sampleId;
@property (nonatomic, retain) NSString *title;
@property NSInteger viewCount;
@end

NS_ASSUME_NONNULL_END
