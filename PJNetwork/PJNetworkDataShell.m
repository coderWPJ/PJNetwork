//
//  PJNetworkDataShell.m
//  JJSOptionalExam
//
//  Created by wpj on 2018/9/21.
//  Copyright © 2018年 wpj. All rights reserved.
//

#import "PJNetworkDataShell.h"

#if TARGET_OS_IOS || TARGET_OS_TV

NSString * const PJNetworkDataShell_ViewControllerIdentifierKey = @"com.pj.networking.viewcontroller.hashValue";

@implementation PJNetworkDataShell

/// 加壳数据不能为空，且必须为字典数据
+ (BOOL)isValueableParams:(id)params
{
    if (!params || (![params isKindOfClass:[NSDictionary class]])) {
        return NO;
    }
    return YES;
}



// 加壳，增加/修改附加数据（视图控制器标识）
+ (NSDictionary *)shellForVCIdentifier:(UIViewController *)bindVC params:(id)params
{
    if (![PJNetworkDataShell isValueableParams:params]) {
        NSAssert(params, @"Data for shell mast be a nonnull dictionary value");
        return nil;
    }
    NSMutableDictionary *retParams = [NSMutableDictionary dictionaryWithDictionary:params];
    retParams[PJNetworkDataShell_ViewControllerIdentifierKey] = @(bindVC.hash);
    return retParams;
}

// 解壳（解除所有附加数据，是所有，需要部分解壳自行封装）
+ (id)holyParams:(id)params
{
    if (![PJNetworkDataShell isValueableParams:params]) {
        //        NSAssert(params, @"Data for shell mast be a nonnull dictionary value");
        return nil;
    }
    NSMutableDictionary *retParams = [NSMutableDictionary dictionaryWithDictionary:params];
    [retParams removeObjectsForKeys:[PJNetworkDataShell shellKeysArray]];
    return retParams;
}

+ (NSArray <NSString *>*)shellKeysArray
{
    return @[PJNetworkDataShell_ViewControllerIdentifierKey,
             ];
}

/// 弹出某一层壳的数据
+ (id)popShellInfo:(PJNetworkDataShellType)shellType params:(NSDictionary **)params
{
    NSString *shellKey = [[PJNetworkDataShell shellKeysArray] objectAtIndex:shellType];
    NSDictionary *tempPam = *params;
    NSMutableDictionary *mutableDict = tempPam.mutableCopy;
    if ([mutableDict.allKeys containsObject:shellKey]) {
        id retObj = mutableDict[shellKey];
        [mutableDict removeObjectForKey:shellKey];
        *params = mutableDict;
        return retObj;
    }
    return nil;
}

+ (id)popAllShellInfo:(NSDictionary **)params
{
    NSDictionary *tempPam = *params;
    NSMutableDictionary *mutableDict = tempPam.mutableCopy;
    NSMutableDictionary *retDict = @{}.mutableCopy;
    [[PJNetworkDataShell shellKeysArray] enumerateObjectsUsingBlock:^(NSString * _Nonnull shellKey, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([mutableDict.allKeys containsObject:shellKey]) {
            retDict[shellKey] = mutableDict[shellKey];
            [mutableDict removeObjectForKey:shellKey];
        }
    }];
    *params = mutableDict;
    return retDict;
}

@end

@implementation NSDictionary (PJNetworkDataShell)

- (id)allShellInfo
{
    NSMutableDictionary *retDict = @{}.mutableCopy;
    [[PJNetworkDataShell shellKeysArray] enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([self.allKeys containsObject:obj]) {
            retDict[obj] = self[obj];
        }
    }];
    return retDict;
}

/// 获取某一层壳的数据
- (id)shellInfo:(PJNetworkDataShellType)shellType
{
    NSString *shellKey = [[PJNetworkDataShell shellKeysArray] objectAtIndex:shellType];
    if ([self.allKeys containsObject:shellKey]) {
        return self[shellKey];
    }
    return nil;
}

/// 加过某一种类型的数据
- (BOOL)haveShelled:(PJNetworkDataShellType)shellType
{
    NSString *shellKey = [[PJNetworkDataShell shellKeysArray] objectAtIndex:shellType];
    return [self.allKeys containsObject:shellKey];
}

@end

#endif
