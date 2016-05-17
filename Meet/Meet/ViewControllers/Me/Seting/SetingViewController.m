//
//  SetingViewController.m
//  Meet
//
//  Created by jiahui on 16/5/17.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "SetingViewController.h"
#import "UISheetView.h"

@interface SetingViewController ()<UITableViewDelegate,UITableViewDataSource,UISheetViewDelegate> {
//    NSArray *_contentArray;
    NSDictionary *_contentDic;
    UISheetView *_sheetView;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [UITools customNavigationLeftBarButtonForController:self action:@selector(backButtonAction:)];
    self.navigationItem.title = @"设置";
    
//    _contentArray = @[@"新消息通知",@"清除缓存",@"关于Meet",@"意见反馈",@"给Meet好评",@"退出登录"];
    _contentDic = @{@0:@[@"新消息通知",@"清除缓存"],@1:@[@"关于Meet",@"意见反馈",@"给Meet好评"],@2:@[@"退出登录"]};
    
    _tableView.rowHeight = 49;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)backButtonAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _contentDic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSNumber *keyNumber = [NSNumber numberWithInt:section];
    NSArray *arr = _contentDic[keyNumber];
    return  arr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const defaultIdentifier = @"defaultIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
//        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSNumber *keyNumber = [NSNumber numberWithInt:indexPath.section];
    NSArray *arr = _contentDic[keyNumber];
    cell.textLabel.text = arr[indexPath.row];
    if (indexPath.section == _contentDic.allKeys.count - 1) {
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    } else
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == _contentDic.allKeys.count - 1) {
        if ( !_sheetView) {
            _sheetView = [[UISheetView alloc] initWithContenArray:@[@"退出登录",@"取消"]];
            _sheetView.delegate = self;
        }
        [_sheetView show];
    }
}

#pragma mark - UISheetViewDelegate
- (void)sheetView:(UISheetView *)sheet didSelectRowAtIndex:(NSInteger)index {
    [_sheetView hidden];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
