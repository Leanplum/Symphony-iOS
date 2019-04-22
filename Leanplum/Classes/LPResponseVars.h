//
//  LPResponseVars.h
//  Leanplum
//
//  Created by Grace on 3/28/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPResponseVars : NSObject
@property (nonatomic, copy)   NSString *composerName;
@property (nonatomic, copy)   NSString *compositionTitle;
@property (nonatomic, copy)   NSString *photograph;
@property (nonatomic, assign) BOOL isVarsVarBool;
@property (nonatomic, copy)   NSString *varsVarFile;
@property (nonatomic, assign) double varsVarNumber;
@property (nonatomic, copy)   NSString *varText;
@property (nonatomic, assign) BOOL isVarBool;
@property (nonatomic, copy)   NSString *varFile;
@property (nonatomic, assign) double varNumber;
@property (nonatomic, copy)   NSString *varString;
@end

NS_ASSUME_NONNULL_END
