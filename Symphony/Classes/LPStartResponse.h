//
//  LPResponse.h
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 3/27/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LPRegion;
@class LPMessage;

@interface LPStartResponse : NSObject

@property (nonatomic, strong) NSArray<LPRegion *> *regions;
@property (nonatomic, strong) NSArray<LPMessage *> *messages;

////@property (nonatomic, strong) LPActionDefinitions *actionDefinitions;
////@property (nonatomic, strong) LPFileAttributes *fileAttributes;
//@property (nonatomic, copy)   NSArray *interfaceEvents;
//@property (nonatomic, copy)   NSArray *interfaceRules;
//@property (nonatomic, assign) BOOL isRegistered;
//@property (nonatomic, assign) BOOL isRegisteredFromOtherApp;
//@property (nonatomic, assign) BOOL isSuccess;
//@property (nonatomic, assign) BOOL isSyncNewsfeed;
//@property (nonatomic, copy)   NSString *token;
//@property (nonatomic, copy)   NSString *uploadURL;
////@property (nonatomic, copy)   NSArray<LPVariant *> *variants;
////@property (nonatomic, strong) LPResponseVars *vars;
//@property (nonatomic, copy)   NSDictionary<NSString *, id> *varsFromCode;
@end
