//
//  JJSRequest.h
//  JJSOptionalExam
//
//  Created by wu on 2018/8/3.
//  Copyright © 2018年 JJSHome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ RequestCompleteBlock) (BOOL success, id info);

typedef NS_ENUM(NSUInteger, JJSHttpMethod) {
    JJSHttpMethodGET = 0,
    JJSHttpMethodPOST,
};

typedef NS_ENUM(NSUInteger, JJSRequestSerializerType) {
    JJSRequestSerializerTypeJSON = 0,
    JJSRequestSerializerTypeHTTP = 1,
};

typedef NS_ENUM(NSInteger, JJSResponseSerializerType) {
    JJSResponseSerializerTypeHTTP = 0,
    JJSResponseSerializerTypeJSON,
};

@interface JJSRequest : NSObject

/**
 url
 */
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, assign) JJSRequestSerializerType requestSerializerType;
@property (nonatomic, assign) JJSResponseSerializerType responseSerializerType;

/**
 methodCode
 */
//@property (nonatomic, copy) NSString *methodCode;

@property (nonatomic, assign) JJSHttpMethod httpMethod;

/**
 params
 */
@property (nonatomic, copy) NSDictionary *params;

/**
 header
 */
@property (nonatomic, copy) NSDictionary *header;


@property (nonatomic, assign) NSURLSessionTaskState state;

/**
 timeout
 */
@property (nonatomic, assign) NSTimeInterval timeout;

/**
 requestTask
 */
@property (nonatomic, strong, readonly) NSURLSessionTask *requestTask;

@property (nonatomic, copy) id taskResponse;

/**
 返回的 response
 */
@property (nonatomic, copy) id responseObject;

/**
 返回的 response json 字符串
 */
@property (nonatomic, copy) id responseString;


@property (nonatomic, copy) NSError *error;

@property (nonatomic, copy) RequestCompleteBlock requestResultBlock;

/**
 是否忽略 baseUrl（不使用）
 */
@property (nonatomic, assign)  BOOL disabledBaseUrl;

@property (nonatomic, assign) NSUInteger version;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;


/// 获取 response
- (NSHTTPURLResponse *)response;

/// cancel
- (void)cancel;

/**
 设置 sessionTask
 */
- (void (^)(NSURLSessionTask *sessionTask))privateSetSecctionTask;
- (void)privateSetSecctionTask:(NSURLSessionTask *)sessionTask;

/**
 quickly init

 @param method GET or POST
 @param urlString urlString
 @param params params
 @param header header
 @param disabledBaseUrl 是否使用 baseUrl
 */
+ (instancetype)request:(JJSHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled;
+ (instancetype)request:(JJSHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header;

/**
 POST 请求精简版 （httpMethod 为POST， disabledBaseUrl 为 YES）

 @param urlString urlString
 @param params params
 @param header header
 */
+ (instancetype)request:(NSString *)urlString params:(id)params header:(id)header;


/// requestSerializer
- (id)requestSerializer;
/// requestSerializer
- (id)responseSerializer;

- (NSSet *)acceptableContentTypes;

@end
