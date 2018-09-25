//
//  PJNetworkStation.h
//  PJOptionalExam
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//


/*************
 NOTE:
 
 使用方法：步骤一：构建 PJRequest 请求体对象
 步骤二：利用 PJNetworkStation 的下面2种方法请求（类方法会调用对象方法）
 1. 对象方法      startRequest:result:
 2. 类方法        request:result:
 
 (或者用 PJNetworkStation_Shortcut 分类中快速请求，封装了是上面2步)
 
 
 目前已实现功能
 1、常用请求 GET，POST
 2、请求绑定视图控制器生存周期（dealloc时cancel请求）
 
 doing ...
 
 
 ToDoList:
 1、上传
 2、下载
 
 **************/

#import <Foundation/Foundation.h>
#import "PJRequest.h"
#import "PJNetworkDataShell.h"

FOUNDATION_EXPORT NSString *const PJNetwork_VCDealloc_Notitication;

@interface PJNetworkStation : NSObject

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/**
 初始化方法
 */
+ (instancetype)shareStation;

- (void)startRequest:(PJRequest *)request result:(RequestCompleteBlock)result;
+ (void)request:(PJRequest *)request result:(RequestCompleteBlock)result;

@end

/////////   下面是一些快捷请求方式

@interface PJNetworkStation (PJNetworkStation_Shortcut)

- (void)requst:(PJHttpMethod)method url:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(RequestCompleteBlock)result;

+ (void)requst:(PJHttpMethod)method url:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(RequestCompleteBlock)result;


/**
 POST 请求  （disabledBaseUrl默认为NO）
 
 @param url url
 @param params params
 @param header header
 @param result result
 */
+ (void)POST:(NSString *)url params:(id)params header:(id)header result:(RequestCompleteBlock)result;
+ (void)POST:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(RequestCompleteBlock)result;

/**
 GET 请求  （disabledBaseUrl默认为NO）
 
 @param url url
 @param params params
 @param header header
 @param result result
 */
+ (void)GET:(NSString *)url params:(id)params header:(id)header result:(RequestCompleteBlock)result;
+ (void)GET:(NSString *)url params:(id)params header:(id)header disabledBaseUrl:(BOOL)disabled result:(RequestCompleteBlock)result;

@end
