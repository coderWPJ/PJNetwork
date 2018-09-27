//
//  HostNetworkLayer.h
//  PJNetwork
//
//  Created by Daniel on 2018/9/27.
//  Copyright © 2018年 wu. All rights reserved.
//

/**
 开发中遇到过2种类型的接口区分方式：
 1. 接口 url 地址唯一
 2. 为每个接口分配唯一方法码(如methodCode)，  同时也可在此基础上为一批接口单独分配业务码（businessCode），业务码与方法码同理此demo不阐述
 
 此类仅为示例网络层，为上述两种都展示了较为简洁的封装方式供外界调用，建议对于业务逻辑较为的App（网络层庞大），在此基础上合理的细分很有意义，
 比如考虑将此类下沉为基类对每个大型业务模块细分。
 
 */

#import <Foundation/Foundation.h>
#import <PJNetwork.h>

@interface HostNetworkLayer : NSObject


/**
 GET 请求

 @param methodCode methodCode
 @param params 参数
 @param complete 回调
 */
+ (void)get:(NSString *)methodCode params:(id)params complete:(PJRequestCompleteBlock)complete;


//

/**
 POST 请求

 @param methodCode methodCode
 @param params 参数
 @param header header
 @param complete 回调
 */
+ (void)post:(NSString *)methodCode params:(id)params header:(id)header complete:(PJRequestCompleteBlock)complete;


// 构造header   businessCode  用默认值（40003）
+ (NSDictionary *)httpHeaderWithMethodCode:(NSString *)methodCodeStr version:(NSString *)version;


// 构造header
+ (NSDictionary *)httpHeaderWithServiceCode:(NSString *)serviceCodeStr methodCodeStr:(NSString *)methodCodeStr version:(NSString *)version imei:(NSString *)imei;


@end
