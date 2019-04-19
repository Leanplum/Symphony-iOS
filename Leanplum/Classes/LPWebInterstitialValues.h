//
//  LPWebInterstitialValues.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPWebInterstitialValues : NSObject
@property (nonatomic, copy)   NSString *closeURL;
@property (nonatomic, assign) BOOL isHasDismissButton;
@property (nonatomic, copy)   NSString *url;
@end

NS_ASSUME_NONNULL_END
