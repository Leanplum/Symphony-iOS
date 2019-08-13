//
//  NSDictionary+Keychain.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 8/7/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "NSObject+Keychain.h"
#import <Security/Security.h>
#include <CommonCrypto/CommonCryptor.h>

@implementation NSObject (Keychain)

- (void) storeToKeychainWithKey:(NSString *)aKey {
    // serialize dict
    NSData *serializedDictionary = [NSKeyedArchiver archivedDataWithRootObject:self];
    // encrypt in keychain
    // first, delete potential existing entries with this key (it won't auto update)
    [self deleteFromKeychainWithKey:aKey];
    
    // setup keychain storage properties
    NSDictionary *storageQuery = @{
                                   (__bridge id)kSecAttrAccount:    aKey,
                                   (__bridge id)kSecValueData:      serializedDictionary,
                                   (__bridge id)kSecClass:          (__bridge id)kSecClassGenericPassword,
                                   (__bridge id)kSecAttrAccessible: (__bridge id)kSecAttrAccessibleWhenUnlocked
                                   };
    OSStatus osStatus = SecItemAdd((__bridge CFDictionaryRef)storageQuery, nil);
    if(osStatus != noErr) {
        //ToDo: do someting with error
        NSLog(@"Keychain error storing");
    }
}


+ (NSObject *) dictionaryFromKeychainWithKey:(NSString *)aKey {
    // setup keychain query properties
    NSDictionary *readQuery = @{
                                (__bridge id)kSecAttrAccount: aKey,
                                (__bridge id)kSecReturnData: (id)kCFBooleanTrue,
                                (__bridge id)kSecClass:      (__bridge id)kSecClassGenericPassword
                                };
    
    CFDataRef serializedDictionary = NULL;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)readQuery, (CFTypeRef *)&serializedDictionary);
    if(osStatus == noErr) {
        // deserialize dictionary
        NSData *data = (__bridge NSData *)serializedDictionary;
        NSObject *storedDictionary = [NSKeyedUnarchiver unarchiveObjectWithData:data];
        return storedDictionary;
    }
    else {
        // ToDo: something with error
        NSLog(@"Keychain error lookup");
        return nil;
    }
}


- (void) deleteFromKeychainWithKey:(NSString *)aKey {
    // setup keychain query properties
    NSDictionary *deletableItemsQuery = @{
                                          (__bridge id)kSecAttrAccount:        aKey,
                                          (__bridge id)kSecClass:              (__bridge id)kSecClassGenericPassword,
                                          (__bridge id)kSecMatchLimit:         (__bridge id)kSecMatchLimitAll,
                                          (__bridge id)kSecReturnAttributes:   (id)kCFBooleanTrue
                                          };
    
    CFArrayRef itemList = nil;
    OSStatus osStatus = SecItemCopyMatching((__bridge CFDictionaryRef)deletableItemsQuery, (CFTypeRef *)&itemList);
    // each item in the array is a dictionary
    NSArray *itemListArray = (__bridge NSArray *)itemList;
    for (NSDictionary *item in itemListArray) {
        NSMutableDictionary *deleteQuery = [item mutableCopy];
        [deleteQuery setValue:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
        // do delete
        osStatus = SecItemDelete((__bridge CFDictionaryRef)deleteQuery);
        if(osStatus != noErr) {
            // ToDo: something with error
            NSLog(@"Keychain error deletion");
        }
    }
}

@end
