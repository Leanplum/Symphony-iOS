//
//  NSDictionary+Keychain.h
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject(Keychain)
- (void)storeToKeychainWithKey:(NSString *)aKey;
+ (NSObject *)dictionaryFromKeychainWithKey:(NSString *)aKey;
- (void)deleteFromKeychainWithKey:(NSString *)aKey;
@end
