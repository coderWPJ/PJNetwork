//
//  JJSRequest.h
//  JJSOptionalExam
//
//  Created by wu on 2018/8/3.
//  Copyright © 2018年 JJSHome. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^ RequestCompleteBlock) (BOOL success, id info);

typedef NS_ENUM(NSUInteger, JJSHttpMethod) {
    JJSHttpMethodGET = 0,
    JJSHttpMethodPOST,
};

typedef NS_ENUM(NSUInteger, JJSRequestSerializerType) {
    JJSRequestSerializerTypeJSON = 0,
    JJSRequestSerializerTypeHTTP = 1,
};

typedef NS_ENUM(NSInteger, JJSResponseSerializerType) {
    JJSResponseSerializerTypeHTTP = 0,
    JJSResponseSerializerTypeJSON,
};

@interface JJSRequest : NSObject


@end
