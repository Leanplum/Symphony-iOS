//
//  LPMessageTemplates.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 12/17/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebKit/WebKit.h>
#import "Leanplum.h"


@interface LPMessageTemplatesClass : NSObject <UIAlertViewDelegate, WKNavigationDelegate>

+ (LPMessageTemplatesClass *)sharedTemplates;

- (void)disableAskToAsk;
- (void)refreshPushPermissions;

@end
