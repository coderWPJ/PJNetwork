//
//  PJNetworkConfig.h
//  JJSOptionalExam
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PJNetworkConfig : NSObject

/**
 用于 request 的 baseUrl ，如各种 Host
 */
@property (nonatomic, copy) NSString *baseUrl;


/**
 弃用蜂窝移动网络？ 默认为NO
 */
@property (nonatomic, assign, readonly) BOOL cellularDisabled;

/// 蜂窝网络是否可用
+ (BOOL (^)())cellularDisabled;

/// 设置蜂窝网络是否可用
+ (void (^)(BOOL beDisabled))cellularShouldBeDisabled;

/// baseUrl是否有效
+ (BOOL (^)(void))baseUrlValid;

+ (instancetype)shareConfig;

+ (instancetype)shareConfig:(NSString *)baseUrl;

+ (instancetype)resetConfig:(NSString *)newBaseUrl;

@end
