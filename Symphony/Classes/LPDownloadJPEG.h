//
//  LPDownloadJPEG.h
//  Symphony
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPDownloadJPEG : NSObject
@property (nonatomic, nullable, copy) id theHash;
@property (nonatomic, assign)         NSInteger size;
@end

NS_ASSUME_NONNULL_END
