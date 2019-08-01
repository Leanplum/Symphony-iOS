//
//  LPAES.h
//  Leanplum
//
//  Created by Grace on 7/24/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LPAES : NSObject

/**
 * Returns AES128 encrypted data using the crypto framework.
 */
+ (NSData *)encryptedDataFromData:(NSData *)data;

/**
 * Returns AES128 decrypted data using the crypto framework.
 */
+ (NSData *)decryptedDataFromData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
