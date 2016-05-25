//
//  BaseMeetViewController.m
//  Meet
//
//  Created by jiahui on 16/5/16.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "BaseMeetViewController.h"

@implementation BaseMeetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 37 - 50) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
}

- (void)loadNewData {
    NSLog(@"load in subclass");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
