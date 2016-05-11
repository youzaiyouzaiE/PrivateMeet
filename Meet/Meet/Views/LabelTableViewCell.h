//
//  LabelTableViewCell.h
//  Meet
//
//  Created by jiahui on 16/5/11.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)labeAddLayerMargin:(BOOL)isSet andSetLabelText:(NSString *)text;
@end
