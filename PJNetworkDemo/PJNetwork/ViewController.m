//
//  ViewController.m
//  PJNetwork
//
//  Created by Daniel on 2018/9/19.
//  Copyright © 2018年 wu. All rights reserved.
//

#import "ViewController.h"

#import <PJNetwork.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [PJNetworkStation GET:@"http://lf.snssdk.com/api/2/article/v35/stream/" params:nil header:nil result:^(BOOL success, id info) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
