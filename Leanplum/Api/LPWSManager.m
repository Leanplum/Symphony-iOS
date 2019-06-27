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
#import "LPJSON.h"
#import "LPErrorHelper.h"

@interface LPWSManager () {
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
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
    
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
    
    NSString *languageHeader = [NSString stringWithFormat:@"%@, %@",
                                [[NSLocale preferredLanguages] componentsJoinedByString:@", "], LP_EN_US];
    
    return @{LP_USER_AGENT: userAgentString,
             LP_ACCEPT_LANGUAGE : languageHeader,
             LP_ACCEPT_ENCODING : LEANPLUM_SUPPORTED_ENCODING,
             LP_PARAM_TIME : timestamp};
}

- (NSString *)generateEncodedQueryString:(NSDictionary *)params withAction:(NSString *)action {
    NSMutableString *queryString = [NSMutableString string];
    NSString *appIdParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_APP_ID, [LPAPIConfig sharedConfig].appId];
    [queryString appendString:appIdParamString];
    NSString *clientKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_CLIENT_KEY, [LPAPIConfig sharedConfig].accessKey];
    [queryString appendString:clientKeyParamString];
    NSString *actionKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_KIND_ACTION,action];
    [queryString appendString:actionKeyParamString];
    NSString *apiVersionKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_API_VERSION,LEANPLUM_API_VERSION];
    [queryString appendString:apiVersionKeyParamString];
    NSString *sdkVersionKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_SDK_VERSION,[LPApiConstants sharedState].sdkVersion];
    [queryString appendString:sdkVersionKeyParamString];
    NSString *clientParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_CLIENT,[LPApiConstants sharedState].client];
    [queryString appendString:clientParamString];
    NSString *timeKeyParamString = [NSString stringWithFormat:@"%@=%@&", LP_PARAM_TIME,[NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]]];
    [queryString appendString:timeKeyParamString];
    if (params) {
        for (id key in params) {
            id value = params[key];
            NSString *paramString = [NSString stringWithFormat:@"%@=%@&", key, value];
            [queryString appendString:paramString];
        }
    }
    return queryString;
}

#pragma mark - Web Service Requests

- (NSMutableURLRequest *)createGETRequest:(NSString *)webservice withParams:(NSDictionary *)params {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", webservice, [self generateEncodedQueryString:params withAction:webService]];
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"Get request URL %@",url);
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    return request;
}

- (NSMutableURLRequest *)createPOSTRequest:(NSString *)webservice withParams:(NSDictionary *)params withAction:(NSString *)action {
    NSURL *url = [NSURL URLWithString:webservice];
    NSMutableURLRequest *request  = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[[self generateEncodedQueryString:params withAction:action] dataUsingEncoding:NSUTF8StringEncoding]];
    return request;
}

#pragma mark - pointsofinterest Web service
- (void)setupWebService {
    LPApiConstants *lpApiConstants = LPApiConstants.sharedState;
    webService = [NSString stringWithFormat:@"https://%@/api?", lpApiConstants.apiHostName];
}

- (void)sendGETWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousGETWebService");
    [self setupWebService];
    NSMutableURLRequest *request = [self createGETRequest:webService withParams:params];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:[LPApiConstants sharedState].networkTimeoutSeconds];
    
    [self executeWebServiceRequest:request successBlock:success failureBlock:failure];
}

- (void)sendPOSTWebService:(NSString*)service withParams:(NSMutableDictionary *)params successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSLog(@"sendAsynchronousPOSTWebService");
    [self setupWebService];
    NSLog(@"Api Call %@ with params %@", service, params);
    NSMutableURLRequest *request = [self createPOSTRequest:webService withParams:params withAction:service];
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setTimeoutInterval:[LPApiConstants sharedState].networkTimeoutSeconds];
    
    [self executeWebServiceRequest:request successBlock:success failureBlock:failure];
}

- (void)executeWebServiceRequest:(NSURLRequest *)request successBlock:(void (^)(NSDictionary *))success failureBlock:(void (^)(NSError *))failure {
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request
                                            completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      // handle basic connectivity issues here
                                      if (error) {
                                          NSLog(@"dataTaskWithRequest error: %@", error);
                                          failure(error);
                                      } else {
                                          NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                          NSError *parseError = nil;
                                          NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                          if (httpResponse.statusCode == 200) {
                                              //NSString *myString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
                                              //NSLog(@"String data %@", myString);
                                              NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&parseError];
                                              NSLog(@"The response is - %@",responseDictionary);
                                              success(responseDictionary);
                                          } else {
                                              // Handle unsuccessful http response code.
                                              NSLog(@"http error");
                                              // make custom error
                                              NSArray *responseArray = [responseDictionary valueForKey:@"response"];
                                              NSDictionary *resultDict = responseArray[0];
                                              NSError *responseError = [LPErrorHelper makeHttpError:httpResponse.statusCode  withResponseDict:resultDict];
                                              failure(responseError);
                                          }
                                      }
                                  }];
    [task resume];
}

@end
