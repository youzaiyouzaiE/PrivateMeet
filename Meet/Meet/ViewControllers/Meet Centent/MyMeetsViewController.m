//
//  MyMeetsViewController.m
//  Meet
//
//  Created by jiahui on 16/5/14.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MyMeetsViewController.h"

@interface MyMeetsViewController ()



@end

@implementation MyMeetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title =  @"订单中心";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;
    
    //    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    //    [self setNeedsStatusBarAppearanceUpdate];
}


 #pragma mark - Navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     
 }



@end
