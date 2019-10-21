//
//  NSExtensionContext+Leanplum.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 10/16/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//


#import <Foundation/Foundation.h>


@interface NSExtensionContext (Leanplum)

- (void)leanplum_completeRequestReturningItems:(NSArray *)items
                             completionHandler:(void(^)(BOOL expired))completionHandler;
- (void)leanplum_cancelRequestWithError:(NSError *)error;

@end
