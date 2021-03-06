//
//  LPFileAttributes.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LPModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface LPFileAttribute : NSObject<LPModelProtocol, NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) double size;
@property (nonatomic, strong, nullable) NSString *fileAttributeHash; //changed to fileAttributeHash because hash is a keyword in NSObject
@property (nonatomic, strong) NSURL *servingUrl;

@end

NS_ASSUME_NONNULL_END
