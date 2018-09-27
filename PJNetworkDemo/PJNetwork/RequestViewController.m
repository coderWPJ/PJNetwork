//
//  RequestViewController.m
//  PJNetwork
//
//  Created by wu on 2018/9/27.
//  Copyright © 2018年 wu. All rights reserved.
//

#import "RequestViewController.h"
#import <PJNetwork.h>
#import "GetListModel.h"
#import <MJExtension.h>

@interface RequestViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *exampleTableView;

@property (nonatomic, strong) NSMutableArray *dataSourceArray;


@end

@implementation RequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpSubviews];
    
    [self requestInfo];
    
}


#pragma mark -
#pragma mark - tableView dataSource && delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSourceArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellReuseIdentify = @"cellReuseIdentify111";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentify];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellReuseIdentify];
    }
    GetListModel *cellModel = _dataSourceArray[indexPath.row];
    cell.textLabel.text = cellModel.title;
    cell.detailTextLabel.text = [@"主播: " stringByAppendingString:cellModel.nickname];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)setUpSubviews
{
    _exampleTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _exampleTableView.frame = self.view.bounds;
    _exampleTableView.delegate = self;
    _exampleTableView.dataSource = self;
    _exampleTableView.tableFooterView = [UIView new];
    _exampleTableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_exampleTableView];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

- (void)goBack
{
    if (self.backBlock) {
        self.backBlock();
    }
}

- (void)requestInfo
{
    NSString *urlString = @"http://mobile.ximalaya.com/mobile/v1/album/track?albumId=203355&device=android&isAsc=true&pageId=4&pageSize=20&statEvent=pageview%2Falbum%40203355&statModule=%E6%9C%80%E5%A4%9A%E6%94%B6%E8%97%8F%E6%A6%9C&statPage=ranklist%40%E6%9C%80%E5%A4%9A%E6%94%B6%E8%97%8F%E6%A6%9C&statPosition=8";
    self.navigationItem.title = [@[@"get 请求", @"post 请求"] objectAtIndex:self.requestType];
    
    if (self.requestType == RequestTypeGet) {
        __weak typeof(self) weakSelf = self;
        [PJNetworkStation GET:urlString params:nil header:nil result:^(BOOL success, id info) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
               [strongSelf handleResult:info];
            }else{
                /// 提示错误信息
            }
        }];
    }else{
        self.navigationItem.title = @"post 请求";
        __weak typeof(self) weakSelf = self;
        [PJNetworkStation POST:urlString params:nil header:nil result:^(BOOL success, id info) {
            __strong typeof(weakSelf) strongSelf = weakSelf;
            if (success) {
                [strongSelf handleResult:info];
            }else{
                /// 提示错误信息
            }
        }];
    }
}

- (void)handleResult:(id)info
{
    NSInteger retValue = [info[@"ret"] integerValue];
    if (retValue == 0) {
        id dataObj = info[@"data"];
        if (dataObj && [dataObj isKindOfClass:[NSDictionary class]]) {
            id listObj = dataObj[@"list"];
            if (listObj && [listObj isKindOfClass:[NSArray class]]) {
                self.dataSourceArray = [GetListModel mj_objectArrayWithKeyValuesArray:listObj];
                [self.exampleTableView reloadData];
            }
        }
    }else{
        /// 提示错误信息
    }
}

@end
