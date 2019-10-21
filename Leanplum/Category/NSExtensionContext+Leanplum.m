//
//  NSExtensionContext+Leanplum.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "NSExtensionContext+Leanplum.h"
#import "LeanplumInternal.h"


@implementation NSExtensionContext (Leanplum)

- (void)leanplum_completeRequestReturningItems:(NSArray *)items
                             completionHandler:(void(^)(BOOL expired))completionHandler
{
    [self leanplum_completeRequestReturningItems:items completionHandler:completionHandler];
    [Leanplum pause];
}

- (void)leanplum_cancelRequestWithError:(NSError *)error
{
    [self leanplum_cancelRequestWithError:error];
    [Leanplum pause];
}

@end
