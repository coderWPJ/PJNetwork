//
//  PJRequest.m
//  PJNetwork
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import "PJRequest.h"
#import "PJNetworkConfig.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface PJRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@implementation PJRequest

// 设置 sessionTask
- (void (^)(NSURLSessionTask *sessionTask))privateSetSecctionTask
{
    return ^(NSURLSessionTask *sessionTask){
        [self privateSetSecctionTask:sessionTask];
    };
}

- (void)privateSetSecctionTask:(NSURLSessionTask *)sessionTask
{
    self.requestTask = sessionTask;
}

/// 当前 request 对应的 requestSerializer
- (id)requestSerializer
{
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    if (self.requestSerializerType == PJRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    }
    if (self.timeoutInterval > 0) {
        requestSerializer.timeoutInterval = self.timeoutInterval;
    } else {
        requestSerializer.timeoutInterval = [PJNetworkConfig shareConfig].timeoutInterval;
    }
    requestSerializer.allowsCellularAccess = !PJNetworkConfig.cellularDisabled();
    
    return requestSerializer;
}

- (id)responseSerializer
{
    if (self.responseSerializerType == PJResponseSerializerTypeJSON) {
        return [AFJSONResponseSerializer serializer];
    } else {
        return [AFHTTPResponseSerializer serializer];
    }
}

- (instancetype)initWithMethod:(PJHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled
{
    self = [super init];
    if (self) {
        self.urlString = urlString;
        self.httpMethod = httpMethod;
        
        if ([params isKindOfClass:[NSDictionary class]]) {
            self.params = params;
        }
        if ([header isKindOfClass:[NSDictionary class]]) {
            self.header = header;
        }
        self.disabledBaseUrl = disabled;
        
        // 设置数据类型
        self.requestSerializerType = PJRequestSerializerTypeHTTP;
        self.responseSerializerType = PJResponseSerializerTypeJSON;
        
        self.timeoutInterval = -1;
    }
    return self;
}

- (NSSet *)acceptableContentTypes {
    return [NSSet setWithObjects:
            @"text/html",
            @"text/json",
            @"application/json",
            @"text/javascript",
            @"image/jpeg",
            @"text/plain", nil];
}

+ (instancetype)request:(PJHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled
{
    return [[PJRequest alloc] initWithMethod:httpMethod urlString:urlString params:params header:header disabledBaseUrl:disabled];
}

+ (instancetype)request:(PJHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header
{
    return [[PJRequest alloc] initWithMethod:httpMethod urlString:urlString params:params header:header disabledBaseUrl:NO];
}

+ (instancetype)request:(NSString *)urlString params:(id)params header:(id)header
{
    return [[PJRequest alloc] initWithMethod:PJHttpMethodPOST urlString:urlString params:params header:header disabledBaseUrl:NO];
}

- (void)cancel
{
    if ([self isCancelled]) {
        return;
    }
    [self.requestTask cancel];
}

- (NSURLSessionTaskState)state
{
    if (!self.requestTask) {
        return NSURLSessionTaskStateCompleted;
    }
    return self.requestTask.state;
}

#pragma mark - Request and Response Information

- (NSHTTPURLResponse *)response {
    if (!self.requestTask) {
        return nil;
    }
    return (NSHTTPURLResponse *)self.requestTask.response;
}

- (NSInteger)responseStatusCode {
    return self.response.statusCode;
}

- (NSDictionary *)responseHeaders {
    return self.response.allHeaderFields;
}

- (NSURLRequest *)currentRequest {
    return self.requestTask.currentRequest;
}

- (NSURLRequest *)originalRequest {
    return self.requestTask.originalRequest;
}

- (BOOL)isCancelled {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateCanceling;
}

- (BOOL)isExecuting {
    if (!self.requestTask) {
        return NO;
    }
    return self.requestTask.state == NSURLSessionTaskStateRunning;
}

@end
