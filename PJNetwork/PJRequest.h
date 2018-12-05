//
//  PJRequest.h
//  PJNetwork
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ PJRequestCompleteBlock) (BOOL success, id info);

typedef NS_ENUM(NSUInteger, PJHttpMethod) {
    PJHttpMethodGET = 0,
    PJHttpMethodPOST,
};

typedef NS_ENUM(NSUInteger, PJRequestSerializerType) {
    PJRequestSerializerTypeJSON = 0,
    PJRequestSerializerTypeHTTP = 1,
};

typedef NS_ENUM(NSInteger, PJResponseSerializerType) {
    PJResponseSerializerTypeHTTP = 0,
    PJResponseSerializerTypeJSON,
};

@interface PJRequest : NSObject

/**
 url
 */
@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, assign) PJRequestSerializerType requestSerializerType;
@property (nonatomic, assign) PJResponseSerializerType responseSerializerType;

/**
 methodCode
 */
//@property (nonatomic, copy) NSString *methodCode;

@property (nonatomic, assign) PJHttpMethod httpMethod;

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

@property (nonatomic, copy) PJRequestCompleteBlock requestResultBlock;

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
 
 @param httpMethod PJHttpMethodGET or PJHttpMethodPOST
 @param urlString urlString
 @param params params
 @param header header
 @param disabled 是否使用 baseUrl
 */
+ (instancetype)request:(PJHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled;
+ (instancetype)request:(PJHttpMethod)httpMethod urlString:(NSString *)urlString params:(id)params header:(id)header;

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
