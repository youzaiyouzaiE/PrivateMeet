//
//  TextViewCell.h
//  Meet
//
//  Created by jiahui on 16/5/4.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CellPlaceHolderTextView.h"
#import "UITextView+Placeholder.h"
#import "CellTextView.h"

@interface TextViewCell : UITableViewCell

@property (strong, nonatomic) CellTextView *textView;
@property (strong, nonatomic) NSIndexPath *indexPath;

@end
