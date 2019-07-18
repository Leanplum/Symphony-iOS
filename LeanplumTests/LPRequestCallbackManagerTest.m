//
//  LPRequestCallbackManagerTest.m
//  LeanplumTests
//
//  Created by Grace on 6/19/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LPRequestCallbackManager.h"

@interface LPRequestCallbackManager(UnitTest)

@property (nonatomic, copy) NSMutableDictionary *successBlocks;
@property (nonatomic, copy) NSMutableDictionary *failureBlocks;

- (void)removeCallbackByRequestId:(NSString *)requestId;

@end

@interface LPRequestCallbackManagerTest : XCTestCase

@end

@implementation LPRequestCallbackManagerTest {
    LPRequestCallbackManager *_callbackManager;
    void (^successCallback)(NSDictionary *dictionary);
    void (^failureCallback)(NSError *err);
    void (^successCallback2)(NSDictionary *dictionary);
    void (^failureCallback2)(NSError *err);
}

- (void)setUp {
    [super setUp];
    _callbackManager = [[LPRequestCallbackManager alloc] init];
    successCallback = ^(NSDictionary *dict) {
        if (dict) {
            NSLog(@"dict not nil");
        }
    };
    failureCallback = ^(NSError *err) {
        if (err) {
            NSLog(@"err not nil");
        }
    };
    NSString *requestId = @"abc";
    [_callbackManager add:requestId onSuccess:successCallback onFailure:failureCallback];
    successCallback2 = ^(NSDictionary *dict) {
        if (dict) {
            NSLog(@"dict not nil");
        }
    };
    failureCallback2 = ^(NSError *err) {
        if (err) {
            NSLog(@"err not nil");
        }
    };
    NSString *requestId2 = @"efg";
    [_callbackManager add:requestId2 onSuccess:successCallback2 onFailure:failureCallback2];
}

- (void)tearDown {
    [super tearDown];
    _callbackManager = nil;
}

- (void)testAdd {
    XCTAssertEqualObjects(_callbackManager.successBlocks[@"abc"], successCallback);
    XCTAssertEqualObjects(_callbackManager.failureBlocks[@"abc"], failureCallback);
}

- (void)testRetrieveSuccessByRequestId {
    void (^retrievedCallback) (NSDictionary *) = [_callbackManager retrieveSuccessByRequestId:@"abc"];
    XCTAssertEqualObjects(successCallback, retrievedCallback);
}

- (void)testRetrieveFailureByRequestId {
    void (^retrievedCallback) (NSError *) = [_callbackManager retrieveFailureByRequestId:@"abc"];
    XCTAssertEqualObjects(failureCallback, retrievedCallback);
}

- (void)testRemoveCallbackByRequestId {
    [_callbackManager removeCallbackByRequestId:@"abc"];
    XCTAssertNil(_callbackManager.successBlocks[@"abc"]);
    XCTAssertNil(_callbackManager.failureBlocks[@"abc"]);
}

- (void)testClearSuccessBlocks {
    NSDictionary *expectedBlocks = @{
                                     @"abc" : _callbackManager.successBlocks[@"abc"],
                                     @"efg" : _callbackManager.successBlocks[@"efg"],
                                    };
    NSDictionary *successBlocks = [_callbackManager clearSuccessBlocks];
    
    XCTAssertEqualObjects(successBlocks, expectedBlocks);
    XCTAssertEqual(0, [_callbackManager.successBlocks count]);
    XCTAssertEqual(2, [_callbackManager.failureBlocks count]);
}

- (void)testClearFailureBlocks {
    NSDictionary *expectedBlocks = @{
                                     @"abc" : _callbackManager.failureBlocks[@"abc"],
                                     @"efg" : _callbackManager.failureBlocks[@"efg"],
                                     };
    NSDictionary *failureBlocks = [_callbackManager clearFailureBlocks];
    
    XCTAssertEqualObjects(failureBlocks, expectedBlocks);
    XCTAssertEqual(0, [_callbackManager.failureBlocks count]);
    XCTAssertEqual(2, [_callbackManager.successBlocks count]);
}

@end
