//
//  PJNetworkStation.m
//  PJNetwork
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import "PJNetworkStation.h"
#import "PJNetworkConfig.h"
#import <pthread/pthread.h>
#import "PJNetworkSessionManager.h"
#import "PJ_Reachability.h"

#if __has_include(<AFNetworking/AFNetworking.h>)
    #import <AFNetworking/AFNetworking.h>
#else
    #import "AFNetworking.h"
#endif

#define Lock() pthread_mutex_lock(&_lock)
#define Unlock() pthread_mutex_unlock(&_lock)

NSString *const PJNetwork_VCDealloc_Notitication = @"PJNetwork_VCDealloc_Notitication";

@interface PJNetworkStation ()
{
    pthread_mutex_t _lock;
    PJNetworkConfig *_config;
}

/// sessionManager
@property (nonatomic, strong) PJNetworkSessionManager *sessionManager;

/// 所有请求字典  格式为： @{task.taskIdentifier : PJRequest}
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, PJRequest *> *allRequestList;

/// 绑定过 VC 的请求
@property (nonatomic, strong) NSMutableDictionary <NSNumber *, NSArray *> *recordVCRequestList;

@end

@implementation PJNetworkStation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.sessionManager = [PJNetworkSessionManager manager];
        AFSecurityPolicy *securityPolicy =  [AFSecurityPolicy defaultPolicy];
        securityPolicy.allowInvalidCertificates = [PJNetworkConfig shareConfig].allowInvalidCertificates;
        securityPolicy.validatesDomainName = [PJNetworkConfig shareConfig].validatesDomainName;
        self.sessionManager.securityPolicy = securityPolicy;
        
        _allRequestList = @{}.mutableCopy;
        _recordVCRequestList = @{}.mutableCopy;
        _config = [PJNetworkConfig shareConfig];
        pthread_mutex_init(&_lock, NULL);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PJViewcontrollerDealloc:) name:PJNetwork_VCDealloc_Notitication object:nil];
    }
    return self;
}

- (void)PJViewcontrollerDealloc:(NSNotification *)notifi
{
    NSDictionary *userInfo = notifi.userInfo;
    if ([userInfo.allKeys containsObject:@"VCHash"]) {
        // 根据hash值找到对应请求数组，并终止符合条件的请求
        id hashObj = userInfo[@"VCHash"];
        if ([_recordVCRequestList.allKeys containsObject:hashObj]) {
            NSArray *requestArrayInVC = _recordVCRequestList[hashObj];
            int flag = 1;
            for (PJRequest *request in requestArrayInVC) {
                if (request.requestTask) {
                    if ((request.requestTask.state == NSURLSessionTaskStateRunning) || (request.requestTask.state == NSURLSessionTaskStateSuspended)) {
                        [request.requestTask cancel];
//                        NSLog(@"第%d个请求被取消了，标识是：%ld", flag, request.requestTask.taskIdentifier);
                    }
                }
                flag += 1;
            }
            if (flag == requestArrayInVC.count) {
                [_recordVCRequestList removeObjectForKey:hashObj];
            }
        }
    }
}

+ (instancetype)shareStation
{
    static id shareStation = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareStation = [[self alloc] init];
    });
    return shareStation;
}

+ (void)request:(PJRequest *)request result:(PJRequestCompleteBlock)result
{
    [[PJNetworkStation shareStation] startRequest:request result:result];
}

/// 开始请求
- (void)startRequest:(PJRequest *)request result:(PJRequestCompleteBlock)result
{
    PJ_Reachability *reachability   = [PJ_Reachability reachabilityWithHostName:@"www.apple.com"];
    /// 当蜂窝网络不可用时
    if (([reachability currentReachabilityStatus] == ReachableViaWWAN) && PJNetworkConfig.cellularDisabled()) {
        if (result) {
            result(NO, @{@"code":@(-9103), @"des":@"Cellular is disabled!"});
        }
        return;
    }
    if ([reachability currentReachabilityStatus] == NotReachable) {
        if (result) {
            result(NO, @{@"code":@(-9102), @"des":@"Network is unreachable!"});
        }
        return;
    }
    NSParameterAssert(request != nil);
    request.requestResultBlock = result;
    
    NSError * __autoreleasing requestSerializationError = nil;
    Lock();
    NSURLSessionTask *dataTask = [self sessionTaskForRequest:request error:&requestSerializationError];
    Unlock();
    if (!dataTask) {
        return;
    }
    if (requestSerializationError) {
        return;
    }
    
#if TARGET_OS_IOS || TARGET_OS_TV
    // 记录所有与VC有绑定的请求，
    id vcHashKey = [request.params shellInfo:PJNetworkDataShellTypeVCIdentify];
    if (vcHashKey) {
        NSMutableArray *vcRequestArray = @[].mutableCopy;
        if ([_recordVCRequestList.allKeys containsObject:vcHashKey]) {
            NSArray *tempArr = _recordVCRequestList[vcHashKey];
            if (tempArr && (tempArr.count > 0)) {
                [vcRequestArray addObjectsFromArray:tempArr];
            }
        }
        [vcRequestArray addObject:request];
        _recordVCRequestList[vcHashKey] = vcRequestArray;
    }
#endif
   
    
    request.privateSetSecctionTask(dataTask);
    Lock();
    _allRequestList[@(request.requestTask.taskIdentifier)] = request;
    Unlock();
    [request.requestTask resume];
    
}

/// 获取 sessionTask
- (NSURLSessionTask *)sessionTaskForRequest:(PJRequest *)request error:(NSError * _Nullable __autoreleasing *)error {
    NSArray *httpMethodStringsArray = @[@"GET", @"POST"];
    NSAssert((request.httpMethod<httpMethodStringsArray.count), @"http 请求方法无效");
    
    NSString *requestUrlStr = request.urlString;
    if (!request.disabledBaseUrl && PJNetworkConfig.baseUrlValid()) {
        requestUrlStr = [[PJNetworkConfig shareConfig].baseUrl stringByAppendingPathComponent:requestUrlStr];
    }
    requestUrlStr = [requestUrlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    // 设置header
    NSMutableDictionary *headerInfo = @{}.mutableCopy;
    if (request.header && [request.header isKindOfClass:[NSDictionary class]]) {
        [headerInfo addEntriesFromDictionary:request.header];
    }
    NSDictionary *commonHeader = [PJNetworkConfig shareConfig].commonHeader;
    if (commonHeader && [commonHeader isKindOfClass:[NSDictionary class]]) {
        [headerInfo addEntriesFromDictionary:commonHeader];
    }
    __weak typeof(self) weakSelf = self;
    [headerInfo enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        __strong typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf.sessionManager.requestSerializer setValue:obj forHTTPHeaderField:key];
    }];
    
    _sessionManager.responseSerializer = request.responseSerializer;
    _sessionManager.responseSerializer.acceptableContentTypes = [request acceptableContentTypes];
    NSString *methodString = httpMethodStringsArray[request.httpMethod];
    NSError *serializationError = nil;
    
    
    id paramsObj = @{};
#if TARGET_OS_IOS || TARGET_OS_TV
    paramsObj = [PJNetworkDataShell holyParams:request.params];
#else
    paramsObj = request.params;
#endif
    NSDictionary *commonParams = [PJNetworkConfig shareConfig].commonParams;
    if (commonParams && [commonParams isKindOfClass:[NSDictionary class]]) {
        NSMutableDictionary *finalParams = commonParams.mutableCopy;
        [finalParams addEntriesFromDictionary:((NSDictionary *)paramsObj)];
        paramsObj = finalParams;
    }
    NSMutableURLRequest *temUrlRequest = [_sessionManager.requestSerializer requestWithMethod:methodString URLString:[[NSURL URLWithString:requestUrlStr] absoluteString] parameters:paramsObj error:&serializationError];
    if (serializationError) {
        return nil;
    }
//    if (![_sessionManager.requestSerializer.HTTPMethodsEncodingParametersInURI containsObject:[methodString uppercaseString]] && paramsObj) {
//        NSData *body = [NSJSONSerialization dataWithJSONObject:paramsObj options:kNilOptions error:nil];
//        [temUrlRequest setHTTPBody:body];
//    }
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [_sessionManager dataTaskWithRequest:temUrlRequest
                                     uploadProgress:nil
                                   downloadProgress:nil
                                  completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                                      [self handleRequestResult:dataTask responseObject:responseObject error:error];
                                  }];
    return dataTask;
}

- (void)clearRequestFromListWhenComplete:(id)key
{
    Lock();
    if ([_allRequestList.allKeys containsObject:key]) {
        [_allRequestList removeObjectForKey:key];
    }
    Unlock();
}

- (void)handleRequestResult:(NSURLSessionTask *)task responseObject:(id)responseObject error:(NSError *)error {
    id requestKeyStr = @(task.taskIdentifier);
    Lock();
    PJRequest *request = _allRequestList[requestKeyStr];
    Unlock();
    if (!request) {
        return;
    }
    [self clearRequestFromListWhenComplete:requestKeyStr];
    __block PJRequestCompleteBlock resultBlock = request.requestResultBlock;
    if (!resultBlock) {
        return;
    }
    if (!request || !responseObject || error) {
        if (error) {
            resultBlock(NO, @{@"code":@(error.code), @"des":error.localizedDescription});
        }else{
            NSInteger codeValue = -1000;
            NSString *errDes = !responseObject?@"response NULL!":@"Request invalid!";
            resultBlock(NO, @{@"code":@(codeValue), @"des":errDes});
        }
        return;
    }
    // 状态码异常
    request.taskResponse = task.response;
    NSInteger statusCode = ((NSHTTPURLResponse *)task.response).statusCode;
    if (((statusCode < 200) || (statusCode >= 300))) {
        resultBlock(NO, @{@"code":@(-9101), @"des":@"Http code invalid !"});
        return;
    }
    
    BOOL succeed = NO;
    id resultInfo = nil;
    request.responseObject = responseObject;
    NSError *serializationError = nil;
    NSData *tempData = [NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:&serializationError];
    if (!error) {
        resultInfo = [NSJSONSerialization JSONObjectWithData:tempData options:NSJSONReadingMutableLeaves error:&error];
        succeed = error?NO:YES;
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([PJNetworkConfig shareConfig].responseProcurator) {
            [PJNetworkConfig shareConfig].responseProcurator(resultBlock, succeed, resultInfo);
        } else {
            resultBlock(succeed, resultInfo);
        }
        request.requestResultBlock = nil;
    });
}

@end

@implementation PJNetworkStation (PJNetworkStation_Shortcut)

- (void)requst:(PJHttpMethod)method url:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(PJRequestCompleteBlock)result
{
    PJRequest *request = [PJRequest request:method urlString:url params:params header:header disabledBaseUrl:disabled];
    [self startRequest:request result:result];
}

+ (void)requst:(PJHttpMethod)method url:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(PJRequestCompleteBlock)result
{
    [[PJNetworkStation shareStation] requst:method url:url params:params header:header disabledBaseUrl:disabled result:result];
}

+ (void)POST:(NSString *)url params:(id)params header:(id)header result:(PJRequestCompleteBlock)result
{
    [PJNetworkStation requst:PJHttpMethodPOST url:url params:params header:header disabledBaseUrl:NO result:result];
}

+ (void)POST:(NSString *)url params:(id)params result:(PJRequestCompleteBlock)result{
    [PJNetworkStation POST:url params:params header:nil result:result];
}

+ (void)POST:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(PJRequestCompleteBlock)result
{
    [PJNetworkStation requst:PJHttpMethodPOST url:url params:params header:header disabledBaseUrl:disabled result:result];
}

+ (void)GET:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(PJRequestCompleteBlock)result
{
    [PJNetworkStation requst:PJHttpMethodGET url:url params:params header:header disabledBaseUrl:disabled result:result];
}

+ (void)GET:(NSString *)url params:(id)params result:(PJRequestCompleteBlock)result{
    [PJNetworkStation GET:url params:params header:nil result:result];
}

+ (void)GET:(NSString *)url params:(id)params header:(id)header result:(PJRequestCompleteBlock)result
{
    [PJNetworkStation requst:PJHttpMethodGET url:url params:params header:header disabledBaseUrl:NO result:result];
}

@end
