//
//  ViewController.m
//  PJNetwork
//
//  Created by Daniel on 2018/9/19.
//  Copyright © 2018年 wu. All rights reserved.
//

#import "ViewController.h"
#import "RequestViewController.h"

@interface ViewController () <UITableViewDelegate, UITableViewDataSource>
{
    NSArray *_dataSourceArray;
}
@property (nonatomic, strong) UITableView *tableView;
@property (weak, nonatomic) IBOutlet UITableView *hostTableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSourceArray = @[@"get 请求", @"post请求"];
    
    _hostTableView.delegate = self;
    _hostTableView.dataSource = self;
    _hostTableView.tableFooterView = [UIView new];
    
    
    
}

#pragma mark -
#pragma mark - tableView dataSource && delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentify = @"cellReuseIdentify";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseIdentify];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    cell.textLabel.text = _dataSourceArray[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RequestViewController *requestVC = [[RequestViewController alloc] init];
    requestVC.requestType = indexPath.row;
    
    UINavigationController *navVC = [[UINavigationController alloc] initWithRootViewController:requestVC];
    
    [requestVC setBackBlock:^{
        [navVC dismissViewControllerAnimated:YES completion:nil];
    }];
    [self presentViewController:navVC animated:YES completion:nil];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
