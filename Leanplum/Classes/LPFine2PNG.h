//
//  LPFine2PNG.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPFine2PNG : NSObject
@property (nonatomic, nullable, copy) id theHash;
@property (nonatomic, copy)           NSString *servingURL;
@property (nonatomic, assign)         NSInteger size;
@end

NS_ASSUME_NONNULL_END
