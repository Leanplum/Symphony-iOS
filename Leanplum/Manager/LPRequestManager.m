//
//  LPRequestManager.m
//  Leanplum
//
//  Created by Hrishikesh Amravatkar on 6/18/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPRequestManager.h"
#import "LPStorageSQLite.h"
#import "LPJSON.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"
#import "LPRequestManager.h"
#import "LPRequest.h"

@implementation LPRequestManager

+ (void)addRequest:(LPRequest *)request
{
    NSString *query = @"INSERT INTO requests (data, requestId) VALUES (?,?);";
    NSArray *objectsToBind = @[[LPJSON stringFromJSON:[request createArgsDictionaryForRequest]], request.requestId];
    [[LPStorageSQLite sharedDatabase] runQuery:query bindObjects:objectsToBind];
}

+ (void)addRequests:(NSArray *)requests
{
    if (!requests.count) {
        return;
    }
    
    NSMutableString *query = [@"INSERT INTO requests (data, requestId) VALUES " mutableCopy];
    NSMutableArray *objectsToBind = [NSMutableArray new];
    [requests enumerateObjectsUsingBlock:^(id data, NSUInteger idx, BOOL *stop) {
        NSString *postfix = idx >= requests.count-1 ? @";" : @",";
        NSString *valueString = [NSString stringWithFormat:@"(?,?)%@", postfix];
        [query appendString:valueString];
        LPRequest *requestData = (LPRequest *)data;
        NSString *dataString = [LPJSON stringFromJSON:[requestData createArgsDictionaryForRequest]];
        [objectsToBind addObject:dataString];
        [objectsToBind addObject:requestData.requestId];
    }];
    [[LPStorageSQLite sharedDatabase] runQuery:query bindObjects:objectsToBind];

}

+ (NSArray *)requestsWithLimit:(NSInteger)limit
{
    NSString *query = [NSString stringWithFormat:@"SELECT data FROM requests ORDER BY rowid "
                       "LIMIT %ld", (long)limit];
    NSArray *rows = [[LPStorageSQLite sharedDatabase] rowsFromQuery:query];
    
    // Convert row data to event.
    NSMutableArray *requests = [NSMutableArray new];
    for (NSDictionary *row in rows) {
        NSDictionary *request = [LPJSON JSONFromString:row[@"data"]];
        if (!request || !request.count) {
            continue;
        }
        [requests addObject:[request mutableCopy]];
    }
    
    return requests;
}

+ (void)deleteRequestsWithLimit:(NSInteger)limit
{
    // Used to be 'DELETE FROM event ORDER BY rowid LIMIT x'
    // but iOS7 sqlite3 did not compile with SQLITE_ENABLE_UPDATE_DELETE_LIMIT.
    // Consider changing it back when we drop iOS7.
    NSString *query = [NSString stringWithFormat:@"DELETE FROM requests WHERE rowid IN "
                       "(SELECT rowid FROM requests ORDER BY rowid "
                       "LIMIT %ld);", (long)limit];
    [[LPStorageSQLite sharedDatabase] runQuery:query];
    
}

+ (NSInteger)count
{
    NSArray *rows = [[LPStorageSQLite sharedDatabase] rowsFromQuery:@"SELECT count(*) FROM requests;"];
    if (!rows || !rows.count) {
        return 0;
    }
    
    return [rows.firstObject[@"count(*)"] integerValue];
}

@end
