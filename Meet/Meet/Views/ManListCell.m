//
//  ManListCell.m
//  Meet
//
//  Created by jiahui on 16/4/29.
//  Copyright © 2016年 Meet. All rights reserved.
//

#import "ManListCell.h"

@implementation ManListCell
{

    
    __weak IBOutlet UILabel *_nameLabel;


    
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _iconImage.layer.cornerRadius = 40;
    _iconImage.layer.masksToBounds = YES;
    _likeNumberLabel.text = @"99";
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)likeButtonAction:(id)sender {
    
    
}



@end
