//
//  PJNetworkConfig.m
//  PJNetwork
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import "PJNetworkConfig.h"

@interface PJNetworkConfig ()

@property (nonatomic, assign) BOOL cellularDisabled;

@end

@implementation PJNetworkConfig

+ (BOOL (^)(void))cellularDisabled
{
    return ^(){
        PJNetworkConfig *networkConfig = [PJNetworkConfig shareConfig];
        return networkConfig.cellularDisabled;
    };
}

/// 设置蜂窝网络是否可用
+ (void (^)(BOOL beDisabled))cellularShouldBeDisabled
{
    return ^(BOOL beDisabled) {
        PJNetworkConfig *networkConfig = [PJNetworkConfig shareConfig];
        networkConfig.cellularDisabled = beDisabled;
    };
}

+ (BOOL (^)(void))baseUrlValid
{
    return ^(void){
        NSString *baseUrl = [PJNetworkConfig shareConfig].baseUrl;
        BOOL isValid = (baseUrl && (baseUrl.length > 0));
        return isValid;
    };
}

+ (instancetype)shareConfig
{
    static PJNetworkConfig *shareConfig = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareConfig = [[PJNetworkConfig alloc] init];
        shareConfig.cellularDisabled = NO;
        shareConfig.timeoutInterval = 45.0f;
    });
    return shareConfig;
}

+ (instancetype)shareConfig:(NSString *)baseUrl
{
    PJNetworkConfig *networkConfig = [PJNetworkConfig shareConfig];
    networkConfig.baseUrl = baseUrl;
    return networkConfig;
}

+ (instancetype)resetConfig:(NSString *)newBaseUrl
{
    PJNetworkConfig *networkConfig = [PJNetworkConfig shareConfig];
    networkConfig.baseUrl = newBaseUrl;
    return networkConfig;
}

@end
