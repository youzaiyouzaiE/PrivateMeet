//
//  AddInformationViewController.h
//  Meet
//
//  Created by jiahui on 16/5/5.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, ViewEditType) {
    ViewTypeEdit,
    ViewTypeAdd,
};


@interface AddInformationViewController : UIViewController

@property (strong, nonatomic) NSArray *arrayTitles;
@property (copy, nonatomic) NSString *navTitle;
@property (copy, nonatomic) NSIndexPath *indexPath;
@property (assign, nonatomic) ViewEditType viewType;

@end
