//
//  JJSRequest.m
//  JJSOptionalExam
//
//  Created by wu on 2018/8/3.
//  Copyright © 2018年 JJSHome. All rights reserved.
//

#import "JJSRequest.h"
#import <AFNetworking.h>
#import "JJSNetworkConfig.h"

@interface JJSRequest ()

@property (nonatomic, strong, readwrite) NSURLSessionTask *requestTask;

@end

@implementation JJSRequest

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
    AFHTTPRequestSerializer *requestSerializer = nil;
    if (self.requestSerializerType == JJSRequestSerializerTypeJSON) {
        requestSerializer = [AFJSONRequestSerializer serializer];
    } else {
        requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    requestSerializer.timeoutInterval = self.timeout;
    requestSerializer.allowsCellularAccess = JJSNetworkConfig.cellularDisabled();
    
    
    
    return requestSerializer;
}

- (id)responseSerializer
{
    if (self.responseSerializerType == JJSResponseSerializerTypeJSON) {
        return [AFJSONResponseSerializer serializer];
    } else {
        return [AFHTTPResponseSerializer serializer];
    }
}

- (instancetype)initWithMethod:(JJSHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled
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
        self.timeout = 30.0f;
        
        // 设置数据类型
        self.requestSerializerType = JJSRequestSerializerTypeJSON;
        self.responseSerializerType = JJSResponseSerializerTypeJSON;
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

+ (instancetype)request:(JJSHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled
{
    return [[JJSRequest alloc] initWithMethod:httpMethod urlString:urlString params:params header:header disabledBaseUrl:disabled];
}

+ (instancetype)request:(JJSHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header
{
    return [[JJSRequest alloc] initWithMethod:httpMethod urlString:urlString params:params header:header disabledBaseUrl:NO];
}

+ (instancetype)request:(NSString *)urlString params:(id)params header:(id)header
{
    return [[JJSRequest alloc] initWithMethod:JJSHttpMethodPOST urlString:urlString params:params header:header disabledBaseUrl:NO];
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
