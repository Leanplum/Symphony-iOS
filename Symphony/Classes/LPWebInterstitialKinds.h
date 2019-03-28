//
//  LPWebInterstitialKinds.h
//  Symphony
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWebInterstitialKinds : NSObject
@property (nonatomic, copy) NSString *closeURL;
@property (nonatomic, copy) NSString *hasDismissButton;
@property (nonatomic, copy) NSString *url;
@end

NS_ASSUME_NONNULL_END
