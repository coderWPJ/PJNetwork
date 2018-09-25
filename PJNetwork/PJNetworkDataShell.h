//
//  PJNetworkDataShell.h
//  wpj
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import <Foundation/Foundation.h>

// 一个枚举对应一种壳，对应一个shell key
typedef NS_ENUM(NSInteger, PJNetworkDataShellType) {
    PJNetworkDataShellTypeVCIdentify = 0,
    
};



#if TARGET_OS_IOS || TARGET_OS_TV
    #import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

// shell keys
FOUNDATION_EXPORT NSString *const PJNetworkDataShell_ViewControllerIdentifierKey;

@interface PJNetworkDataShell : NSObject

/**
 加壳，增加/修改附加数据（视图控制器标识）
 
 @param bindVC bindVC
 @param params params
 @return 加壳后数据
 */
+ (NSDictionary *)shellForVCIdentifier:(UIViewController *)bindVC params:(id)params;


/**
 解壳（解除所有附加数据，是所有，需要部分解壳自行封装）
 
 @param params params
 @return 解壳后数据
 */
+ (id)holyParams:(id)params;

/// 弹出某一层壳的数据
+ (id)popShellInfo:(PJNetworkDataShellType)shellType params:(NSDictionary **)params;

+ (id)popAllShellInfo:(NSDictionary **)params;

@end

@interface NSDictionary (PJNetworkDataShell)

/// 获取某一层壳的数据
- (id)shellInfo:(PJNetworkDataShellType)shellType;

- (id)allShellInfo;

@end

NS_ASSUME_NONNULL_END

#endif
