#import <XCTest/XCTest.h>
#import "LPFileManager.h"
#import "LPConstants.h"

/**
 * Tests file manager public methods.
 */
@interface LPFileManagerTest : XCTestCase

@end

@implementation LPFileManagerTest

+ (void)setUp
{
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)test_documentsDirectory
{
    NSString *result = [LPFileManager documentsDirectory];
    XCTAssertNotNil(result);
}

- (void)test_appBundle
{
    NSString *result = [LPFileManager appBundlePath];
    XCTAssertNotNil(result);
}


@end
