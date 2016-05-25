//
//  ChoicenessViewController.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ChoicenessViewController.h"
#import "ManListCell.h"
//#import "LoginMainViewController.h"
#import "WeChatResgisterViewController.h"

@interface ChoicenessViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ChoicenessViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 100;

//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        // 进入刷新状态后会自动调用这个block
//    }];
//    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
//    [self.tableView.mj_header beginRefreshing];
}

- (void)loadNewData {
     NSLog(@"ChoicenessViewController refreshing");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 70;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *const cellIdentifier = @"choicenessCell";
    ManListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = (ManListCell *)[[NSBundle mainBundle] loadNibNamed:@"ManListCell" owner:self options:nil][0];
    }
//    cell.textLabel.text = FORMAT(@"choicenessCell %ld",(long)indexPath.row);
    return cell;
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([AppData shareInstance].isLogin) {
        
    } else {
        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Login" bundle:[NSBundle mainBundle]];
//        LoginMainViewController *login = [meStoryBoard instantiateViewControllerWithIdentifier:@"loginMainNavigation"];

        WeChatResgisterViewController *resgisterVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"WeChatResgisterNavigation"];
        [self presentViewController:resgisterVC animated:YES completion:^{
            
                    }];
    }
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
