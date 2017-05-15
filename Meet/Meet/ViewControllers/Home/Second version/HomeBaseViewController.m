//
//  HomeBaseViewController.m
//  Meet
//
//  Created by jiahui on 16/4/28.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "HomeBaseViewController.h"

@interface HomeBaseViewController ()

@end

@implementation HomeBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 64 - 37 - 50) style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    
   
}

- (void)loadNewData {
     NSLog(@"load in subclass");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



@end
