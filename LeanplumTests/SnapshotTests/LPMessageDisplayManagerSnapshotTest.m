#import <XCTest/XCTest.h>
#import "LPAlertMessage.h"
#import "LPMessageDisplayManager.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface LPMessageDisplayManagerSnapshotTest : FBSnapshotTestCase

@end

@interface LPMessageDisplayManager()

-(UIAlertController *)create:(LPAlertMessage *)message;

@end

@implementation LPMessageDisplayManagerSnapshotTest

- (void)setUp
{
    [super setUp];
//    self.recordMode = YES;
}

- (void)tearDown {
    [super tearDown];
}

- (void)testAlert {
    LPAlertMessage *alert = [LPAlertMessage alertMessageWithTitle:@"Test Title" message:@"Test message goes here" dismissText:@"Ah dun wan et" dismissAction:nil];
    LPMessageDisplayManager *manager = [[LPMessageDisplayManager alloc] init];
    UIAlertController *controller = [manager create:alert];
    FBSnapshotVerifyView(controller.view, nil);
}

@end
