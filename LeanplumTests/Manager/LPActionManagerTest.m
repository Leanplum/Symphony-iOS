#import <XCTest/XCTest.h>
#import <OCMock/OCMock.h>
#import "LPActionManager.h"
#import "LPTestHelper.h"
#import "Leanplum+Extensions.h"
#import "LPWSManager+Categories.h"
#import "LPDeviceApi+Categories.h"
#import "LPSwizzle.h"
#import "LPRequestManager.h"

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
    [LPApiConstants sharedState].isMulti = NO;
    [LPDeviceApi swizzle_methods];
}

+ (void)tearDown
{
    [super tearDown];
    [LPDeviceApi swizzle_methods];
    [LPRequestManager deleteRequestsWithLimit:1000];
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
    LPActionManager *manager = [LPActionManager sharedManager];
    
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

    [LPDeviceApi validate_onResponse:^(NSDictionary *response) {
        [expectNewToken fulfill];
    }];
    [manager leanplum_application:app didRegisterForRemoteNotificationsWithDeviceToken:token];
    [self waitForExpectationsWithTimeout:2 handler:nil];
}

@end
