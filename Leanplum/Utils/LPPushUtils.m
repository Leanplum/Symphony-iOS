//
//  LPPushUtils.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 9/30/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPPushUtils.h"

@implementation LPPushUtils

+ (BOOL)isRichPushEnabled
{
    NSString *plugInsPath = [NSBundle mainBundle].builtInPlugInsPath;
    NSDirectoryEnumerator *enumerator = [[NSFileManager defaultManager]
                                         enumeratorAtPath:plugInsPath];
    NSString *filePath;
    while (filePath = [enumerator nextObject]) {
        if([filePath hasSuffix:@".appex/Info.plist"]) {
            NSString *newPath = [[plugInsPath stringByAppendingPathComponent:filePath]
                                 stringByDeletingLastPathComponent];
            NSBundle *currentBundle = [NSBundle bundleWithPath:newPath];
            NSDictionary *extensionKey =
            [currentBundle objectForInfoDictionaryKey:@"NSExtension"];
            if ([[extensionKey objectForKey:@"NSExtensionPrincipalClass"]
                 isEqualToString:@"NotificationService"]) {
                return YES;
            }
        }
    }
    return NO;
}


@end
