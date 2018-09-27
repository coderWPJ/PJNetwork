//
//  RequestViewController.h
//  PJNetwork
//
//  Created by wu on 2018/9/27.
//  Copyright © 2018年 wu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RequestType) {
    RequestTypeGet = 0,
    RequestTypePost,
};

@interface RequestViewController : UIViewController

@property (nonatomic, assign) RequestType requestType;

@property (nonatomic, copy) dispatch_block_t backBlock;

@end
