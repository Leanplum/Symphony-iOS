//
//  LPWSManager.m
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import "LPWSManager.h"
#import "NSString+NSString_Extended.h"

@interface LPWSManager () {
    void (^returnSuccess)(NSDictionary *);
    void (^returnFail)(NSError *);
    NSString *webService;
    NSMutableDictionary *params;
}
@end

@implementation LPWSManager

#pragma mark - Web Service Requests

- (NSMutableURLRequest *)createGETRequest:(NSString *)webservice withParams:(NSDictionary *)userParams {
    NSMutableString *queryString = [NSMutableString string];
    if (userParams != nil) {
        for (id key in userParams) {
            id value = userParams[key];
            NSString *paramString = [NSString stringWithFormat:@"%@=%@&", key, value];
            paramString = [paramString urlencode];
            [queryString appendString:paramString];
        }
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@", webservice, queryString];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"Get request URL %@",url);
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)createPOSTRequest:(NSString *)webservice withParams:(NSDictionary *)userParams {
    
    NSMutableString *queryString = [NSMutableString string];
    if (userParams != nil) {
        for (id key in userParams) {
            id value = userParams[key];
            NSString *paramString = [NSString stringWithFormat:@"%@=%@&", key, value];
            paramString = [paramString urlencode];
            [queryString appendString:paramString];
        }
    }
    NSURL *url = [NSURL URLWithString:webservice];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[queryString dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

#pragma mark - pointsofinterest Web service
- (void)setupWebService {
    params = [[NSMutableDictionary alloc] init];
}

- (void)sendGETWebService:(NSString*)service userParams:(NSMutableDictionary *)userParams successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousGETWebService");
    [self setupWebService];
    returnSuccess = success;
    returnFail = failure;
    //webService = [NSString stringWithFormat:@"%@%@?", Utils.getBaseURL, service];
    //[params addEntriesFromDictionary:userParams];
    NSLog(@"Api Call %@ with params %@", service, params);
    NSMutableURLRequest *request = [self createGETRequest:webService withParams:params];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:60];
    //[self requestAsynchronousWebService:request];
}

- (void)sendPOSTWebService:(NSString*)service userParams:(NSMutableDictionary *)userParams successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousPOSTWebService");
    [self setupWebService];
    returnSuccess = success;
    returnFail = failure;
    //webService = [NSString stringWithFormat:@"%@%@?", Utils.getBaseURL, service];
    //[params addEntriesFromDictionary:userParams];
    NSLog(@"Api Call %@ with params %@", service, params);
    NSMutableURLRequest *request = [self createGETRequest:webService withParams:params];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:60];
    //[self requestAsynchronousWebService:request];
}
@end
