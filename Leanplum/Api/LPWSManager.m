//
//  LPWSManager.m
//  Symphony
//
//  Created by Hrishikesh Amravatkar on 4/5/19.
//  Copyright © 2019 Leanplum. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPWSManager.h"
#import "NSString+NSString_Extended.h"
#import "LPApiConstants.h"
#import "LPAPIConfig.h"
#import "LPConstants.h"

@interface LPWSManager () {
    void (^returnSuccess)(NSDictionary *);
    void (^returnFail)(NSError *);
    NSString *webService;
    NSURLSessionConfiguration *sessionConfiguration;
}
@end

@implementation LPWSManager

/**
 * Initialize default NSURLSession. Should not be used in public.
 */
- (id)init
{
    if (self = [super init]) {
        sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.URLCache = nil;
        sessionConfiguration.URLCredentialStorage = nil;
        sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringLocalCacheData;
        sessionConfiguration.HTTPAdditionalHeaders = [self createHeaders];
    }
    return self;
}

- (NSDictionary *)createHeaders {
    NSDictionary *infoDict = [[NSBundle mainBundle] infoDictionary];
    NSString *userAgentString = [NSString stringWithFormat:@"%@/%@/%@/%@/%@/%@/%@/%@/%@",
                                 infoDict[(NSString *)kCFBundleNameKey],
                                 infoDict[(NSString *)kCFBundleVersionKey],
                                 [LPAPIConfig sharedConfig].appId,
                                 LEANPLUM_CLIENT,
                                 LEANPLUM_SDK_VERSION,
                                 [[UIDevice currentDevice] systemName],
                                 [[UIDevice currentDevice] systemVersion],
                                 LEANPLUM_SUPPORTED_ENCODING,
                                 LEANPLUM_PACKAGE_IDENTIFIER];
    
    NSString *languageHeader = [NSString stringWithFormat:@"%@, en-us",
                                [[NSLocale preferredLanguages] componentsJoinedByString:@", "]];
    
    return @{@"User-Agent": userAgentString, @"Accept-Language" : languageHeader, @"Accept-Encoding" : LEANPLUM_SUPPORTED_ENCODING};
}

- (NSString *)generateEncodedQueryString:(NSDictionary *)userParams {
    NSMutableString *queryString = [NSMutableString string];
    if (userParams != nil) {
        for (id key in userParams) {
            id value = userParams[key];
            NSString *paramString = [NSString stringWithFormat:@"%@=%@&", key, value];
            paramString = [paramString urlencode];
            [queryString appendString:paramString];
        }
    }
    NSString *appIdParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_APP_ID, [LPAPIConfig sharedConfig].appId];
    appIdParamString = [appIdParamString urlencode];
    [queryString appendString:appIdParamString];
    
    NSString *clientKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_CLIENT_KEY, [LPAPIConfig sharedConfig].accessKey];
    clientKeyParamString = [clientKeyParamString urlencode];
    [queryString appendString:clientKeyParamString];
    
    return queryString;
}

#pragma mark - Web Service Requests

- (NSMutableURLRequest *)createGETRequest:(NSString *)webservice withParams:(NSDictionary *)userParams {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", webservice, [self generateEncodedQueryString:userParams]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"Get request URL %@",url);
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)createPOSTRequest:(NSString *)webservice withParams:(NSDictionary *)userParams {
    NSURL *url = [NSURL URLWithString:webservice];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[self generateEncodedQueryString:userParams]];
    return request;
}

#pragma mark - pointsofinterest Web service
- (void)setupWebService:(NSString *)service {
    LPApiConstants *lpApiConstants = LPApiConstants.sharedState;
    webService = [NSString stringWithFormat:@"https://%@?action=%@?", lpApiConstants.apiHostName, service];
}

- (void)sendGETWebService:(NSString*)service userParams:(NSMutableDictionary *)userParams successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousGETWebService");
    [self setupWebService:service];
    returnSuccess = success;
    returnFail = failure;
    NSMutableURLRequest *request = [self createGETRequest:webService withParams:userParams];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:60];
 
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                      if(httpResponse.statusCode == 200) {
                                          NSError *parseError = nil;
                                          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                          NSLog(@"The response is - %@",responseDictionary);
                                          success(responseDictionary);
                                      } else {
                                          NSLog(@"Error");
                                          if (error != nil) {
                                              failure(error);
                                          }
                                          //ToDo: Create custom errors, make a default class for based on common errors.
                                          failure(nil);
                                      }
                                  }];
    [task resume];
}

- (void)sendPOSTWebService:(NSString*)service userParams:(NSMutableDictionary *)userParams successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousPOSTWebService");
    [self setupWebService:service];
    returnSuccess = success;
    returnFail = failure;
    NSLog(@"Api Call %@ with params %@", service, userParams);
    NSMutableURLRequest *request = [self createGETRequest:webService withParams:userParams];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:60];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                      if(httpResponse.statusCode == 200) {
                                          NSError *parseError = nil;
                                          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                          NSLog(@"The response is - %@",responseDictionary);
                                          success(responseDictionary);
                                      } else {
                                          NSLog(@"Error");
                                          if (error != nil) {
                                              failure(error);
                                          }
                                          //ToDo: Create custom errors, make a default class for based on common errors.
                                          failure(nil);
                                      }
                                  }];
    [task resume];
}
@end
