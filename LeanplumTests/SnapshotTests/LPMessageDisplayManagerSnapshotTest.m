#import <XCTest/XCTest.h>
#import "LPAlertMessage.h"
#import "LPConfirmationMessage.h"
#import "LPMessageDisplayManager.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface LPMessageDisplayManagerSnapshotTest : FBSnapshotTestCase

@end

@interface LPMessageDisplayManager()

-(UIAlertController *)createAlert:(LPAlertMessage *)message;
-(UIAlertController *)createConfirmation:(LPConfirmationMessage *)message;

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
    UIAlertController *controller = [manager createAlert:alert];
    FBSnapshotVerifyView(controller.view, nil);
}

- (void)testConfirmation {
    LPConfirmationMessage *confirmation = [LPConfirmationMessage
                                           confirmationMessageWithTitle:@"title"
                                           message:@"message"
                                           acceptText:@"acceptText"
                                           acceptAction:@"acceptAction"
                                           cancelText:@"cancelText"
                                           cancelAction:@"cancelAction"];

    LPMessageDisplayManager *manager = [[LPMessageDisplayManager alloc] init];
    UIAlertController *controller = [manager createConfirmation:confirmation];
    FBSnapshotVerifyView(controller.view, nil);
}

@end
