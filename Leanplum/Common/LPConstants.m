//
//  LPConstants.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 4/25/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPConstants.h"

@implementation LPConstants


@end

#pragma mark - The rest of the Leanplum constants

#ifdef PACKAGE_IDENTIFIER
NSString *LEANPLUM_PACKAGE_IDENTIFIER = @MACRO_VALUE(PACKAGE_IDENTIFIER);
#else
NSString *LEANPLUM_PACKAGE_IDENTIFIER = @"s";
#endif
