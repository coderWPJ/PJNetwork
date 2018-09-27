//
//  HostNetworkLayer.m
//  PJNetwork
//
//  Created by Daniel on 2018/9/27.
//  Copyright © 2018年 wu. All rights reserved.
//

#import "HostNetworkLayer.h"

@implementation HostNetworkLayer

+ (PJRequestCompleteBlock(^)(PJRequestCompleteBlock resultBlock))handleResult
{
    return ^(PJRequestCompleteBlock resultBlock){
        return ^(BOOL success, id info){
            if (!success) {
                NSString *errTip = ([info isKindOfClass:[NSString class]])?info:@"请求失败";
                if ([info isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *tempDict = info;
                    if ([tempDict.allKeys containsObject:@"code"] && [tempDict.allKeys containsObject:@"des"]) {
                        errTip = tempDict[@"des"];
                    }
                }
                resultBlock(NO, errTip);
            }else{
                if ([info isKindOfClass:[NSDictionary class]] && info != nil) {
                    if ([[info objectForKey:@"success"] boolValue]) {
                        NSDictionary *retData = [info objectForKey:@"data"];
                        resultBlock(YES,retData);
                    }else{
                        if ([[info objectForKey:@"errorCode"] integerValue] == 99999) {
                            // token 过期，客户端需要主动退出登录
                        }else{
                            NSString *errMsg = [info objectForKey:@"errorMsg"]?:@"未知错误";
                            resultBlock(NO,errMsg);
                        }
                    }
                }else{
                    resultBlock(NO,@"服务器出错了");
                }
            }
        };
    };
}

// GET
+ (void)get:(NSString *)methodCode params:(id)params complete:(PJRequestCompleteBlock)complete
{
    NSDictionary *tempParams = params?params:@{};
    NSString *requestURL = @"";
    NSDictionary *headDict = [self httpHeaderWithMethodCode:methodCode version:@"7"];
    
    [PJNetworkStation GET:requestURL params:tempParams header:headDict disabledBaseUrl:YES result:HostNetworkLayer.handleResult(complete)];
}
// POST
+ (void)post:(NSString *)methodCode params:(id)params header:(id)header complete:(PJRequestCompleteBlock)complete
{
    NSDictionary *tempParams = params?params:@{};
    NSDictionary *headDict = header?:[self httpHeaderWithMethodCode:methodCode version:@"7"];
    NSString *requestURL = @"";
    [PJNetworkStation POST:requestURL params:tempParams header:headDict disabledBaseUrl:YES result:HostNetworkLayer.handleResult(complete)];
}

// 构造header   businessCode  用默认值（40003）
+ (NSDictionary *)httpHeaderWithMethodCode:(NSString *)methodCodeStr version:(NSString *)version
{
    return [HostNetworkLayer httpHeaderWithServiceCode:@"40003" methodCode:methodCodeStr version:version];
}

// 构造header
+ (NSDictionary *)httpHeaderWithServiceCode:(NSString *)serviceCodeStr methodCode:(NSString *)methodCodeStr version:(NSString *)version
{
    return [HostNetworkLayer httpHeaderWithServiceCode:serviceCodeStr methodCodeStr:methodCodeStr version:version imei:nil];
}

// 构造header
+ (NSDictionary *)httpHeaderWithServiceCode:(NSString *)serviceCodeStr methodCodeStr:(NSString *)methodCodeStr version:(NSString *)version imei:(NSString *)imei
{
    return @{@"imei":imei?:@"xxxxx",
             @"serviceCode":serviceCodeStr?:@"",
             @"methodCode":methodCodeStr?:@"",
             @"v":version?:@"1",
             @"token":@"",
             @"appName":@"ios-xxxxxx"};
}

@end
