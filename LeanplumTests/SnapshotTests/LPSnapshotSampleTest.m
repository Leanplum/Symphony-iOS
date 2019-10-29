#import <XCTest/XCTest.h>
#import "LPFileManager.h"
#import "LPConstants.h"
#import <FBSnapshotTestCase/FBSnapshotTestCase.h>

@interface LPSnapshotSampleTest : FBSnapshotTestCase

@end

@implementation LPSnapshotSampleTest

- (void)setUp
{
    [super setUp];
//    self.recordMode = YES;
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_sample
{
    UIView *new = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    new.backgroundColor = [UIColor redColor];
    FBSnapshotVerifyView(new, nil);
}

@end
