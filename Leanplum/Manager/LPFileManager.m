#import "LPConstants.h"
#import "LPFileManager.h"
#import "Leanplum.h"
#include <dirent.h>
#import <objc/message.h>
#import <objc/runtime.h>
#include <unistd.h>

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

@end
