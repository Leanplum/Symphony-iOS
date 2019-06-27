//
//  LPFileManager.m
//  Leanplum
//
//  Created by Andrew First on 1/9/13.
//  Copyright (c) 2013 Leanplum, Inc. All rights reserved.
//
//  Licensed to the Apache Software Foundation (ASF) under one
//  or more contributor license agreements.  See the NOTICE file
//  distributed with this work for additional information
//  regarding copyright ownership.  The ASF licenses this file
//  to you under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing,
//  software distributed under the License is distributed on an
//  "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
//  KIND, either express or implied.  See the License for the
//  specific language governing permissions and limitations
//  under the License.

#import "LPConstants.h"
//#import "JRSwizzle.h"
#import "LPFileManager.h"
//#import "LPVarCache.h"
#import "Leanplum.h"
//#import "LeanplumRequest.h"
#include <dirent.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <unistd.h>
//#import "LPRequestFactory.h"
//#import "LPRequestSender.h"
//#import "LPCountAggregator.h"
//#import "LPFileTransferManager.h"

typedef enum {
    kLeanplumFileOperationGet = 0,
    kLeanplumFileOperationDelete = 1,
} LeanplumFileTraversalOperation;

NSString *appBundlePath;
BOOL initializing = NO;
BOOL hasInited = NO;
NSArray *possibleVariations;
NSMutableSet *directoryExistenceCache;
NSString *documentsDirectoryCached;
NSString *cachesDirectoryCached;
NSMutableSet *skippedFiles;
NSBundle *originalMainBundle;
//LeanplumVariablesChangedBlock resourceSyncingReady;

@implementation NSBundle (LeanplumExtension)

+ (NSBundle *)leanplum_mainBundle
{
    if (skippedFiles.count) {
        return [LPBundle bundleWithPath:[originalMainBundle bundlePath]];
    } else {
        return originalMainBundle;
    }
}

- (NSURL *)leanplum_appStoreReceiptURL
{
    return [originalMainBundle leanplum_appStoreReceiptURL];
}

@end

@implementation LPBundle

- (nullable instancetype)initWithPath:(NSString *)path
{
    return [super initWithPath:path];
}

- (NSURL *)URLForResource:(NSString *)name withExtension:(NSString *)ext
{
    NSURL *orig = [originalMainBundle URLForResource:name withExtension:ext];
    if (orig && [skippedFiles containsObject:[orig path]]) {
        return orig;
    }
    return [super URLForResource:name withExtension:ext];
}

- (NSURL *)URLForResource:(NSString *)name
            withExtension:(NSString *)ext
             subdirectory:(NSString *)subpath
{
    NSURL *orig = [originalMainBundle URLForResource:name withExtension:ext subdirectory:subpath];
    if (orig && [skippedFiles containsObject:[orig path]]) {
        return orig;
    }
    return [super URLForResource:name withExtension:ext subdirectory:subpath];
}

- (NSURL *)URLForResource:(NSString *)name
            withExtension:(NSString *)ext
             subdirectory:(NSString *)subpath
             localization:(NSString *)localizationName
{
    NSURL *orig = [originalMainBundle URLForResource:name
                                       withExtension:ext
                                        subdirectory:subpath
                                        localization:localizationName];
    if (orig && [skippedFiles containsObject:[orig path]]) {
        return orig;
    }
    return [super URLForResource:name
                   withExtension:ext
                    subdirectory:subpath
                    localization:localizationName];
}

- (NSArray *)URLsForResourcesWithExtension:(NSString *)ext subdirectory:(NSString *)subpath
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSURL *url in
         [originalMainBundle URLsForResourcesWithExtension:ext subdirectory:subpath]) {
        if ([skippedFiles containsObject:[url path]]) {
            [result addObject:url];
        }
    }
    [result addObjectsFromArray:[super URLsForResourcesWithExtension:ext subdirectory:subpath]];
    return result;
}

- (NSArray *)URLsForResourcesWithExtension:(NSString *)ext
                              subdirectory:(NSString *)subpath
                              localization:(NSString *)localizationName
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSURL *url in [originalMainBundle URLsForResourcesWithExtension:ext
                                                            subdirectory:subpath
                                                            localization:localizationName]) {
        if ([skippedFiles containsObject:[url path]]) {
            [result addObject:url];
        }
    }
    [result addObjectsFromArray:[super URLsForResourcesWithExtension:ext
                                                        subdirectory:subpath
                                                        localization:localizationName]];
    return result;
}

- (NSString *)pathForResource:(NSString *)name ofType:(NSString *)ext
{
    NSString *orig = [originalMainBundle pathForResource:name ofType:ext];
    if (orig && [skippedFiles containsObject:orig]) {
        return orig;
    }
    return [super pathForResource:name ofType:ext];
}

- (NSString *)pathForResource:(NSString *)name
                       ofType:(NSString *)ext
                  inDirectory:(NSString *)subpath
{
    NSString *orig = [originalMainBundle pathForResource:name ofType:ext inDirectory:subpath];
    if (orig && [skippedFiles containsObject:orig]) {
        return orig;
    }
    return [super pathForResource:name ofType:ext inDirectory:subpath];
}

- (NSString *)pathForResource:(NSString *)name
                       ofType:(NSString *)ext
                  inDirectory:(NSString *)subpath
              forLocalization:(NSString *)localizationName
{
    NSString *orig = [originalMainBundle pathForResource:name
                                                  ofType:ext
                                             inDirectory:subpath
                                         forLocalization:localizationName];
    if (orig && [skippedFiles containsObject:orig]) {
        return orig;
    }
    return [super pathForResource:name
                           ofType:ext
                      inDirectory:subpath
                  forLocalization:localizationName];
}

- (NSArray *)pathsForResourcesOfType:(NSString *)ext inDirectory:(NSString *)subpath
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *file in [originalMainBundle pathsForResourcesOfType:ext inDirectory:subpath]) {
        if ([skippedFiles containsObject:file]) {
            [result addObject:file];
        }
    }
    [result addObjectsFromArray:[super pathsForResourcesOfType:ext inDirectory:subpath]];
    return result;
}

- (NSArray *)pathsForResourcesOfType:(NSString *)ext
                         inDirectory:(NSString *)subpath
                     forLocalization:(NSString *)localizationName
{
    NSMutableArray *result = [NSMutableArray array];
    for (NSString *file in [originalMainBundle pathsForResourcesOfType:ext
                                                           inDirectory:subpath
                                                       forLocalization:localizationName]) {
        if ([skippedFiles containsObject:file]) {
            [result addObject:file];
        }
    }
    [result addObjectsFromArray:[super pathsForResourcesOfType:ext
                                                   inDirectory:subpath
                                               forLocalization:localizationName]];
    return result;
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value table:(NSString *)table
{
    NSString *result = [super localizedStringForKey:key value:value table:table];
    if (skippedFiles.count == 0) {
        return result;
    }
    if (![result isEqualToString:value]) {
        return result;
    }
    return [originalMainBundle localizedStringForKey:key value:value table:table];
}

@end

@implementation LPFileManager

+ (NSString *)appBundlePath
{
    if (!appBundlePath) {
        originalMainBundle = [NSBundle mainBundle];
        appBundlePath = [originalMainBundle resourcePath];
    }
    return appBundlePath;
}

/**
 * Returns the full path for the <Application_Home>/Documents directory, which is automatically
 * backed up by iCloud.
 *
 * Note: This should be used if you don't want the data to be deleted such as requests data.
 * In general all the assets like images and files should be stored in the cache directory.
 */
+ (NSString *)documentsDirectory
{
    if (!documentsDirectoryCached) {
        documentsDirectoryCached = [NSSearchPathForDirectoriesInDomains(
                                                                        NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    }
    //If Documents director does not exist , create one.
    if(![[NSFileManager defaultManager] fileExistsAtPath:documentsDirectoryCached]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:documentsDirectoryCached withIntermediateDirectories:true attributes:nil error:nil];
    }
    return documentsDirectoryCached;
}

/**
 * Returns the full path for the <Application_Home>/Library/Caches directory, which stores data
 * that can be downloaded again or regenerated, and is not automatically backed up by iCloud.
 */
+ (NSString *)cachesDirectory
{
    if (!cachesDirectoryCached) {
        cachesDirectoryCached = [NSSearchPathForDirectoriesInDomains(
                                                                     NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
        
        //        if ([self areDocumentsBackedUp]) {
        //            [self moveDoctumentsOutOfBackedUpLocation];
        //        }
    }
    return cachesDirectoryCached;
}

/**
 * Returns the full path of for the Leanplum_Resources directory, relative to `folder`.
 */
+ (NSString *)documentsPathRelativeToFolder:(nonnull NSString *)folder
{
    return [folder stringByAppendingPathComponent:LP_PATH_DOCUMENTS];
}

/**
 * Returns the full path of the Leanplum_Resources directory, relative to
 * <Application_Home>/Library/Caches
 */
+ (NSString *)documentsPath
{
    return [self documentsPathRelativeToFolder:[self cachesDirectory]];
}

/**
 * Returns the full path of for the Leanplum_Bundle directory, relative to `folder`.
 */
+ (NSString *)bundlePathRelativeToFolder:(NSString *)folder
{
    return [folder stringByAppendingPathComponent:LP_PATH_BUNDLE];
}

/**
 * Returns the full path of the Leanplum_Bundle directory, relative to
 * <Application_Home>/Library/Caches
 */
+ (NSString *)bundlePath
{
    return [self bundlePathRelativeToFolder:[self cachesDirectory]];
}

@end
