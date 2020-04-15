//
//  PJNetworkConfig.h
//  PJNetwork
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ PJNetworkConfigMonitorBlock) (BOOL success, id info);

@interface PJNetworkConfig : NSObject

/**
 用于 request 的 baseUrl ，如各种 Host
 */
@property (nonatomic, copy) NSString *baseUrl;

/**
 通用请求头（若存在key与请求model的header中内容重复，则优先级低于请求model）
*/
@property (nonatomic, strong) NSDictionary *commonHeader;

/**
 通用请求参数（若存在key与请求model的params中内容重复，则优先级低于请求model）
*/
@property (nonatomic, strong) NSDictionary *commonParams;

/**
 请求拦截器，方便业务方统一处理回调
*/
@property (nonatomic, copy) void (^ requestInterceptor)(PJNetworkConfigMonitorBlock resultBlock, BOOL success, id info);
/**
 超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;

// 客户端是否信任非法证书
@property (nonatomic, assign) BOOL allowInvalidCertificates;
// 是否在证书域字段中验证域名
@property (nonatomic, assign) BOOL validatesDomainName;

/**
 弃用蜂窝移动网络？ 默认为NO
 */
@property (nonatomic, assign, readonly) BOOL cellularDisabled;

/// 蜂窝网络是否可用
+ (BOOL (^)(void))cellularDisabled;
/// 设置蜂窝网络是否可用
+ (void (^)(BOOL beDisabled))cellularShouldBeDisabled;

/// baseUrl是否有效
+ (BOOL (^)(void))baseUrlValid;

+ (instancetype)shareConfig;

+ (instancetype)shareConfig:(NSString *)baseUrl;

+ (instancetype)resetConfig:(NSString *)newBaseUrl;

@end
