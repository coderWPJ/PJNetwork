//
//  PJNetworkSessionManager.h
//  JJSOptionalExam
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking/AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface PJNetworkSessionManager : AFHTTPSessionManager

@end
