//
//  MeViewController.m
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "MeViewController.h"
#import "UINavigationBar+BackgroundColor.h"
#import "ThreeImageCell.h"
#import "MyProfileViewController.h"
#import "MyPhotosViewController.h"
#import "RemindImageCell.h"

@interface MeViewController () <UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource> {
    NSMutableArray *_imagesArray;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title =  @"我";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = NAVIGATION_BAR_COLOR;

    if (IOS_7LAST) {
        self.navigationController.interactivePopGestureRecognizer.delegate = self;
    }
//    [self.tableView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context: nil];
//    [self setNeedsStatusBarAppearanceUpdate];
    _imagesArray = [NSMutableArray array];
    [self checkDocumentGetSmallImages];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
////    return UIStatusBarStyleLightContent;
//}

- (void)checkDocumentGetSmallImages {
    [_imagesArray removeAllObjects];
    NSString *smallFilePath = [AppData getCachesDirectorySmallDocumentPath:FORMAT(@"image%@",[UserInfo shareInstance].userId)];
    NSArray *smallImageParthArray = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:smallFilePath error:nil];
    if (smallImageParthArray.count > 0) {
        [smallImageParthArray enumerateObjectsUsingBlock:^(NSString *fileName, NSUInteger idx, BOOL *stop) {
            UIImage *image = [UIImage imageWithContentsOfFile:[smallFilePath stringByAppendingPathComponent:fileName]];
            [_imagesArray addObject:image];
            if (idx == 2) {
                *stop = YES;
            }
        }];
        [_tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    CGFloat offset = self.tableView.contentOffset.y;
    CGFloat delta = offset / 164.f;
    delta = MAX(0, delta);
    [self.navigationController.navigationBar lt_setBackgroundColor:[[UIColor whiteColor] colorWithAlphaComponent:MIN(1, delta)]];
    
    if (offset > 520) {
        [UIView animateWithDuration:0.3 animations:^{
            self.navigationController.navigationBarHidden = YES;
        }];
        
    } else {
        self.navigationController.navigationBarHidden = NO;
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer.class isSubclassOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        //         NSLog(@"Home interactivePopGestureRecognizer");
    }
    return YES;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     if (indexPath.row == 0) {
         return 84;
     } else  if (indexPath.row == 1) {
         return [ThreeImageCell threeImageCellHeight];
     } else  if (indexPath.row == 2) {
         return 66;
     } else  if (indexPath.row == 3) {
         return [RemindImageCell remindImageCellHeight];
     }
        else
         return 70;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *tableCell;
    if (indexPath.row == 0) {
        NSString *const cellIdentifier = @"MeInfoIdentifierCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        return cell;
    } else if(indexPath.row == 1){
        NSString *const imageCellIdentifier = @"threeImageIdentifierCell";
        ThreeImageCell *cell = [tableView dequeueReusableCellWithIdentifier:imageCellIdentifier];
        if (!cell) {
            cell = [[ThreeImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:imageCellIdentifier];
        }
        if (_imagesArray.count > 0) {
            cell.fristImageView.image = [_imagesArray firstObject];
        }
        if (_imagesArray.count > 1) {
            cell.seconedImageView.image = _imagesArray[1];
        }
        if (_imagesArray.count > 2) {
            cell.thirdImageView.image = _imagesArray[2];
        }
        return cell;
    } else if(indexPath.row == 2){
        NSString *const peopleIdentifier = @"peopleIDIdentifier";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:peopleIdentifier forIndexPath:indexPath];
        return cell;
    } else if(indexPath.row == 3){
         NSString *const myPlanIdentifier = @"myPlanIdentifier";
        RemindImageCell *cell = [tableView dequeueReusableCellWithIdentifier:myPlanIdentifier];
        if (!cell) {
            cell = [[RemindImageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:myPlanIdentifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        ////set image and titl label
        [cell.fristItem imageViewWithImage:[UIImage imageNamed:@"tempImage"] labelTitleText:@"待确认" andRemindText:@"10"];
        [cell.secondItem imageViewWithImage:[UIImage imageNamed:@"tempImage"] labelTitleText:@"待付款" andRemindText:@"133"];
        [cell.thirdItem imageViewWithImage:[UIImage imageNamed:@"tempImage"] labelTitleText:@"待见面" andRemindText:@"3"];
        [cell.fourItem imageViewWithImage:[UIImage imageNamed:@"tempImage"] labelTitleText:@"全部约会" andRemindText:@"20"];
        [cell addTapGestureRecognizers];
        
        return  cell;
    } else {
        NSString *const defaultIdentifier = @"defaultIdentifier";
        tableCell = [tableView dequeueReusableCellWithIdentifier:defaultIdentifier];
        if (!tableCell) {
            tableCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:defaultIdentifier];
            tableCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        tableCell.imageView.image = [UIImage imageNamed:@"unLike"];
        tableCell.textLabel.text = @"xxxxxxxxxx";
    }
    return tableCell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 1) {
        ThreeImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setViewsFrame];
    } else if(indexPath.row == 3){
        RemindImageCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [cell setSubViewsFrame];
    }
}

#pragma mark - tableView Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
        MyProfileViewController *myProfileVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
        [self.navigationController pushViewController:myProfileVC animated:YES];
    } else  if (indexPath.row == 1) {
//        UIStoryboard *meStoryBoard = [UIStoryboard storyboardWithName:@"Me" bundle:[NSBundle mainBundle]];
//        MyPhotosViewController *myPhotsVC = [meStoryBoard instantiateViewControllerWithIdentifier:@"MyPhotosViewController"];
//        [self.navigationController pushViewController:myPhotsVC animated:YES];
        [self performSegueWithIdentifier:@"MePushToMyPhoto" sender:self];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MePushToMyPhoto"]) {
        MyPhotosViewController *myPhotoVC = (MyPhotosViewController *)[segue destinationViewController];
        myPhotoVC.updateBlock = ^(BOOL isNeed){
            if (isNeed) {
                [self checkDocumentGetSmallImages];
            }
        };
    }
}

- (void)dealloc {
    [self.tableView removeObserver:self forKeyPath:@"contentOffset"];
}

@end
