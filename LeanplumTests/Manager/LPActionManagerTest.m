#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "LPActionManager.h"
#import "LPTestHelper.h"
#import "Leanplum+Extensions.h"
#import "LPWSManager+Categories.h"

@interface LPActionManager (Test)
- (void)sendUserNotificationSettingsIfChanged:(UIUserNotificationSettings *)notificationSettings;
- (void)didReceiveRemoteNotification:(NSDictionary *)userInfo
                          withAction:(NSString *)action
              fetchCompletionHandler:(LeanplumFetchCompletionBlock)completionHandler;
- (void)leanplum_application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken;
@end

@interface LPActionManagerTest : XCTestCase

@end

@implementation LPActionManagerTest

+ (void)setUp
{
    [super setUp];
    // Called only once to setup method swizzling.
    //[LeanplumHelper setup_method_swizzling];
    [LPWSManager swizzle_methods];
}

- (void)setUp
{
    [super setUp];
    // Automatically sets up AppId and AccessKey for development mode.
    [LPTestHelper setup];
}

- (void)tearDown
{
    [super tearDown];
}


- (void) test_receive_notification
{
    NSDictionary* userInfo = @{
                               @"_lpm": @"messageId",
                               @"_lpx": @"test_action",
                               @"aps" : @{@"alert": @"test"}};
    
    XCTestExpectation* expectation = [self expectationWithDescription:@"notification"];
    
    [[LPActionManager sharedManager] didReceiveRemoteNotification:userInfo
                                                       withAction:@"test_action"
                                           fetchCompletionHandler:
     ^(LeanplumUIBackgroundFetchResult result) {
         [expectation fulfill];
     }];
    [self waitForExpectationsWithTimeout:10 handler:nil];
}

- (void)test_push_token
{
    //ToDo:
    /*
    // Partial mock Action Manager.
    LPActionManager *manager = [LPActionManager sharedManager];
    id actionManagerMock = OCMPartialMock(manager);
    OCMStub([actionManagerMock sharedManager]).andReturn(actionManagerMock);
    OCMStub([actionManagerMock respondsToSelector:
             @selector(leanplum_application:didRegisterForRemoteNotificationsWithDeviceToken:)]).andReturn(NO);
    
    // Remove Push Token.
    NSString *pushTokenKey = [Leanplum pushTokenKey];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:pushTokenKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    // Test push token is sent on clean start.-97h 
    UIApplication *app = [UIApplication sharedApplication];
    XCTestExpectation *expectNewToken = [self expectationWithDescription:@"expectNewToken"];
    NSData *token = [@"sample" dataUsingEncoding:NSUTF8StringEncoding];
    NSString *formattedToken = [token description];
    formattedToken = [[[formattedToken stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];

    [LPWSManager validate_onResponse:^(NSDictionary *response) {
        [expectNewToken fulfill];
    }];
    
    // Test push token is sent if the token changes.
    token = [@"sample2" dataUsingEncoding:NSUTF8StringEncoding];
    formattedToken = [token description];
    formattedToken = [[[formattedToken stringByReplacingOccurrencesOfString:@"<" withString:@""]
                       stringByReplacingOccurrencesOfString:@">" withString:@""]
                      stringByReplacingOccurrencesOfString:@" " withString:@""];
    XCTestExpectation *expectUpdatedToken = [self expectationWithDescription:@"expectUpdatedToken"];
    [LPWSManager validate_onResponse:^(NSDictionary *response) {
        [expectNewToken fulfill];
    }];
    [manager leanplum_application:app didRegisterForRemoteNotificationsWithDeviceToken:token];
     */
}


@end
